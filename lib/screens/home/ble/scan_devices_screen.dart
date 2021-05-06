import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:saans/screens/home/ble/scanned_device_tile.dart';
import 'package:saans/screens/home/homepage.dart';

class ScanDevicesScreen extends StatelessWidget {
  const ScanDevicesScreen({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool deviceFound = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find your device',
          textAlign: TextAlign.center,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Connected devices
              StreamBuilder<List<BluetoothDevice>>(
                  //TODO: use a single stream provider with multiple streams
                  stream: Stream.periodic(const Duration(seconds: 2))
                      .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                  initialData: const [],
                  builder: (c, snapshot) {
                    BluetoothDevice res;
                    for (final BluetoothDevice device in snapshot.data) {
                      if (device.name == "Mike") {
                        res = device;
                        deviceFound = true;
                        break;
                      }
                    }
                    return Container(
                      child: res != null
                          ? ListTile(
                              title: const Text("Mike"),
                              subtitle: Text(res.id.toString()),
                              trailing: StreamBuilder<BluetoothDeviceState>(
                                  stream: res.state,
                                  initialData:
                                      BluetoothDeviceState.disconnected,
                                  builder: (c, snapshot) {
                                    if (snapshot.data ==
                                        BluetoothDeviceState.connected) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: width * 0.05),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            res
                                                .discoverServices()
                                                .then((value) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(
                                                            device: res,
                                                          )));
                                            });
                                          },
                                          child: const Text('Start monitoring'),
                                        ),
                                      );
                                    }
                                    return Text(snapshot.data.toString());
                                  }))
                          : Container(),
                    );
                  }),
              //Scanned devices
              StreamBuilder<List<ScanResult>>(
                  stream: FlutterBlue.instance.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) {
                    ScanResult res;
                    for (final ScanResult device in snapshot.data) {
                      if (device.device.name == "Mike") {
                        res = device;
                        break;
                      }
                    }
                    return Container(
                      child: (res != null && deviceFound == false)
                          ? ScannedDeviceTile(
                              result: res,
                              onTap: () {
                                res.device.connect();
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  res.device.discoverServices();
                                  return HomePage(
                                    device: res.device,
                                  );
                                }));
                              },
                            )
                          : Container(),
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              onPressed: () => FlutterBlue.instance
                  .startScan(timeout: const Duration(seconds: 4)),
              child: const Icon(Icons.search),
            );
          }
        },
      ),
    );
  }
}
