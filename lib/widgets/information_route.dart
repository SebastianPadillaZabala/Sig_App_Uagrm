import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';
import 'package:sig_app/helpers/helpers.dart';
import 'package:sig_app/widgets/widgets.dart';

class InfoRoute extends StatelessWidget {
  const InfoRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayInfoRoute
            ? const _InfoRouteBody()
            : const SizedBox();
      },
    );
  }
}

class _InfoRouteBody extends StatelessWidget {
  const _InfoRouteBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final mapBloc = BlocProvider.of<MapBloc>(context);
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
            Positioned(
              bottom: constraints.maxHeight * 0.03,
              left: constraints.maxWidth * 0.01,
              child: Container(
                padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                alignment: Alignment.bottomLeft,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(constraints.maxWidth * 0.02),
                  ),
                  color: Colors.white,
                  child: BlocBuilder<MapBloc, MapState>(
                    builder: (context, mapState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.all(constraints.maxWidth * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tiempo estimado:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(136, 0, 0, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  mapBloc.state.isVehicle
                                      ? mapBloc.state.pointsCar!.duration
                                      : mapBloc.state.pointsPeople!.duration,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(42, 57, 100, 1)),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Distancia:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(136, 0, 0, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  mapBloc.state.isVehicle
                                      ? mapBloc.state.pointsCar!.distance
                                      : mapBloc.state.pointsPeople!.distance,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(42, 57, 100, 1)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CircleAvatar(
            maxRadius: constraints.maxWidth * 0.04,
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Color.fromRGBO(136, 0, 0, 1)),
              onPressed: () async {
                await mapBloc.cleanMap();
                mapBloc.add(ChangeIsContarinPolylinesEvent(false));
                BlocProvider.of<SearchBloc>(context)
                    .add(OnDeactivateInfoRouteEvent());
              },
            ),
          );
        },
      ),
    );
  }
}
