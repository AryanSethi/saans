import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saans/screens/authentication/phone_signup.dart';
import 'package:saans/services/auth.dart';
import 'package:saans/services/hiveservice.dart';
import 'package:saans/standards/global_strings.dart';
import 'package:saans/standards/loading_screen.dart';

class HomePage extends StatelessWidget {
  BluetoothDevice device;
  HomePage({this.device});
  @override
  Widget build(BuildContext context) {
    read(BluetoothCharacteristic c) async {
      await c.setNotifyValue(!c.isNotifying);
      await c.read();
    }

    debugPrint("[LOG] device sent to homepage => $device");
    final HiveService _hive = HiveService();
    return RefreshIndicator(
      onRefresh: () => device.discoverServices(),
      child: FutureBuilder<dynamic>(
        future: _hive.getData(uname, genInfoBox),
        builder: (BuildContext context, AsyncSnapshot unameSnap) {
          String username;
          unameSnap.connectionState == ConnectionState.done
              ? username = unameSnap.data.toString()
              : username = "";
          return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.black87,
                    elevation: 20,
                    title: Text(
                      "Howdy $username!",
                      style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                        color: Colors.white,
                      )),
                    ),
                    centerTitle: true,
                    actions: <Widget>[popupmenubotton(context)],
                  ),
                  body: StreamBuilder<BluetoothDeviceState>(
                    stream: device.state,
                    builder: (context, deviceStateSnap) {
                      return deviceStateSnap.data ==
                              BluetoothDeviceState.connected
                          ? StreamBuilder<List<BluetoothService>>(
                              stream: device.services,
                              builder:
                                  (BuildContext context, deviceServicesSnap) {
                                if (deviceServicesSnap.hasData &&
                                    device.discoverServices() != null) {
                                  return Column(
                                    children: deviceServicesSnap.data.map((s) {
                                      print("service uuid = ${s.uuid}");
                                      if (s.uuid
                                              .toString()
                                              .toUpperCase()
                                              .substring(4, 8) ==
                                          '5343') {
                                        print("FOund the required service");
                                        return Column(
                                          children: s.characteristics.map((c) {
                                            print('Char');
                                            print(c.uuid);
                                            if (c.uuid.toString().trim() ==
                                                "49535343-1e4d-4bd9-ba61-23c647249616") {
                                              read(c);
                                              print("found the char");
                                              return StreamBuilder<List<int>>(
                                                  stream: c.value,
                                                  initialData: c.lastValue,
                                                  builder: (context, valSnap) {
                                                    final value = valSnap.data;
                                                    print(
                                                        "Val snap = > ${value.toString()}");
                                                    return valSnap.hasData
                                                        ? Text(value.toString())
                                                        : Text("No data yet");
                                                  });
                                            } else {
                                              print("char id dindnt match");
                                              return Container();
                                            }
                                          }).toList(),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }).toList(),
                                  );
                                } else {
                                  return LoadingWidget();
                                }
                              })
                          : LoadingWidget();
                    },
                  )));
        },
      ),
    );
  }
}

PopupMenuButton popupmenubotton(BuildContext context) {
  return PopupMenuButton(
    color: Colors.blueGrey[200],
    onSelected: (fn) async {
      if (fn == logout) {
        await AuthService().signOut().then((value) => value == true
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PhoneSignUp()),
                (route) => false)
            : debugPrint("[log] Sign out error"));
      }
    },
    itemBuilder: (_) => <PopupMenuItem<String>>[
      const PopupMenuItem<String>(value: settings, child: Text(settings)),
      const PopupMenuItem<String>(value: help, child: Text(help)),
      const PopupMenuItem<String>(value: logout, child: Text(logout)),
    ],
  );
}
