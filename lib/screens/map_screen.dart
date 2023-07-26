import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/views/views.dart';
import 'package:sig_app/widgets/manual_marker.dart';
import 'package:sig_app/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  late SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();

    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();

    searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.currentPositionToOrigen();
    
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
        if (locationState.lastKnownLocation == null) {
          return Center(
            child: Image.asset(
                      'assets/images/logo-2.gif',
                      height: 150,
                    ),
          );
        }
        return BlocBuilder<MapBloc, MapState>(
          builder: (context, mapState) {
            Map<String, Polyline> polylines = Map.from(mapState.polylines);
            Map<String, Marker> markers = Map.from(mapState.markers);
            if (!mapState.showMyRoutes) {
              polylines.removeWhere((key, value) => key == 'myRoute');
            }

            return Stack(
              children: [
                MapView(
                  initialLocation: locationState.lastKnownLocation!,
                  polylines: polylines.values.toSet(),
                  markers: markers.values.toSet(),
                ),
                const SearchBars(),
                const InfoRoute(),
                const ManualMarker(),
              ],
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
         // BtnToggleUserRoute(), //limpiar mapa
          //BtnFollowUser(),
          BtnCurrentLocation()
        ],
      ),
    );
  }
}
