import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saans/screens/authentication/otp_screen.dart';
import 'package:saans/screens/home/homepage.dart';
import 'package:saans/services/firestore.dart';
import 'package:saans/services/hiveservice.dart';
import 'package:saans/standards/global_strings.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HiveService _hive = HiveService();

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  User currentUserFunc() {
    return _auth.currentUser;
  }

  bool validatePhoneNumer(String number) {
    final List<String> digs = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0'
    ];
    final bool tenDig = number.length == 10;
    final bool notEmpty = number.isNotEmpty;
    bool onlyDig = false;
    if (tenDig) {
      for (int i = 0; i <= 9; i++) {
        if (digs.contains(number[i])) {
          onlyDig = true;
        } else {
          return false;
        }
      }
    }
    if (tenDig == true && notEmpty == true && onlyDig == true) {
      debugPrint("[LOG] phone number is valid");
      return true;
    } else {
      debugPrint("[LOG] phone number is not valid");
      return false;
    }
  }

  Future<void> sendPhoneVerification(String phone, BuildContext context) async {
    debugPrint(
        '[LOG] from authservice => Attempting to send otp to phone number');
    final String phoneNumber = '+91$phone';
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          debugPrint(
              "[LOG] from SendPhoneVerification => verification complete, credential = $credential");
        },
        verificationFailed: (_) => debugPrint(
            "[LOG] from SendPhoneVerification => phone number verification failed"), //TODO : show a snackbar here saying, no. of otp limits exceded
        // ignore: void_checks
        codeSent: (String verificationID, [int forcedResendingToken]) {
          debugPrint("[LOG] from sendPhoneverification => code sent");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  OTPScreen(phone: phoneNumber, verID: verificationID)));
        },
        codeAutoRetrievalTimeout: (String id) {
          debugPrint(
              "[LOG] from phone verification=> codeAutoretrieval timeout =$id");
        },
        timeout: const Duration(seconds: 60));
  }

  void verifyPhone(
      BuildContext context, String otp, String sms, String phoneNum) async {
    try {
      await _auth
          .signInWithCredential(
              PhoneAuthProvider.credential(verificationId: otp, smsCode: sms))
          .then((value) {
        _hive.getData(uname, genInfoBox).then((username) {
          final User currentUser = currentUserFunc();
          FirestoreService(uid: currentUser.uid)
              .addUserData(name: username.toString(), phone: phoneNum);
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      });
    } catch (e) {
      debugPrint(
          "[LOG] from verifyphone=> prolly wrong otp entered, error = $e");
    }
  }

  Future<bool> signOut() async {
    try {
      debugPrint('[LOG]from authservice=>  Attempting to sign out');
      await _auth.signOut();
      return true;
    } catch (e) {
      debugPrint("[LOG]from authservice=>  SIGNOUT ERROR");
      debugPrint(e.toString());
      return false;
    }
  }
}
