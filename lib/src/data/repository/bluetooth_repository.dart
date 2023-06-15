import 'package:flutter_bluetooth_app/src/data/model/bluetooth_device_model.dart';
import 'package:flutter_bluetooth_app/src/data/provider/bluetooth_provider.dart';

class BluetoothRepository {
  static Stream<List<DeviceModel>> getDevices() => BluetoothApi.getDevices();

  static Future<List<DeviceModel>> getConnectedDevices() =>
      BluetoothApi.getConnectedDevices();
}
