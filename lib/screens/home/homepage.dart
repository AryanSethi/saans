import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saans/screens/authentication/phone_signup.dart';
import 'package:saans/services/auth.dart';
import 'package:saans/services/hiveservice.dart';
import 'package:saans/standards/global_strings.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class HomePage extends StatelessWidget {
  BluetoothDevice device;
  HomePage({this.device});
  @override
  Widget build(BuildContext context) {
    final HiveService _hive = HiveService();
    return FutureBuilder(
      future: _hive.getData(uname, genInfoBox),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String username;
        snapshot.connectionState == ConnectionState.done
            ? username = snapshot.data.toString()
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
                body: StreamBuilder2<List<BluetoothService>,
                    BluetoothDeviceState>(
                  streams: Tuple2(device.services, device.state),
                  builder: (context, snap) {
                    return Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: snap.item1.data.map((service) {
                          return Column(
                              children: service.characteristics.map(
                            (c) {
                              return InkWell(
                                onTap: () async {
                                  await c.read();
                                },
                                child: Text(c.value.toString()),
                              );
                            },
                          ).toList());
                        }).toList(),
                      ),
                    );
                  },
                )));
      },
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
