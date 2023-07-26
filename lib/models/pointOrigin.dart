import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class PointOrigin {

  final LatLng? position;
  final String? name;


  PointOrigin({
    this.position, 
    this.name, 
  });

 
  @override
  String toString() {
    return '{ posicion: $position, name: $name }';
  }
}