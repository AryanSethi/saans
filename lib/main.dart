import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:saans/screens/home/homepage.dart';
import 'package:saans/screens/home/temp_home.dart';
import 'package:saans/services/auth.dart';
import 'package:saans/services/authwrapper.dart';
import 'package:saans/services/bluetoothlandingservice.dart';
import 'package:saans/services/hiveservice.dart';
import 'package:saans/standards/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveService().initializeHive();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<User>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            //routes: {},
            title: 'Saans',
            home: BluetoothLandingPageService()));
  }
}
