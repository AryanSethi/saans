import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:saans/screens/home/ble/ble_off.dart';
import 'package:saans/screens/home/ble/scan_devices_screen.dart';
import 'package:saans/standards/loading_screen.dart';

class BluetoothLandingPageService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("[LOG] Into bluetoothLandingPageService");
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snap) {
          final state = snap.data;
          if (state == BluetoothState.on) {
            debugPrint("[LOG] bluetooth on");
            return ScanDevicesScreen();
          } else if (state == BluetoothState.off) {
            debugPrint("[LOG] bluetooth off");
            return BluetoothOffScreen(
              state: state,
            );
          } else {
            return LoadingWidget(
              loadingType: 0,
            );
          }
        });
  }
}
