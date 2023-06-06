import 'package:flutter_bluetooth_app/src/binding/home_binding.dart';
import 'package:get/get.dart';

import '../view/home.dart';

class OnboardController extends GetxController {
  void moveToScan() => Get.to(() => const Home(), binding: HomeBinding());
}
