import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceModel {
  BluetoothDevice? device;
  late String name;
  late DeviceIdentifier id;
  late bool isConnected;

  DeviceModel({required this.device, required this.name, required this.id});

  DeviceModel.fromScan(ScanResult result) {
    device = result.device;
    name = result.device.name;
    id = result.device.id;
    isConnected = false;
  }

  DeviceModel.fromAlreadyConnect(BluetoothDevice device) {
    device = device;
    name = device.name;
    id = device.id;
    isConnected = true;
  }
}
