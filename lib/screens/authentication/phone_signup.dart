import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saans/services/auth.dart';
import 'package:saans/services/hiveservice.dart';
import 'package:saans/standards/global_strings.dart';
import 'package:saans/standards/loading_screen.dart';

class PhoneSignUp extends StatefulWidget {
  @override
  _PhoneSignUpState createState() => _PhoneSignUpState();
}

class _PhoneSignUpState extends State<PhoneSignUp> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _auth = AuthService();
  bool loading = false;
  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: Column(
            children: [
              Image(
                image: const AssetImage('assets/health.png'),
                height: height * 0.3,
              ),
              Container(
                  margin: EdgeInsets.only(top: height * 0.02),
                  child: Text(
                    signup,
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    )),
                  )),
              SizedBox(
                height: height * 0.08,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.12, vertical: height * 0.001),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "First Name",
                  ),
                  maxLength: 15,
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.12, vertical: height * 0.001),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: _numberController,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: height * 0.03),
                  margin: EdgeInsets.symmetric(horizontal: width * 0.2),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                      ),
                      onPressed: () async {
                        HiveService().addDataInBox(
                            uname, _nameController.text, genInfoBox);
                        if (_auth.validatePhoneNumer(_numberController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Sending OTP"),
                              action: SnackBarAction(
                                  label: "Okay", onPressed: () {})));
                          await _auth.sendPhoneVerification(
                              _numberController.text, context);
                          loading = true;
                        } else {
                          //TODO: display a snackbar here
                          debugPrint(
                              "[LOG] from phoneSignup=> Phone number entered is not valid");
                        }
                      },
                      child: Text(
                        getOTP,
                        style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 23)),
                      ))),
            ],
          ),
        ),
      ),
    ));
  }
}
