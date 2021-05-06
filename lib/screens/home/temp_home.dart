import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saans/screens/authentication/phone_signup.dart';
import 'package:saans/screens/home/graphs/spo2_graph.dart';
import 'package:saans/services/auth.dart';
import 'package:saans/services/hiveservice.dart';
import 'package:saans/standards/global_strings.dart';

class TempHomePage extends StatefulWidget {
  BluetoothDevice device;
  TempHomePage({this.device});

  @override
  _TempHomePageState createState() => _TempHomePageState();
}

class _TempHomePageState extends State<TempHomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
              body: Container(
                color: Colors.black12,
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: width * 0.09, bottom: width * 0.09),
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(6.0, 4.0),
                                  spreadRadius: 0.3,
                                  blurRadius: 10.0)
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            )),
                        height: width * 0.45,
                        width: width * 0.65,
                        child: Card(
                            elevation: 15,
                            color: Colors.teal[400],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: width * 0.04,
                                        horizontal: width * 0.07),
                                    child: Text("SPO2",
                                        style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: width * 0.05)))),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * 0.009,
                                      horizontal: width * 0.05),
                                  child: Text(
                                    "97",
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
                              offset: Offset(6.0, 4.0),
                              spreadRadius: 0.3,
                              blurRadius: 10.0)
                        ], borderRadius: BorderRadius.all(Radius.circular(30))),
                        height: width * 0.45,
                        width: width * 0.65,
                        child: Card(
                            elevation: 15,
                            color: Colors.teal[400],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: width * 0.04,
                                        horizontal: width * 0.07),
                                    child: Text("Pulse Rate",
                                        style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: width * 0.05)))),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * 0.009,
                                      horizontal: width * 0.05),
                                  child: Text(
                                    "134",
                                    style: GoogleFonts.raleway(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.17)),
                                  ),
                                )
                              ],
                            )),
                      ),
                      SPO2Graph(),
                    ],
                  ),
                ),
              )),
        );
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
