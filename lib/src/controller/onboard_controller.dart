import 'package:get/get.dart';

import '../app.dart';
import '../binding/app_binding.dart';

class OnboardController extends GetxController {
  void moveToScan() => Get.to(() => const App(), binding: AppBinding());
}
