import 'dart:convert';

import 'package:sig_app/models/place.dart';
import 'package:sig_app/utils/const_service.dart';
import 'package:http/http.dart' as http;

class FetchPlaces {
  var data = [];
  List<PlaceList> results = [];

  Future<List<PlaceList>> getPlacesList({String? query}) async {
    var url = Uri.parse(listURL);
    var response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => PlaceList.fromJson(e)).toList();
        if (query != null) {
          results = filterResults(results, query);
        }
      } else {
        print('api error');
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }

  List<PlaceList> filterResults(List<PlaceList> results, String query) {
 
    return results.where((element) {
      if(element.nroModulo == null){
         bool matchesQuery =
          element.facultad!.toLowerCase().contains(query.toLowerCase()) ||
          //element.nroModulo!.toString().toLowerCase().contains(query.toLowerCase()) ||
          element.descripcion!.toLowerCase().contains(query.toLowerCase());
      // Agrega más condiciones de filtrado según tus necesidades
      // Ejemplo: bool matchesAnotherParam = element.anotherParam.contains(anotherValue);

      return matchesQuery; // && matchesAnotherParam;
      }else{
      bool matchesQuery =
          element.facultad!.toLowerCase().contains(query.toLowerCase()) ||
          element.localidad!.toLowerCase().contains(query.toLowerCase()) ||
          element.nroModulo!.toString().toLowerCase().contains(query.toLowerCase()) ||
          element.descripcion!.toLowerCase().contains(query.toLowerCase());
      // Agrega más condiciones de filtrado según tus necesidades
      // Ejemplo: bool matchesAnotherParam = element.anotherParam.contains(anotherValue);

      return matchesQuery; 
      }// && matchesAnotherParam;
    }).toList();
  }
}
