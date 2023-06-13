import 'package:flutter_bluetooth_app/src/controller/bluetooth_controller.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(PageViewController());
    Get.put(BluetoothController(), permanent: true);
  }
}
