part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;
  const OnMapInitializedEvent(this.controller);
}

class OnStopFollowingUserEvent extends MapEvent {}

class OnStartFollowingUserEvent extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userLocations;
  const UpdateUserPolylineEvent(this.userLocations);
}

class OnToggleUserRoute extends MapEvent {}

class DisplayPolylinesEvente extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  const DisplayPolylinesEvente(this.polylines, this.markers);
}

class DisplayPolylinesEvent2 extends MapEvent {
  final Map<String, Polyline> polylines;

  const DisplayPolylinesEvent2(this.polylines);
}

class  CargarPuntosEvent extends MapEvent {
  final RouteDestination pointsCar;
  final RouteDestination pointsPeople;

  const CargarPuntosEvent(this.pointsCar, this.pointsPeople);
}

class DisplayPolylinesEventPruebaCar extends MapEvent {}

class DisplayPolylinesEventPruebaPeople extends MapEvent {}

class ChangeIsVehicleEvent extends MapEvent {
  final bool isVehicle;

  const ChangeIsVehicleEvent(this.isVehicle);
}

class ChangeIsContarinPolylinesEvent extends MapEvent {
  final bool isContainPolylines;

  const ChangeIsContarinPolylinesEvent(this.isContainPolylines);
}

class  LimpiarPuntosCarPeopleEvent extends MapEvent {}
