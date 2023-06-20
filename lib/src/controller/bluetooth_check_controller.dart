import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_app/src/view/check.dart';
import 'package:flutter_bluetooth_app/src/view/onboard.dart';
import 'package:get/get.dart';

import '../constants/flutter_blue_const.dart';

class BluetoothCheckController extends GetxController {
  final _bluetoothState = Rx<BluetoothState>(BluetoothState.unknown);

  set bluetoothState(value) => _bluetoothState.value = value;

  @override
  void onReady() {
    super.onReady();
    ever(_bluetoothState, (_) => moveToPage());
    _bluetoothState.bindStream(flutterBlue.state);
  }

  void moveToPage() {
    if (_bluetoothState.value == BluetoothState.on) {
      Get.off(() => const OnBoard(), transition: Transition.fadeIn);
    } else {
      Get.off(() => const Check(), transition: Transition.fadeIn);
    }
  }
}
