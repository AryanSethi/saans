import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class CleanCode extends StatelessWidget {
  BluetoothDevice device;
  CleanCode({this.device});

  void read(BluetoothCharacteristic c) async {
    await c.setNotifyValue(!c.isNotifying);
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
        read(c);
        break;
      }
    }
    debugPrint("[LOG] characteristic found = $res");
    return res;
  }

  @override
  Widget build(BuildContext context) {
    BluetoothCharacteristic char;
    getService(device).then((ser) {
      char = getcharacteristic(ser);
    });
    return RefreshIndicator(
      onRefresh: () => device.discoverServices(),
      child: StreamBuilder<List<int>>(
          stream: char.value,
          builder: (c, snap) {
            return Container(
              child: snap.data != null
                  ? Text(
                      snap.data.toString(),
                      style: const TextStyle(fontSize: 20),
                    )
                  : const Text("No Data yet", style: TextStyle(fontSize: 20)),
            );
          }),
    );
  }
}
