import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/src/view/connect.dart';
import 'package:flutter_bluetooth_app/src/view/home.dart';
import 'package:get/get.dart';

class PageViewController extends GetxController {
  var _pageIndex = 0;
  final List<Widget> _page = [const Home(), const Connect()];
  late final PageController _pageController;

  List<Widget> get page => _page;
  PageController get pageController => _pageController;

  @override
  void onInit() {
    super.onInit();
    _pageController = PageController(initialPage: _pageIndex);
  }

  void changePage(int value) {
    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
    _pageIndex = value;
  }
}
