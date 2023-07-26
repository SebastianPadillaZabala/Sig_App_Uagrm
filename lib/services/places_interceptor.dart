import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accesToken =
      'pk.eyJ1Ijoic2ViYXM3NzAiLCJhIjoiY2xhdTMyZDF4MDJscjNvb3ljMjNpMmUxNiJ9.Gdf17Oug_x33gfoM-ueUDQ';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    options.queryParameters.addAll({
      'language': 'es',
      'country': 'bo',
      'access_token': accesToken,
      'limit': 7
    });
    super.onRequest(options, handler);
  }
}
