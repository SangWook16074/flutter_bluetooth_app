import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:flutter_bluetooth_app/src/binding/app_binding.dart';
import 'package:flutter_bluetooth_app/src/constants/flutter_blue_const.dart';
import 'package:flutter_bluetooth_app/src/model/device_model.dart';
import 'package:flutter_bluetooth_app/src/res/rive_path.dart';
import 'package:flutter_bluetooth_app/src/view/check.dart';
import 'package:flutter_bluetooth_app/src/view/home.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

enum Status { LOADING, LOADED, INIT }

class BluetoothController extends GetxController {
  final _result = Rx<List<DeviceModel>>([]);
  final _already = Rx<List<DeviceModel>>([]);

  final _status = Status.INIT.obs;

  List<DeviceModel> get result => _result.value;
  List<DeviceModel> get aleady => _already.value;

  Status get status => _status.value;

  @override
  void onInit() {
    super.onInit();
    moveToPage();
    fetchAlreadyConnected();
    _result.bindStream(startScan());
  }

  void fetchAlreadyConnected() async {
    await flutterBlue.connectedDevices.then((devices) {
      _result.value.addAll(devices
          .map((device) => DeviceModel.fromAlreadyConnect(device))
          .toList());
    });

    _result.refresh();
    print(_result.value);
  }

  void moveToPage() {
    flutterBlue.state.listen((state) {
      if (state == BluetoothState.on) {
        Get.off(() => const Home(),
            binding: AppBinding(), transition: Transition.fadeIn);
      } else {
        Get.off(() => const Check(), transition: Transition.fadeIn);
      }
    });
  }

  void fabAction() {
    switch (_status.value) {
      case Status.LOADING:
        stopScan();
        break;
      case Status.LOADED:
      case Status.INIT:
        startScan();
        break;
    }
  }

  Stream<List<DeviceModel>> startScan() {
    _result.value.clear();
    // _connect.value.clear();
    _status(Status.LOADING);
    flutterBlue.startScan(timeout: const Duration(seconds: 4)).then((value) {
      _status(Status.LOADED);
    });

    return flutterBlue.scanResults.map((results) {
      List<DeviceModel> devices = [];
      for (var result in results) {
        if (result.device.name == 'LED DEVICE') {
          final device = DeviceModel.fromScan(result);
          devices.add(device);
        }
      }
      return devices;
    });
  }

  void stopScan() {
    flutterBlue.stopScan();
    _status(Status.LOADED);
  }

  void removeDevice(int index) {
    _result.value.removeAt(index);
    _result.refresh();
  }

  void connectDevice(DeviceModel deviceModel) async {
    try {
      await deviceModel.device!.connect().then((value) {
        _showConnectToast();
        deviceModel.isConnected = true;
        _result.refresh();
      });
    } catch (e) {
      _showErrorToast();
    }
  }

  void disconnect(DeviceModel deviceModel) {
    try {
      deviceModel.device!.disconnect().then((value) {
        _showDisconnectToast();
        deviceModel.isConnected = false;
        _result.refresh();
      });
    } catch (e) {
      _showErrorToast();
    }
  }

  void showToast(String msg, String path) async {
    Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          child: Container(
            width: 80,
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.0)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 80, height: 80, child: RiveAnimation.asset(path)),
                  Text(
                    msg,
                    style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.1),
        barrierDismissible: false,
        transitionCurve: Curves.easeInOutBack);

    await Future.delayed(const Duration(milliseconds: 1500));
    Get.back();
  }

  void _showConnectToast() => showToast('Connected', RiveAssetPath.connect);

  void _showDisconnectToast() =>
      showToast('Disconneted', RiveAssetPath.disconnect);

  void _showErrorToast() => showToast('Error !', 'error');

  Future<List<int>> searchService(DeviceModel deviceModel) async {
    debugPrint('Start Read');

    List<int> result = [];

    try {
      List<BluetoothService> services =
          await deviceModel.device!.discoverServices();
      for (var service in services) {
        if (service.uuid.toString() == '4fafc201-1fb5-459e-8fcc-c5c9c331914b') {
          var cs = service.characteristics;
          for (BluetoothCharacteristic c in cs) {
            result = await c.read();
          }
        }
      }
      return result;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  void sendData(BluetoothDevice device, String data) async {
    Guid serviceUuid = Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
    Guid characteristicUuid = Guid("beb5483e-36e1-4688-b7f5-ea07361b26a8");

    List<BluetoothService> services = await device.discoverServices();
    BluetoothService service =
        services.firstWhere((s) => s.uuid == serviceUuid);
    BluetoothCharacteristic characteristic =
        service.characteristics.firstWhere((c) => c.uuid == characteristicUuid);

    List<int> value = utf8.encode(data); // Convert string to byte list

    try {
      await characteristic.write(value);
      print("Data sent successfully");
    } catch (e) {
      print("error");
    }
  }
}
