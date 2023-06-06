import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/src/components/gradient_button.dart';
import 'package:flutter_bluetooth_app/src/controller/onboard_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:rive/rive.dart';

class OnBoard extends GetView<OnboardController> {
  const OnBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logo(),
            _title(),
            _nextBtn(),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return const SizedBox(
      width: 400,
      height: 400,
      child: RiveAnimation.asset(
        'assets/rives/bluetooth_onboard.riv',
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Try scan BLE Device !',
      style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 30),
    );
  }

  Widget _nextBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: GradientButton(
        width: double.infinity,
        height: 60,
        onPressed: controller.moveToScan,
        child: const Text(
          'Start',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }
}
