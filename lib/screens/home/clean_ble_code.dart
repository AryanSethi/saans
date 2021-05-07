import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:saans/services/bluetooth_services.dart';
import 'package:saans/standards/loading_screen.dart';

class CleanCode extends StatefulWidget {
  BluetoothDevice device;
  CleanCode({this.device});

  @override
  _CleanCodeState createState() => _CleanCodeState();
}

class _CleanCodeState extends State<CleanCode> {
  final BluetoothServices _bleService = BluetoothServices();
  List<int> info;

  @override
  Widget build(BuildContext context) {
    BluetoothCharacteristic char;
    _bleService.getService(widget.device).then((ser) {
      char = _bleService.getcharacteristic(ser);
      char.value.listen((newValue) {
        setState(() {
          debugPrint(
              "[LOG] Notified about char value, value = ${newValue.toString()}");
          info = newValue.toList();
        });
      });
    });
    return char != null
        ? RefreshIndicator(
            onRefresh: () => widget.device.discoverServices(),
            child:
                // StreamBuilder<List<int>>(
                //     stream: char.value,
                //     builder: (c, snap) {
                //       return Container(
                //         child: snap.data.length > 2
                //             ? Text(
                //                 snap.data.toString(),
                //                 style: const TextStyle(fontSize: 20),
                //               )
                //             : const Text("No Data yet",
                //                 style: TextStyle(fontSize: 20)),
                //       );
                //     }),
                Container(
              child: info.length > 2
                  ? Text(info.toString(), style: const TextStyle(fontSize: 20))
                  : const Text("No data yet", style: TextStyle(fontSize: 20)),
            ))
        : LoadingWidget();
  }
}
