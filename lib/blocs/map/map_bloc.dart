import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/themes/themes.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));
    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    on<OnToggleUserRoute>((event, emit) =>
        emit(state.copyWith(showMyRoutes: !state.showMyRoutes)));
    on<DisplayPolylinesEvente>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));
    on<DisplayPolylinesEvent2>(
        (event, emit) => emit(state.copyWith(polylines: event.polylines)));
    on<CargarPuntosEvent>((event, emit) => emit(state.copyWith(
        pointsCar: event.pointsCar, pointsPeople: event.pointsPeople)));
        
    on<ChangeIsVehicleEvent>(
        (event, emit) => emit(state.copyWith(isVehicle: event.isVehicle)));
    on<ChangeIsContarinPolylinesEvent>(
        (event, emit) => emit(state.copyWith(isContainPolylines: event.isContainPolylines)));

    on<LimpiarPuntosCarPeopleEvent>((event, emit) => emit(state.copyWith(pointsCar: null, pointsPeople: null)),);

    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnownLocation != null) {
        add(UpdateUserPolylineEvent((locationState.myLocationHistory)));
      }
      if (!state.isFollowingUser) return;
      if (locationState.lastKnownLocation == null) return;

      moveCamera(locationState.lastKnownLocation!);
    });
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocations);

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  Future cleanMap() async {
    final currentMarkers = Map<String, Marker>.from(state.markers);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);    
    currentMarkers.clear();
    currentPolylines.clear();
    add(LimpiarPuntosCarPeopleEvent());
    add(DisplayPolylinesEvente(currentPolylines, currentMarkers));
  }

  void drawRoutePolyline(
      double lat, double long, String lugar, String modulo) async {
    await cleanMap();
    final endMarker = Marker(
        markerId: const MarkerId('Lugar'),
        position: LatLng(long, lat),
        infoWindow: InfoWindow(
          title: lugar,
          snippet: 'Modulo: ${modulo}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));

    final currentMarkers = Map<String, Marker>.from(state.markers);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentMarkers['Lugar'] = endMarker;
    add(DisplayPolylinesEvente(currentPolylines, currentMarkers));
    await Future.delayed(const Duration(milliseconds: 300));
    _mapController?.showMarkerInfoWindow(const MarkerId('Lugar'));
  }

  void cargarPuntos(RouteDestination pointsCar, RouteDestination pointsPeople) {
    add(CargarPuntosEvent(pointsCar, pointsPeople));
    add(const ChangeIsContarinPolylinesEvent(true));
    //cleanMap();
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }

  Future dibujarRuta(RouteDestination destination) async {
  List<LatLng> pLineCoordinatesList = [];
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList =
        pPoints.decodePolyline(destination.e_points);

    pLineCoordinatesList.clear();
    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    await cleanMap();
    final myRoute;
    if (state.isVehicle) {
       myRoute = Polyline(
        polylineId: const PolylineId('route2'),
        color: const Color.fromRGBO(136, 0, 0, 1),
        width: 9,
        points: pLineCoordinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        jointType: JointType.round,
      );
    } else {
       myRoute = Polyline(
        polylineId: const PolylineId('route2'),
        color: const Color.fromRGBO(42, 57, 100, 1),
        width: 9,
        points: pLineCoordinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        jointType: JointType.round,
        patterns: [
          PatternItem.gap(5),
          PatternItem.dot
        ],
      );
    }

    final endMarker = Marker(
        markerId:  const MarkerId('Lugar'),
        position: pLineCoordinatesList.last,
        infoWindow:  InfoWindow(
          title: destination.endPlace,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
    
    final originMarker = Marker(
        markerId:  const MarkerId('Origen'),
        position: pLineCoordinatesList.first,
         infoWindow: const InfoWindow(
          title: 'Punto de origen',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

    final currentMarkers = Map<String, Marker>.from(state.markers);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;
    currentMarkers['Lugar'] = endMarker;
    currentMarkers['Origen'] = originMarker;

    add(DisplayPolylinesEvente(currentPolylines, currentMarkers));
    await Future.delayed(const Duration(milliseconds: 300));
    _mapController?.showMarkerInfoWindow(const MarkerId('Lugar'));
    final LatLngBounds bounds = calculateLatLngBounds(pLineCoordinatesList);
    moveCameraBounds(bounds);
  }

  void moveCameraBounds( LatLngBounds bounds ) {
    double padding = 20;
    _mapController?.animateCamera(
    CameraUpdate.newLatLngBounds(
        bounds,
        padding,
      ),
    );
  }

  LatLngBounds calculateLatLngBounds(List<LatLng> routePoints) {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (LatLng point in routePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLng southwest = LatLng(minLat, minLng);
    LatLng northeast = LatLng(maxLat, maxLng);

    return LatLngBounds(southwest: southwest, northeast: northeast);
  }
}
