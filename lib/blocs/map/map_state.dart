part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoutes;
  final RouteDestination? pointsCar;
  final RouteDestination? pointsPeople;

  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  final bool isVehicle;
  final bool isContainPolylines;
  /*
  mi_ruta: {
    id: polylineID Google,
    points: [ [lat,lng], [122333,1212123], [121212,232323]],
    width: 3,
    color: black
  }
  */

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showMyRoutes = false,
    this.pointsCar,
    this.pointsPeople, 
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    this.isVehicle = true,
    this.isContainPolylines = false,
  })  : polylines = polylines ?? const {},
        markers = markers ?? const {};

  MapState copyWith(
          {bool? isMapInitialized,
          bool? isFollowingUser,
          bool? showMyRoutes,
          RouteDestination? pointsCar,
          RouteDestination? pointsPeople,

          Map<String, Polyline>? polylines,
          Map<String, Marker>? markers,
          bool? isVehicle,
          bool? isContainPolylines,
          }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        showMyRoutes: showMyRoutes ?? this.showMyRoutes,
        pointsCar: pointsCar ?? this.pointsCar,
        pointsPeople: pointsPeople ?? this.pointsPeople,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
        isVehicle: isVehicle ?? this.isVehicle,
        isContainPolylines: isContainPolylines ?? this.isContainPolylines,
      );

  @override
  List<Object?> get props => [
    isMapInitialized, 
    isFollowingUser, 
    showMyRoutes, 
    pointsCar, 
    pointsPeople, 
    polylines, 
    markers, 
    isVehicle,
    isContainPolylines,
  ];
}
