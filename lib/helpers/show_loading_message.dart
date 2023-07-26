import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text('Espere por favor'),
      content: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            const Text('Calculando ruta...'),
            const SizedBox(height: 5),
            Center(
              child: Image.asset(
                'assets/images/prueba.gif',
                height: 70,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  return;
}
