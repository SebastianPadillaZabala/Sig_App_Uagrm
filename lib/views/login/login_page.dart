
import 'package:flutter/material.dart';

import '../../screens/map_screen.dart';
import '../home/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      backgroundColor: Color.fromARGB(255, 25, 151, 210),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/buslogo.png",
                  height: 200,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Material(
                shadowColor: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                elevation: 5,
                child: Container(
                  height: 500,
                  width: 350,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Incio de sesion",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 25, 151, 210),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 300,
                        height: 80,
                        child: TextFormField(
                          cursorColor: Colors.deepPurpleAccent,
                          decoration: InputDecoration(
                            hintText: 'Nombre de usuario',
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 25, 151, 210),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 80,
                        child: TextFormField(
                          cursorColor: Colors.deepPurpleAccent,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.password_rounded,
                              color: Color.fromARGB(255, 25, 151, 210),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 89, 39),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  HomePage()));
                          },
                          child: Text("Iniciar"),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("O registrate con:"),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/facebook.png",
                            height: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            "assets/images/google.png",
                            height: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            "assets/images/phone.png",
                            height: 30,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}