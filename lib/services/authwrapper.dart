import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:saans/screens/authentication/phone_signup.dart';
import 'package:saans/screens/home/homepage.dart';
import 'package:saans/services/auth.dart';
import 'package:saans/services/bluetoothlandingservice.dart';
import 'package:saans/services/hiveservice.dart';
import 'package:saans/standards/global_strings.dart';
import 'package:saans/standards/loading_screen.dart';

class AuthWrapper extends StatefulWidget {
  AuthWrapper({Key key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final User currentUser =
        AuthService().currentUserFunc(); //returns the current user info
    // ignore: avoid_bool_literals_in_conditional_expressions
    final bool phone =
        currentUser != null ? currentUser.phoneNumber != null : false;
    debugPrint('[LOG] from authwrapper=> Phone Number? $phone');
    debugPrint(
        '[LOG] from authwrapper=> authChange user null ? = ${user == null}');
    debugPrint(
        '[LOG] from authwrapper=> currentUser null ? = ${currentUser == null}');
    return FutureBuilder<dynamic>(
      future: HiveService().getData(uname, genInfoBox),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done &&
            user != null &&
            phone) {
          return BluetoothLandingPageService();
        } else if (snap.connectionState == ConnectionState.done &&
            user == null) {
          return PhoneSignUp();
        } else {
          return LoadingWidget(loadingType: 0);
        }
      },
    );
  }
}
