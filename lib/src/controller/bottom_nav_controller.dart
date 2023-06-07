import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt _pageIndex = 0.obs;
  int get pageIndex => _pageIndex.value;

  void changePage(int value) {
    _pageIndex(value);
  }
}
