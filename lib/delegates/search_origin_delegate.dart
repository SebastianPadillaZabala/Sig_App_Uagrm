import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/services/services.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../models/models.dart';

class SearchOriginDelegate extends SearchDelegate<SearchResult> {
  SearchOriginDelegate() : super(searchFieldLabel: 'Buscar...');
  double lat = 0;
  double long = 0;
  final SpeechToText speech = SpeechToText();

  Future<void> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      bool isAvailable = await speech.initialize();
      if (isAvailable) {
        print('Reconocimiento de voz disponible');
      } else {
        print('Reconocimiento de voz no disponible');
      }
    }
  }

  Future<void> startListening(BuildContext context) async {
    final microfonoGranted = await Permission.microphone.isGranted;
    if (microfonoGranted) {
      await speech.initialize();
      await speech.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 12),
        pauseFor: const Duration(seconds: 4),
      );
      showResults(context);
    } else {
      await requestMicrophonePermission();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    String transcription = result.recognizedWords;
    query = transcription;
    print(query);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.mic_rounded),
          onPressed: () async {
            await requestMicrophonePermission();
            startListening(context);
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

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnownLocation!;

    searchBloc.getPlacesByQuery(proximity, query);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;

        return ListView.separated(
          itemCount: places.length,
          itemBuilder: (context, i) {
            final place = places[i];
            return ListTile(
                title: Text(place.text),
                subtitle: Text(place.placeName),
                leading: const Icon(Icons.place_outlined, color: Colors.black),
                onTap: () {
                  final result = SearchResult(
                      cancel: false,
                      manual: false,
                      position: LatLng(place.center[1], place.center[0]),
                      name: place.text,
                      description: place.placeName);

                  searchBloc.add( AddToHistoryEvent(place) );

                  close(context, result);
                });
          },
          separatorBuilder: (context, i) => const Divider(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return optionsOfSetLocation(mapBloc, context);
  }

  ListView optionsOfSetLocation(MapBloc mapBloc, BuildContext context) {
    final history = BlocProvider.of<SearchBloc>(context).state.history;
    return ListView(
      children: [
        ListTile(
            leading: const Icon(Icons.location_on_sharp,
                color: Color.fromRGBO(136, 0, 0, 1)),
            title: const Text('Colocar la ubicacion manualmente',
                style: TextStyle(color: Colors.black)),
            onTap: () {
              FocusScope.of(context).unfocus();
              final result = SearchResult(cancel: false, manual: true);
              close(context, result);
            }),
        ListTile(
            leading: const Icon(Icons.phone_iphone_sharp,
                color: Color.fromRGBO(136, 0, 0, 1)),
            title: const Text('Usar la ubicación del dispositivo',
                style: TextStyle(color: Colors.black)),
            onTap: () async {
              FocusScope.of(context).unfocus();
              final trafficService = TrafficService();
              final locationBloc = BlocProvider.of<LocationBloc>(context);

              final ubString = await trafficService
                  .getInformationPlace(locationBloc.state.lastKnownLocation!);

              final result = SearchResult(
                cancel: false,
                manual: false,
                position: locationBloc.state.lastKnownLocation!,
                name: "Ubicacion actual",
                description: ubString,
              );

              close(context, result);
            }),
        ...history.map((place) => ListTile(
            title: Text(place.text),
            subtitle: Text(place.placeName),
            leading: const Icon(Icons.history, color: Colors.black),
            onTap: () {
              final result = SearchResult(
                  cancel: false,
                  manual: false,
                  position: LatLng(place.center[1], place.center[0]),
                  name: place.text,
                  description: place.placeName);
              close(context, result);
            }))
      ],
    );
  }
}
