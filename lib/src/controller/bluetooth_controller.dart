import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

enum Status { LOADING, LOADED }

class BluetoothController extends GetxController {
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final _result = Rx<List<BluetoothDevice>>([]);
  final _status = Status.LOADED.obs;

  List<BluetoothDevice> get result => _result.value;
  Status get status => _status.value;

  @override
  void onInit() {
    super.onInit();
    startScan();
  }

  void startScan() async {
    _status(Status.LOADING);
    await flutterBlue
        .startScan(timeout: const Duration(seconds: 4))
        .then((value) {
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
