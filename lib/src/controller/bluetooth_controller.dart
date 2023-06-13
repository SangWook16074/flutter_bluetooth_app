import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_app/src/constants/flutter_blue_const.dart';
import 'package:get/get.dart';

enum Status { LOADING, LOADED, INIT }

class BluetoothController extends GetxController {
  final _result = Rx<List<BluetoothDevice>>([]);
  final _connect = Rx<List<BluetoothDevice>>([]);
  final _status = Status.INIT.obs;

  List<BluetoothDevice> get result => _result.value;
  List<BluetoothDevice> get connect => _connect.value;
  Status get status => _status.value;

  @override
  void onClose() {
    super.onClose();
    _connect.value.clear();
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
      _result((result.map((r) => r.device).toList()));
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

  void connectDevice(BluetoothDevice data) async {
    try {
      await data.connect().then((value) {
        _connect.value.add(data);
        _connect.refresh();
      });
    } catch (e) {
      print('Error');
    }
  }

  void disconnect(BluetoothDevice data) {
    try {
      data.disconnect().then((value) {
        _connect.value.remove(data);
        _connect.refresh();
      });
    } catch (e) {
      print('Error');
    }
  }
}
