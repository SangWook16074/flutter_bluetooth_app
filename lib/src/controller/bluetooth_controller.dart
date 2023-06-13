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

  final _status = Status.INIT.obs;

  List<DeviceModel> get result => _result.value;

  Status get status => _status.value;

  @override
  void onInit() {
    super.onInit();
    moveToPage();
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

  void startScan() {
    _result.value.clear();
    // _connect.value.clear();
    _status(Status.LOADING);
    flutterBlue.startScan(timeout: const Duration(seconds: 4)).then((value) {
      _status(Status.LOADED);
    });

    flutterBlue.scanResults.listen((result) {
      _result((result
          .where((r) => r.device.name == 'LED DEVICE')
          .map((r) => DeviceModel.fromScan(r))
          .toList()));
      _result.refresh();
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
}
