import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/screens/gps_access_screen.dart';
import 'package:sig_app/screens/map_screen.dart';
import 'package:sig_app/views/home/home_page.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
      return state.isAllGranted ? const HomePage() : const GpsAccessScreen();
    }));
  }
}
