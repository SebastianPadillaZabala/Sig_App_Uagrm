

import 'package:flutter/material.dart';
import 'package:sig_app/screens/map_screen.dart';

import '../../delegates/search_destination_delegate.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            child: Text("prueba"),
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchDestinationDelegate());
            },
          ),
        ),
      ),
    );
  }
}