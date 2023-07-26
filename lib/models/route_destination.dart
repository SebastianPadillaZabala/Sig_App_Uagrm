import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class RouteDestination {
  final String duration;
  final String distance;
  final String endPlace;
  final String e_points;

  RouteDestination({
    required this.duration, 
    required this.distance,
    required this.endPlace,
    required this.e_points});
}
