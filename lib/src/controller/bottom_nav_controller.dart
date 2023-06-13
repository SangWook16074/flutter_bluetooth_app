import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt _pageIndex = 0.obs;
  late final PageController _pageController;

  int get pageIndex => _pageIndex.value;
  PageController get pageController => _pageController;

  @override
  void onInit() {
    super.onInit();
    _pageController = PageController(initialPage: _pageIndex.value);
  }

  void changePage(int value) {
    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
    _pageIndex(value);
  }
}
