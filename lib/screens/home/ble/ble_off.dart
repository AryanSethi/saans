import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothOffScreen extends StatelessWidget {
  final BluetoothState state;
  const BluetoothOffScreen({this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
                'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
