import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_app/src/binding/init_binding.dart';
import 'package:flutter_bluetooth_app/src/view/onboard.dart';
import 'package:get/get.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff303c3d),
              foregroundColor: Colors.white,
              elevation: 0.0),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      home: const OnBoard(),
      initialBinding: InitBinding(),
    );
  }
}
