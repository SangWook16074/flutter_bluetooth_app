import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/src/res/rive_path.dart';
import 'package:rive/rive.dart' as rive;

class Connect extends StatelessWidget {
  const Connect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                ],
                colors: [
                  Color(0xff081c1d),
                  Color(0xff0b2a2d),
                  Color(0xff0d393f),
                ]),
          ),
          child: _body()),
    );
  }

  Widget _body() {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: 300,
              height: 300,
              child: rive.RiveAnimation.asset(RiveAssetPath.ledOn)),
        ),
      ),
    );
  }
}
