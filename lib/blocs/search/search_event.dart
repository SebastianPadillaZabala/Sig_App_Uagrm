part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateInfoRouteEvent extends SearchEvent {}
class OnDeactivateInfoRouteEvent extends SearchEvent {}

class OnActivateManualMarkerEvent extends SearchEvent {}
class OnDeactivateManualMarkerEvent extends SearchEvent {}

class OnSetOrigin extends SearchEvent {
  final PointOrigin pointOrigin;

  const OnSetOrigin(this.pointOrigin);
}

class OnSetDestination extends SearchEvent {
  final PlaceList pointDestino;

  const OnSetDestination(this.pointDestino);
}

class OnNewPlacesFoundEvent extends SearchEvent {
  final List<Feature> places;

  const OnNewPlacesFoundEvent(this.places);
}

class AddToHistoryEvent extends SearchEvent {
  final Feature place;

  const AddToHistoryEvent(this.place);

}
