import 'package:dio/dio.dart';

class TrafficInterceptor extends Interceptor {
  final accesToken =
      'pk.eyJ1Ijoic2ViYXM3NzAiLCJhIjoiY2xhdTMyZDF4MDJscjNvb3ljMjNpMmUxNiJ9.Gdf17Oug_x33gfoM-ueUDQ';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest

    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'language': 'en',
      'overview': 'full',
      'steps': false,
      'access_token': accesToken
    });

    super.onRequest(options, handler);
  }
}
