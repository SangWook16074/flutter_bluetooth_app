import 'package:flutter_bluetooth_app/src/controller/bottom_nav_controller.dart';
import 'package:get/get.dart';

import '../controller/bluetooth_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController(), permanent: true);
    Get.put(BluetoothController());
  }
}
