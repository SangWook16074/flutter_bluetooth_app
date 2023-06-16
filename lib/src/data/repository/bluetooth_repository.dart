import 'package:flutter_bluetooth_app/src/data/model/bluetooth_device_model.dart';
import 'package:flutter_bluetooth_app/src/data/provider/bluetooth_discover_service.dart';

class BluetoothRepository {
  static Stream<List<DeviceModel>> getDevices() =>
      BluetoothDiscovery.getDevices();

  static Future<List<DeviceModel>> getConnectedDevices() =>
      BluetoothDiscovery.getConnectedDevices();
}
