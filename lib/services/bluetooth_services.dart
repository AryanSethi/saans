import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothServices {
  FlutterBlue bleInstance = FlutterBlue.instance;

  void readCharacteristic(BluetoothCharacteristic c) async {
    await c.setNotifyValue(true);
    await c.read();
  }

  Future<BluetoothService> getService(BluetoothDevice device) async {
    final List<BluetoothService> services = await device.discoverServices();
    BluetoothService res;
    for (BluetoothService s in services) {
      if (s.uuid.toString().toUpperCase().substring(4, 8) == '5343') {
        res = s;
        break;
      }
    }
    debugPrint("[LOG] Service found = $res");
    return res;
  }

  BluetoothCharacteristic getcharacteristic(BluetoothService service) {
    final List<BluetoothCharacteristic> characteristics =
        service.characteristics;
    BluetoothCharacteristic res;
    for (BluetoothCharacteristic c in characteristics) {
      if (c.uuid.toString().trim() == "49535343-1e4d-4bd9-ba61-23c647249616") {
        res = c;
        readCharacteristic(c);
        break;
      }
    }
    debugPrint("[LOG] characteristic found = $res");
    return res;
  }
}
