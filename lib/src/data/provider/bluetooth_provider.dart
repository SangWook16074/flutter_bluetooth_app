import 'package:flutter_bluetooth_app/src/data/model/bluetooth_device_model.dart';

class BluetoothApi {
  static Future<void> connectDevice(DeviceModel deviceModel) async {
    await deviceModel.device!.connect();
  }

  static Future<void> disconnect(DeviceModel deviceModel) async {
    await deviceModel.device!.disconnect();
  }
}
