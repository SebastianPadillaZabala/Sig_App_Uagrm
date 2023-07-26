import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sig_app/views/login/welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
         
          const SizedBox(
            height: 20,
          ),
          const GFListTile(
              titleText: 'Nombre',
              subTitleText: 'Sebastian',
              icon: Icon(Icons.arrow_forward_ios_rounded)),
          const Divider(),
          const GFListTile(
              titleText: 'Apellido',
              subTitleText: 'Padilla',
              icon: Icon(Icons.arrow_forward_ios_rounded)),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: GFButton(
              color: Color.fromRGBO(42, 57, 100, 1),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
              text: "Cerrar sesion",
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              shape: GFButtonShape.pills,
            ),
          ),
        ],
      )),
    );
  }
}
