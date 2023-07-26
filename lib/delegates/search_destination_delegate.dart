import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sig_app/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sig_app/helpers/helpers.dart';
import 'package:sig_app/utils/const_service.dart';

import '../models/models.dart';
import '../services/places_services.dart';

class SearchDestinationDelegate extends SearchDelegate {
  SearchDestinationDelegate() : super(searchFieldLabel: 'Buscar...');
  double lat = 0;
  double long = 0;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          final result = SearchResult(cancel: true);
          close(context, result);
        });
  }

  FetchPlaces _placesList = FetchPlaces();

  @override
  Widget buildResults(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder<List<PlaceList>>(
        future: _placesList.getPlacesList(query: query),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (!snapshot.hasData) {
            return Center(
              child: Image.asset(
                'assets/images/prueba.gif',
                height: 150,
              ),
            );
          }
          return ListView.builder(
            itemCount: data?.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    final start = LatLng(
                        searchBloc.state.pointOrigin!.position!.latitude,
                        searchBloc.state.pointOrigin!.position!.longitude);
                    if (start == null) return;

                    lat = double.parse(data![index].latitud.toString());
                    long = double.parse(data![index].longitud.toString());

                    showLoadingMessage(context);

                    final pointsCar = await searchBloc.getCoorsStartToEnd(
                        start,
                        LatLng(long, lat),
                        data[index].descripcion.toString());

                    final pointsPeople = await searchBloc.getCoorsStartToEnd2(
                        start,
                        LatLng(long, lat),
                        data[index].descripcion.toString());

                    mapBloc.cargarPuntos(pointsCar, pointsPeople);

                    mapBloc.state.isVehicle
                        ? await mapBloc.dibujarRuta(pointsCar)
                        : await mapBloc.dibujarRuta(pointsPeople);

                    final result = SearchResult(cancel: false, manual: true);
                    close(context, result);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(136, 0, 0, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data?[index].facultad}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Localidad: ${data?[index].localidad}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Descripcion: ${data?[index].descripcion}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 1,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    // Otros(mapBloc, context),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: FutureBuilder<List<PlaceList>>(
                        future: _placesList.getPlacesList(query: query),
                        builder: (context, snapshot) {
                          var data = snapshot.data;
                          if (!snapshot.hasData) {
                            return Center(
                              child: Image.asset(
                                'assets/images/prueba.gif',
                                height: 150,
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: data?.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    final start = LatLng(
                                        searchBloc.state.pointOrigin!.position!
                                            .latitude,
                                        searchBloc.state.pointOrigin!.position!
                                            .longitude);
                                    if (start == null) return;

                                    lat = double.parse(
                                        data![index].latitud.toString());
                                    long = double.parse(
                                        data![index].longitud.toString());

                                    showLoadingMessage(context);

                                    searchBloc.add(OnSetDestination(data[index]));

                                    final pointsCar =
                                        await searchBloc.getCoorsStartToEnd(
                                            start,
                                            LatLng(long, lat),
                                            data[index].descripcion.toString());

                                    final pointsPeople =
                                        await searchBloc.getCoorsStartToEnd2(
                                            start,
                                            LatLng(long, lat),
                                            data[index].descripcion.toString());

                                    mapBloc.cargarPuntos(
                                        pointsCar, pointsPeople);

                                    mapBloc.state.isVehicle
                                        ? await mapBloc.dibujarRuta(pointsCar)
                                        : await mapBloc
                                            .dibujarRuta(pointsPeople);

                                    final result = SearchResult(
                                        cancel: false, manual: true);
                                    close(context, result);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      leading: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              136, 0, 0, 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${data?[index].facultad}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Localidad: ${data?[index].localidad}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Descripcion: ${data?[index].descripcion}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: const Icon(Icons.arrow_forward),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView Otros(MapBloc mapBloc, BuildContext context) {
    return ListView(
      children: [
        ListTile(
            leading: const Icon(Icons.location_on_outlined,
                color: Color.fromRGBO(136, 0, 0, 1)),
            title: const Text('Informacion de la ruta',
                style: TextStyle(color: Colors.black)),
            onTap: () {
              final result = SearchResult(cancel: false, manual: true);
              close(context, result);
            }),
      ],
    );
  }
}
