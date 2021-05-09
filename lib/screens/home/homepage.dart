import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saans/screens/authentication/phone_signup.dart';
import 'package:saans/screens/home/emergency_contact.dart';
import 'package:saans/screens/home/graphs/spo2_graph.dart';
import 'package:saans/services/auth.dart';
import 'package:saans/services/hiveservice.dart';
import 'package:saans/standards/global_strings.dart';
import 'package:saans/standards/loading_screen.dart';

class HomePage extends StatelessWidget {
  BluetoothDevice? device;
  HomePage({this.device});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    int lastspo2 = 0;
    int lastpulse = 0;
    void read(BluetoothCharacteristic c) async {
      await c.setNotifyValue(
          true); /////////////////////////////////////////////////////////////////////////////////changed
      await c.read();
    }

    debugPrint("[LOG] device sent to homepage => $device");
    final HiveService _hive = HiveService();
    return RefreshIndicator(
      onRefresh: () => device!.discoverServices(),
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
                  body: Container(
                    color: Colors.black12,
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: StreamBuilder<BluetoothDeviceState>(
                        stream: device!.state,
                        builder: (context, deviceStateSnap) {
                          return deviceStateSnap.data ==
                                  BluetoothDeviceState.connected
                              ? StreamBuilder<List<BluetoothService>>(
                                  stream: device!.services,
                                  builder: (BuildContext context,
                                      deviceServicesSnap) {
                                    if (deviceServicesSnap.hasData &&
                                        device!.discoverServices() != null) {
                                      return Column(
                                        children:
                                            deviceServicesSnap.data!.map((s) {
                                          print("service uuid = ${s.uuid}");
                                          if (s.uuid
                                                  .toString()
                                                  .toUpperCase()
                                                  .substring(4, 8) ==
                                              '5343') {
                                            //print("FOund the required service");
                                            return Column(
                                              children:
                                                  s.characteristics.map((c) {
                                                print('Char');
                                                print(c.uuid);
                                                if (c.uuid.toString().trim() ==
                                                    "49535343-1e4d-4bd9-ba61-23c647249616") {
                                                  read(c);
                                                  String d;
                                                  c.value.listen((event) {
                                                    d = event.toString();
                                                  });
                                                  return StreamBuilder<
                                                          List<int>>(
                                                      stream: c.value,
                                                      initialData: c.lastValue,
                                                      builder:
                                                          (context, valSnap) {
                                                        final value =
                                                            valSnap.data!;
                                                        debugPrint(
                                                            "Val snap = > ${value.toString()}");
                                                        if (value.length > 2) {
                                                          lastspo2 = value[4];
                                                          lastpulse = value[3];
                                                        }
                                                        return valSnap.hasData
                                                            ? uiBuilder(
                                                                context,
                                                                height,
                                                                width,
                                                                value,
                                                                lastspo2,
                                                                lastpulse)
                                                            : const Text(
                                                                "No data yet");
                                                      });
                                                } else {
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
                      ),
                    ),
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
      } else if (fn == addDoc) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EmergencyContact()));
      }
    },
    itemBuilder: (_) => <PopupMenuItem<String>>[
      const PopupMenuItem<String>(value: addDoc, child: Text(addDoc)),
      const PopupMenuItem<String>(value: help, child: Text(help)),
      const PopupMenuItem<String>(value: logout, child: Text(logout)),
    ],
  );
}

Widget uiBuilder(BuildContext context, double height, double width,
    List<int> data, int lastspo2, int lastpulse) {
  String spo2 = lastspo2.toString();
  String pulse = lastpulse.toString();
  if (data.length > 2) {
    if ((data[4] - lastspo2).abs() <= 1) {
      spo2 = lastspo2.toString();
    } else {
      spo2 = data[4].toString();
    }
    if ((data[3] - lastpulse).abs() <= 1) {
      pulse = lastpulse.toString();
    } else {
      pulse = data[3].toString();
    }
    // spo2 = data[4].toString();
    // pulse = data[3].toString();
  }
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: width * 0.09, bottom: width * 0.09),
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(6.0, 4.0), spreadRadius: 0.3, blurRadius: 10.0)
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            )),
        height: width * 0.45,
        width: width * 0.65,
        child: Card(
            elevation: 15,
            color: Colors.teal[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.04, horizontal: width * 0.07),
                    child: Text("SPO2",
                        style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05)))),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.009, horizontal: width * 0.05),
                  child: Text(
                    spo2,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.17)),
                  ),
                )
              ],
            )),
      ),
      Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset(6.0, 4.0), spreadRadius: 0.3, blurRadius: 10.0)
        ], borderRadius: BorderRadius.all(Radius.circular(30))),
        height: width * 0.45,
        width: width * 0.65,
        child: Card(
            elevation: 15,
            color: Colors.teal[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.04, horizontal: width * 0.07),
                    child: Text("Pulse Rate",
                        style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05)))),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.009, horizontal: width * 0.05),
                  child: Text(
                    pulse,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.17)),
                  ),
                )
              ],
            )),
      ),
      //SPO2Graph(),
    ],
  );
}
