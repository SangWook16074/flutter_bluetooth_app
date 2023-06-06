import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/src/components/no_result.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
              ? _scan()
              : ((controller.result.isEmpty) ? _noResult() : _result()),
        ));
  }

  Widget _result() {
    return ListView.builder(
      itemCount: controller.result.length,
      itemBuilder: (context, index) {
        final data = controller.result[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slidable(
            endActionPane: ActionPane(
              extentRatio: 0.4,
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  spacing: 2,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: (_) {
                    controller.removeDevice(index);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.close,
                  label: 'remove',
                  borderRadius: BorderRadius.circular(12.0),
                ),
                SlidableAction(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: (_) {},
                  backgroundColor: const Color(0xff08d0fc),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'connect',
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ],
            ),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: ListTile(
                leading: const Icon(
                  Icons.bluetooth,
                  color: Colors.blue,
                  size: 40,
                ),
                title: Text(
                  (data.name.isEmpty) ? 'Known' : data.name,
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                subtitle: Text(data.id.toString()),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _scan() {
    return const Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: RiveAnimation.asset(
          'assets/rives/circular_progress_indicator.riv',
        ),
      ),
    );
  }

  Widget _noResult() {
    return const NoResult(width: 300, height: 300);
  }
}
