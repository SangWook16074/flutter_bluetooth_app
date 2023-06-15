import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/src/components/gradient_button.dart';
import 'package:flutter_bluetooth_app/src/controller/onboard_controller.dart';
import 'package:flutter_bluetooth_app/src/res/rive_path.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:rive/rive.dart' as rive;

class OnBoard extends GetView<OnboardController> {
  const OnBoard({super.key});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logo(),
            _title(),
            _description(),
            _nextBtn(),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return SizedBox(
      width: 400,
      height: 400,
      child: rive.RiveAnimation.asset(
        RiveAssetPath.onboard,
      ),
    );
  }

  Widget _title() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Text(
        'Scan nearby Bluetooth devices!',
        style:
            TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 30),
      ),
    );
  }

  Widget _description() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Text(
        'This app easily scans for nearby BLE devices and connects them quickly.',
        style:
            TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 15),
      ),
    );
  }

  Widget _nextBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: GradientButton(
        width: 150,
        height: 50,
        onPressed: controller.moveToScan,
        colors: const [
          Color(0xff03b6dc),
          Color(0xff69e4ff),
        ],
        child: const Text(
          'Start',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
