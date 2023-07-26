import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/services/services.dart';
import 'package:sig_app/views/login/welcome_page.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocationBloc()),
    BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
    BlocProvider(
        create: (context) => SearchBloc(trafficService: TrafficService())),
  ], child: const MapsApp()));
}

class MapsApp extends StatelessWidget {
  const MapsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MapsApp',
        home: WelcomePage());
  }
}
