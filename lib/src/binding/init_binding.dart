import 'package:get/get.dart';

import '../controller/bluetooth_check_controller.dart';
import '../controller/onboard_controller.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(OnboardController());
    Get.put(BluetoothCheckController(), permanent: true);
  }
}
