import 'package:flutter_bluetooth_app/src/constants/flutter_blue_const.dart';
import 'package:flutter_bluetooth_app/src/constants/pref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/bluetooth_device_model.dart';

class BluetoothDiscovery {
  static Stream<List<DeviceModel>> getDevices() {
    flutterBlue.startScan(timeout: const Duration(seconds: 5));
    return flutterBlue.scanResults.map((results) {
      List<DeviceModel> devices = [];
      for (var result in results) {
        if (result.device.name == 'LED BLE MESH SERVER') {
          SharedPreferences.getInstance().then((prefs) {
            List<String> connectDevices =
                prefs.getStringList(PrefsKey.deviceListKey) ?? [];
            if (!connectDevices.contains(result.device.id.toString())) {
              return;
            }
            // result.device.state.listen((isConnect) {
            //   if (isConnect == BluetoothDeviceState.disconnected) {
            //     debugPrint("자동연결");
            //     result.device.connect();
            //     return;
            //   }
            // });
          });

          final device = DeviceModel.fromScan(result);
          devices.add(device);
        }
      }
      return devices;
    });
  }

  static Future<List<DeviceModel>> getConnectedDevices() async {
    return flutterBlue.connectedDevices.then((connects) {
      List<DeviceModel> devices = [];
      for (var connect in connects) {
        final device = DeviceModel.fromAlreadyConnect(connect);
        devices.add(device);
      }
      return devices;
    });
  }
}
