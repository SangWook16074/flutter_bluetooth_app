import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_app/src/controller/bluetooth_controller.dart';
import 'package:flutter_bluetooth_app/src/data/model/bluetooth_device_model.dart';
import 'package:flutter_bluetooth_app/src/res/rive_path.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' as rive;

class Connect extends StatefulWidget {
  final DeviceModel deviceModel;
  bool current;
  Connect({super.key, required this.deviceModel, this.current = false});

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  late List<String> values;

  @override
  void initState() {
    super.initState();
    initStatus();
  }

  initStatus() async {
    var result =
        await Get.find<BluetoothController>().searchService(widget.deviceModel);
    if (result != []) {
      print(String.fromCharCodes(result));
      setState(() {
        if (String.fromCharCodes(result) == '0') {
          widget.current = false;
        } else {
          widget.current = true;
        }
      });
    } else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GetBuilder<BluetoothController>(
            builder: (controller) => IconButton(
                onPressed: () async {
                  controller.sendData(widget.deviceModel.device!, "1");
                  setState(() {
                    widget.current = false;
                  });
                },
                icon: const Icon(Icons.add)),
          )
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                ],
                colors: [
                  Color(0xff081c1d),
                  Color(0xff0b2a2d),
                  Color(0xff0d393f),
                ]),
          ),
          child: _body()),
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GetBuilder<BluetoothController>(
            builder: (controller) => GestureDetector(
              onTap: () async {
                if (widget.current) {
                  controller.sendData(widget.deviceModel.device!, "0");
                } else {
                  controller.sendData(widget.deviceModel.device!, "1");
                }
                setState(() {
                  widget.current = !widget.current;
                });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: SizedBox(
                        width: 300,
                        height: 300,
                        child: rive.RiveAnimation.asset((widget.current)
                            ? RiveAssetPath.ledOn
                            : RiveAssetPath.ledOff)),
                  ),
                ),
              ),
            ),
          ),
          GetBuilder<BluetoothController>(
            builder: (controller) => IconButton(
                onPressed: () => controller.disconnect(widget.deviceModel),
                icon: const Icon(Icons.close)),
          )
        ],
      ),
    );
  }
}
