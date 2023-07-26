part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayInfoRoute;
  final bool displayManualMarker;
  final PointOrigin? pointOrigin;
  final PlaceList? pointDestino; 
  final List<Feature> places;
  final List<Feature> history;

  const SearchState({
    this.displayInfoRoute = false,
    this.displayManualMarker = false,
    this.pointOrigin,
    this.pointDestino,
    this.places = const [],
    this.history = const [],
  });

  SearchState copyWith({
    bool? displayInfoRoute,
    bool? displayManualMarker,
    PointOrigin? pointOrigin,
    PlaceList? pointDestino,
    List<Feature>? places,
    List<Feature>? history
  }) =>
      SearchState(
        displayInfoRoute: displayInfoRoute ?? this.displayInfoRoute,
        displayManualMarker: displayManualMarker ?? this.displayManualMarker,
        pointOrigin: pointOrigin ?? this.pointOrigin,
        pointDestino: pointDestino ?? this.pointDestino,
        places: places ?? this.places,
        history: history ?? this.history,
      );

  @override
  List<Object?> get props => [displayInfoRoute, displayManualMarker, pointOrigin, pointDestino, places, history];
}
