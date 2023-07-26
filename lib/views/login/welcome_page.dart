import 'package:flutter/material.dart';
import 'package:sig_app/screens/loading_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(136, 0, 0, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Bienvenido a ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: screenSize.width *
                    0.05, 
              ),
            ),
            Text(
              "UAGRM GO",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: screenSize.width *
                    0.07, 
              ),
            ),
            Center(
              child: Image.asset(
                "assets/images/uagrm-escudo.png",
                height: screenSize.height * 0.4,
              ),
            ),
            Text(
              "Toda la Uagrm",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: screenSize.width *
                    0.05, 
              ),
            ),
            Text(
              "en la palma de tu mano",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: screenSize.width *
                    0.05, 
              ),
            ),
            SizedBox(
              width: screenSize.width *
                  0.6, 
              height: screenSize.height *
                  0.05, 
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(42, 57, 100, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoadingScreen()),
                  );
                },
                child: const Text("Ingresar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
