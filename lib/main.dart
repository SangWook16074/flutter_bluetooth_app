import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/src/binding/init_binding.dart';
import 'package:get/get.dart';

import 'src/view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0.0),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      home: const Home(),
      initialBinding: InitBinding(),
    );
  }
}
