import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

enum Status { LOADING, LOADED, INIT }

class BluetoothController extends GetxController {
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final _result = Rx<List<BluetoothDevice>>([]);
  final _status = Status.INIT.obs;

  List<BluetoothDevice> get result => _result.value;
  Status get status => _status.value;

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
    _status(Status.LOADING);
    flutterBlue.startScan(timeout: const Duration(seconds: 4)).then((value) {
      _result.refresh();
      _status(Status.LOADED);
    });

    flutterBlue.scanResults.listen((result) {
      _result(result.map((r) => r.device).toList());
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
}
