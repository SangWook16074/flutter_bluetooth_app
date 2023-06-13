import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_app/src/controller/bluetooth_controller.dart';
import 'package:get/get.dart';

class Connect extends GetView<BluetoothController> {
  const Connect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          56.0,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              backgroundColor: Colors.white.withOpacity(0.1),
              title: const Text('Bluetooth Scanner'),
              elevation: 5.0,
            ),
          ),
        ),
      ),
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
          child: _body()),
    );
  }

  Widget _body() {
    return Obx(
      () => ListView.builder(
          itemCount: controller.connect.length,
          itemBuilder: (context, index) {
            final data = controller.connect[index];
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.bluetooth_connected,
                      size: 100,
                      color: Colors.blue,
                    ),
                    Text(data.name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {}, child: const Text('connect')),
                        ElevatedButton(
                            onPressed: () {}, child: const Text('disconnect')),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
