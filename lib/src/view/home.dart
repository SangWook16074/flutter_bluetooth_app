import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rive/rive.dart';

import '../controller/bluetooth_controller.dart';

class Home extends GetView<BluetoothController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Obx(
          () => FloatingActionButton(
            onPressed: (controller.status == Status.LOADED)
                ? controller.startScan
                : controller.stopScan,
            child: (controller.status == Status.LOADED)
                ? const Icon(Icons.search)
                : const Icon(Icons.square),
          ),
        ),
        appBar: AppBar(
          title: const Text('Bluetooth Scanner'),
        ),
        body: Obx(
          () => (controller.status == Status.LOADING)
              ? const Center(
                  child: RiveAnimation.asset('assets/rives/bluetooth_scan.riv',
                      fit: BoxFit.contain),
                )
              : ((controller.result.isEmpty)
                  ? const Center(
                      child: RiveAnimation.asset('assets/rives/no_result.riv',
                          fit: BoxFit.contain),
                    )
                  : ListView.builder(
                      itemCount: controller.result.length,
                      itemBuilder: (context, index) {
                        final data = controller.result[index];
                        return ListTile(
                          title: Text(data.name),
                          subtitle: Text(data.id.toString()),
                        );
                      },
                    )),
        ));
  }
}
