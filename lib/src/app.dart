import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'controller/bottom_nav_controller.dart';
import 'view/connect.dart';
import 'view/home.dart';

class App extends GetView<BottomNavController> {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                ],
                colors: [
                  Color(0xff081c1d),
                  Color(0xff0b2a2d),
                  Color(0xff0d393f),
                ]),
          ),
          child: PageView(
            controller: controller.pageController,
            onPageChanged: controller.changePage,
            children: const [Home(), Connect()],
          ),
        ),
        bottomNavigationBar: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 12.0,
                backgroundColor: Colors.white.withOpacity(0.7),
                onTap: controller.changePage,
                currentIndex: controller.pageIndex,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.white,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bluetooth_connected_outlined),
                      activeIcon: Icon(Icons.bluetooth_connected),
                      label: 'connect'),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
