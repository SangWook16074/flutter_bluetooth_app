import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:flutter_bluetooth_app/src/constants/flutter_blue_const.dart';
import 'package:flutter_bluetooth_app/src/data/model/bluetooth_device_model.dart';
import 'package:flutter_bluetooth_app/src/data/provider/bluetooth_provider.dart';
import 'package:flutter_bluetooth_app/src/data/repository/bluetooth_repository.dart';
import 'package:flutter_bluetooth_app/src/res/rive_path.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

enum Status { LOADING, LOADED }

class BluetoothController extends GetxController {
  final _result = Rx<List<DeviceModel>>([]);
  final _already = Rx<List<DeviceModel>>([]);

  final _status = Status.LOADED.obs;

  List<DeviceModel> get result => _result.value;
  List<DeviceModel> get already => _already.value;

  Status get status => _status.value;
  set already(value) => _already.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchAlreadyConnected();
    startScan();
  }

  void stateListener() {}

  void fetchAlreadyConnected() {
    BluetoothRepository.getConnectedDevices().then((data) {
      already = data;
    });
  }

  void fabAction() {
    switch (_status.value) {
      case Status.LOADING:
        stopScan();
        break;
      case Status.LOADED:
        startScan();
        break;
    }
  }

  void startScan() {
    _status(Status.LOADING);
    _result.bindStream(BluetoothRepository.getDevices());
    _status(Status.LOADED);
  }

  void stopScan() {
    flutterBlue.stopScan();
    _status(Status.LOADED);
  }

  void removeDevice(int index) {
    _result.value.removeAt(index);
    _result.refresh();
  }

  Future<void> connectDevice(DeviceModel deviceModel) async {
    try {
      await BluetoothApi.connectDevice(deviceModel).then((value) {
        _showConnectToast();
        result.remove(deviceModel);
        deviceModel.isConnected = true;
        already.add(deviceModel);
        _result.refresh();
      });
    } catch (e) {
      _showErrorToast();
    }
  }

  Future<void> disconnect(DeviceModel deviceModel) async {
    try {
      BluetoothApi.disconnect(deviceModel).then((value) {
        _showDisconnectToast();
        already.remove(deviceModel);
        _already.refresh();
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
