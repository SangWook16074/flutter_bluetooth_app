import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:flutter_bluetooth_app/src/binding/app_binding.dart';
import 'package:flutter_bluetooth_app/src/view/check.dart';
import 'package:get/get.dart';

import '../constants/flutter_blue_const.dart';
import '../view/home.dart';

class BluetoothCheckController extends GetxController {
  final _state = Rx<BluetoothState>(BluetoothState.off);

  @override
  void onInit() {
    super.onInit();

    _state.bindStream(flutterBlue.state);
  }

  void moveToPage() {
    if (_state.value == BluetoothState.on) {
      Get.off(() => const Home(),
          binding: AppBinding(), transition: Transition.fadeIn);
    } else {
      Get.off(() => const Check(), transition: Transition.fadeIn);
    }
  }
}
