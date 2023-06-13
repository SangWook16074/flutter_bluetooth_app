import 'package:get/get.dart';

import '../binding/app_binding.dart';
import '../view/home.dart';

class OnboardController extends GetxController {
  void moveToScan() => Get.to(() => const Home(),
      binding: AppBinding(), transition: Transition.fadeIn);
}
