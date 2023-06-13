import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/src/components/no_result.dart';
import 'package:flutter_bluetooth_app/src/res/rive_path.dart';
import 'package:flutter_bluetooth_app/src/view/connect.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' as rive;

import '../controller/bluetooth_controller.dart';

class Home extends GetView<BluetoothController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Obx(
          () => FloatingActionButton.extended(
            onPressed: controller.fabAction,
            label: (controller.status == Status.LOADING)
                ? const Text('Stop')
                : const Text('Scan'),
            icon: (controller.status == Status.LOADING)
                ? const Icon(Icons.square)
                : const Icon(Icons.search),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        extendBodyBehindAppBar: true,
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
          child: Obx(
            () => _home(),
          ),
        ));
  }

  Widget _home() {
    switch (controller.status) {
      case Status.LOADING:
        return _scan();

      case Status.LOADED:
        return _result();

      case Status.INIT:
        return _init();
    }
  }

  Widget _result() {
    return (controller.result.isEmpty)
        ? _noResult()
        : SafeArea(
            child: Column(
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Available LED\'s',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
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
                                onPressed: (_) {
                                  controller.connectDevice(data);
                                },
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
                              tileColor: (data.isConnected)
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.white,
                              onTap: () {
                                if (!data.isConnected) {
                                  return;
                                }
                                Get.to(() => const Connect());
                              },
                              leading: const Icon(
                                Icons.bluetooth,
                                color: Color(0xff03b6dc),
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
                  ),
                ),
              ],
            ),
          );
  }

  Widget _scan() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: rive.RiveAnimation.asset(
          RiveAssetPath.search,
        ),
      ),
    );
  }

  Widget _noResult() {
    return const NoResult(width: 300, height: 300);
  }

  Widget _init() {
    return rive.RiveAnimation.asset(RiveAssetPath.onboard);
  }
}
