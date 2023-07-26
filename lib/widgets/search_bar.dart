import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/delegates/delgates.dart';
import 'package:sig_app/helpers/helpers.dart';
import 'package:sig_app/models/models.dart';
import 'package:sig_app/services/services.dart';

import '../delegates/search_origin_delegate.dart';

class SearchBars extends StatelessWidget {
  const SearchBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      return const _SearchBarBody();
      /*state.displayManualMarker
          ? const SizedBox()
          : FadeInDown(
              duration: const Duration(milliseconds: 300),
              child: _SearchBarBody());*/
    });
  }
}

class _SearchBarBody extends StatefulWidget {
  const _SearchBarBody({Key? key}) : super(key: key);

  @override
  State<_SearchBarBody> createState() => _SearchBarBodyState();
}

class _SearchBarBodyState extends State<_SearchBarBody> {
  LatLng? position;
  String? direccion;
  String? direccionDestino;
  bool? vehicle = true;

  void onSearchResultsInfoRoute(BuildContext context, SearchResult result) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    searchBloc.add(OnActivateInfoRouteEvent());
  }

  void onSearchResults(BuildContext context, SearchResult result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);

    if(result.manual) {
      searchBloc.add(OnActivateManualMarkerEvent());
      return;
    }

    if(result.position != null) {

      if(mapBloc.state.isContainPolylines){
        showLoadingMessage(context);

        final destino = LatLng(double.parse(searchBloc.state.pointDestino!.longitud!), double.parse(searchBloc.state.pointDestino!.latitud!));

        final destinationWalking = await searchBloc.getCoorsStartToEnd2(result.position!, destino, searchBloc.state.pointDestino!.descripcion!);
        final destinationCar = await searchBloc.getCoorsStartToEnd(result.position!, destino, searchBloc.state.pointDestino!.descripcion!);
        mapBloc.cargarPuntos(destinationCar, destinationWalking);

        mapBloc.state.isVehicle
          ? await mapBloc.dibujarRuta(destinationCar)
          : await mapBloc.dibujarRuta(destinationWalking);
        searchBloc.add(OnActivateInfoRouteEvent());
        Navigator.pop(context);
      }

      final pointOrigin = PointOrigin(name: result.description, position: result.position);
      searchBloc.add(OnSetOrigin(pointOrigin)); //carga el origen ya sea la ub actual o la buscada

    }
  }

  @override
  void initState() {
    super.initState();
  //  getLocationString();
  }

  Future<void> getLocationString() async {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    TrafficService trafficService = TrafficService();
    final currentPosition = locationBloc.state.lastKnownLocation;
    final trafficResponse = await trafficService.getInformationByCoors(
        LatLng(currentPosition!.latitude, currentPosition.longitude));
    setState(() {
      direccion = trafficResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 25, horizontal: 0.05 * MediaQuery.of(context).size.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(136, 0, 0, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: BlocBuilder<MapBloc, MapState>(
              builder: (context, mapState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        vehicle = false;
                        mapBloc.add(const ChangeIsVehicleEvent(false));
                      });
                      if (mapState.isContainPolylines) {
                        mapBloc.dibujarRuta(mapState.pointsPeople!);
                      }
                    },
                    icon: const Icon(Icons.directions_walk, size: 30),
                    color: vehicle! ? Colors.white : Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        vehicle = true;
                        mapBloc.add(const ChangeIsVehicleEvent(true));
                      });
                      if (mapState.isContainPolylines) {
                        mapBloc.dibujarRuta(mapState.pointsCar!);
                      }
                    },
                    icon: const Icon(
                      Icons.directions_car,
                      size: 30,
                    ),
                    color: vehicle! ? Colors.blue : Colors.white,
                  ),
                ],
              );
              }
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await showSearch(
                context: context,
                delegate: SearchOriginDelegate(),
              );
              if (result == null) return;

              if (result.cancel) return;

              onSearchResults(context, result);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 0.04 * MediaQuery.of(context).size.width,
                  vertical: 0.02 * MediaQuery.of(context).size.height),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black54),
              ),
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, searchState) {
                  return searchState.pointOrigin != null
                      ? Text(
                          '${searchState.pointOrigin!.name}',
                          style: const TextStyle(color: Colors.black87),
                        )
                      : const CircularProgressIndicator();
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await showSearch(
                context: context,
                delegate: SearchDestinationDelegate(),
              );
              if (result == null) return;
              if (result.cancel) return;
              onSearchResultsInfoRoute(context, result);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 0.04 * MediaQuery.of(context).size.width,
                  vertical: 0.02 * MediaQuery.of(context).size.height),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black54),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: BlocBuilder<MapBloc, MapState>(
                builder: (context, mapState) {
                  return mapState.isContainPolylines
                  ? Text(
                  '${searchBloc.state.pointDestino!.descripcion}',
                  style: const TextStyle(color: Colors.black87),
                )
                : const Text(
                  '¿A que lugar de la Uagrm quieres ir?',
                  style: TextStyle(color: Colors.black87),
                );
                },
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}
