import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sig_app/blocs/blocs.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: const Color.fromRGBO(136, 0, 0, 1),
        maxRadius: 25,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                state.isFollowingUser
                    ? Icons.directions_run_rounded
                    : Icons.hail_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                //Tarea
                mapBloc.add(OnStartFollowingUserEvent());
              },
            );
          },
        ),
      ),
    );
  }
}
