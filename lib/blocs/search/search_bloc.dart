import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';
import 'package:http/http.dart' as http;

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivateInfoRouteEvent>(
        (event, emit) => emit(state.copyWith(displayInfoRoute: true)));
    on<OnDeactivateInfoRouteEvent>(
        (event, emit) => emit(state.copyWith(displayInfoRoute: false)));

    on<OnActivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: true)));
    on<OnDeactivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: false)));
    
    on<OnSetOrigin>((event, emit) => emit(state.copyWith(pointOrigin: event.pointOrigin)));
    on<OnSetDestination>((event, emit) => emit(state.copyWith(pointDestino: event.pointDestino)));

    on<OnNewPlacesFoundEvent>((event, emit) => emit(state.copyWith(places: event.places)));

    on<AddToHistoryEvent>((event, emit) => emit(state.copyWith(history: [event.place, ...state.history])));
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end, String destino) async {

    String apiKeyMap = 'AIzaSyCd5hxxueKmI97p0Pl1IXIJD9VswUNbQo8';

    String urlOriginToDestinationDirectionDetails =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&language=es&key=$apiKeyMap';
    var responseDirectionApi = await receiveRequest(urlOriginToDestinationDirectionDetails);

    final prueba = responseDirectionApi['routes'][0]['overview_polyline']['points'];

    final durationString = responseDirectionApi['routes'][0]['legs'][0]['duration']['text'];
    final distanceString = responseDirectionApi['routes'][0]['legs'][0]['distance']['text'];

    return RouteDestination(
        duration: durationString,
        distance: distanceString,
        endPlace: destino,
        e_points: prueba);
  }

  Future<RouteDestination> getCoorsStartToEnd2(LatLng start, LatLng end, String destino) async {
  
    String apiKeyMap = 'AIzaSyCd5hxxueKmI97p0Pl1IXIJD9VswUNbQo8';

    String urlOriginToDestinationDirectionDetails =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&language=es&mode=walking&key=$apiKeyMap';
    var responseDirectionApi =
        await receiveRequest(urlOriginToDestinationDirectionDetails);

    final prueba =
        responseDirectionApi['routes'][0]['overview_polyline']['points'];
    
    final durationString = responseDirectionApi['routes'][0]['legs'][0]['duration']['text'];
    final distanceString = responseDirectionApi['routes'][0]['legs'][0]['distance']['text'];

    return RouteDestination(
        duration: durationString,
        distance: distanceString,
        endPlace: destino,
        e_points: prueba);
  }

  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));
    try {
      if (httpResponse.statusCode == 200) {
        String responseData = httpResponse.body;

        var decodeResponseData = jsonDecode(responseData);
        return decodeResponseData;
      } else {
        return 'ERROR AN OCCURRED, FAILED TO RESPONSE.';
      }
    } catch (exp) {
      return 'ERROR AN OCCURRED, FAILED TO RESPONSE.';
    }
  }

  Future<void> currentPositionToOrigen() async {
    final position = await Geolocator.getCurrentPosition();
    final posLatLng = LatLng( position.latitude, position.longitude );
    final placeName = await trafficService.getInformationPlace(posLatLng);
    final origen = PointOrigin(name: placeName, position: posLatLng);
    add(OnSetOrigin(origen));
  }

   Future getPlacesByQuery( LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);

    add(OnNewPlacesFoundEvent(newPlaces));
  }

}
