import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/helpers/helpers.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? const _ManualMarkerBody()
            : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final searchBloc = BlocProvider.of<SearchBloc>(context);
  final mapBloc = BlocProvider.of<MapBloc>(context);
  final trafficService = TrafficService();

  return LayoutBuilder(
    builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Stack(
          children: [
            Positioned(
              top: constraints.maxHeight * 0.3,
              left: constraints.maxWidth * 0.05,
              child: const _BtnBack(),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, -constraints.maxHeight * 0.022),
                child: BounceInDown(
                  from: 100,
                  child: Icon(
                    Icons.location_on_rounded,
                    size: constraints.maxWidth * 0.1,
                    color: Color.fromRGBO(42, 57, 100, 1),
                  ),
                ),
              ),
            ),

            // Boton de confirmar
            Positioned(
              bottom: constraints.maxHeight * 0.10,
              left: constraints.maxWidth * 0.10,
              child: FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: MaterialButton(
                  minWidth: constraints.maxWidth - constraints.maxWidth * 0.2,
                  // ignore: sort_child_properties_last
                  child: const Text(
                    'Confirmar origen',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  color: const Color.fromRGBO(42, 57, 100, 1),
                  elevation: 0,
                  height: constraints.maxHeight * 0.06,
                  shape: const StadiumBorder(),
                  onPressed: () async {
                    // TODO: confirmar ubicacion

                    final start = mapBloc.mapCenter;
                    if (start == null) return;

                    final startString = await trafficService.getInformationPlace(start);

                    if (mapBloc.state.isContainPolylines) {
                      final end = LatLng(
                        double.parse(searchBloc.state.pointDestino!.longitud!),
                        double.parse(searchBloc.state.pointDestino!.latitud!),
                      );

                      showLoadingMessage(context);

                      final routeVehicle =
                          await searchBloc.getCoorsStartToEnd(start, end, searchBloc.state.pointDestino!.descripcion!);
                      final routeWalking =
                          await searchBloc.getCoorsStartToEnd2(start, end, searchBloc.state.pointDestino!.descripcion!);
                      
                      mapBloc.state.isVehicle
                          ? await mapBloc.dibujarRuta(routeVehicle)
                          : await mapBloc.dibujarRuta(routeWalking);
                      mapBloc.cargarPuntos(routeVehicle, routeWalking);
                      searchBloc.add(OnActivateInfoRouteEvent());
                      Navigator.pop(context);
                    }
                    searchBloc.add(OnSetOrigin(PointOrigin(name: startString, position: start)));
                    searchBloc.add(OnDeactivateManualMarkerEvent());
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CircleAvatar(
            maxRadius: constraints.maxWidth * 0.04,
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Color.fromRGBO(136, 0, 0, 1)),
              onPressed: () {
                 BlocProvider.of<SearchBloc>(context)
                .add(OnDeactivateManualMarkerEvent());
              },
            ),
          );
        },
      ),
    );
  }
}