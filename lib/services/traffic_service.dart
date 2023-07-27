import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';
import 'package:http/http.dart' as http;

class TrafficService {
  final Dio _dioTraffic;
  final Dio _dioPlaces;
  final Dio _dioPlaces2;

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlacesUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';

  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor()),
        _dioPlaces = Dio()..interceptors.add(PlacesInterceptor()),
        _dioPlaces2 = Dio()..interceptors.add(PlacesInterceptor2());
  //TODO configurar interseptor

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coorsString =
        '${start.longitude}, ${start.latitude}; ${end.longitude}, ${end.latitude}';

    final url = '$_baseTrafficUrl/driving/$coorsString';

    final resp = await _dioTraffic.get(url);

    final data = TrafficResponse.fromMap(resp.data);

    return data;
  }

  Future<TrafficResponse> getCoorsStartToEnd2(LatLng start, LatLng end) async {
    final coorsString =
        '${start.longitude}, ${start.latitude}; ${end.longitude}, ${end.latitude}';

    final url = '$_baseTrafficUrl/walking/$coorsString';

    final resp = await _dioTraffic.get(url);

    final data = TrafficResponse.fromMap(resp.data);

    return data;
  }

  Future<List<Feature>> getResultsByQuery(LatLng proximity, String query) async {
    if (query.isEmpty) return [];
    final url = '$_basePlacesUrl/$query.json';
    final resp = await _dioPlaces.get(url, queryParameters: {
      'poximity': '${proximity.longitude}, ${proximity.latitude}'
    });

    final placesResponse = PlacesResponse.fromMap(resp.data);

    return placesResponse.features;
  }

  Future<String> getInformationByCoors (LatLng coors) async {  
  
    final currentPosition = await Geolocator.getCurrentPosition();
     String apiUrl = '$_basePlacesUrl/${currentPosition.longitude},${currentPosition.latitude}.json';
    final response = await _dioPlaces2.get(apiUrl, queryParameters: {
      'limit': 1
    });
     if (response.statusCode == 200) {
      print(response.data['features'][0]['place_name_es']);
      return response.data['features'][0]['place_name_es'];

    } else {
      throw Exception("Error obteniendo el lugar: ${response.statusCode}");
    }
    
  }

  Future<String> getInformationByCoors2 (LatLng coors) async {  
     String apiUrl = '$_basePlacesUrl/${coors.longitude},${coors.latitude}.json';
    final response = await _dioPlaces.get(apiUrl, queryParameters: {
      'limit': 1
    });
     if (response.statusCode == 200) {
      print(response.data['features'][0]['place_name_es']);
      return response.data['features'][0]['place_name_es'];

    } else {
      throw Exception("Error obteniendo el lugar: ${response.statusCode}");
    }
  }

  Future<String> getInformationPlace( LatLng coors ) async {

    final url = '$_basePlacesUrl/${ coors.longitude },${ coors.latitude }.json';
    final resp = await _dioPlaces2.get(url, queryParameters: {
      'limit': 1
    });

    final placeName = resp.data['features'][0]['place_name_es'];
    return placeName;

  }
}
