import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:saans/services/auth.dart';
import 'package:saans/standards/global_strings.dart';

class OTPScreen extends StatefulWidget {
  String phone;
  String verID;
  OTPScreen({required this.phone, required this.verID});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  void dispose() {
    _pinPutController.dispose();
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
        width: width,
        height: height,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.25),
              child: Text(
                "Verify ${widget.phone}",
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 30)),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.25),
              child: Text(
                "\nAn OTP has been sent to your Phone number. Enter it for verification.\nMake sure you have an active internet connection",
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.09),
              child: PinPut(
                fieldsCount: 6,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green[200]),
                selectedFieldDecoration: _pinPutDecoration,
                followingFieldDecoration: _pinPutDecoration.copyWith(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.blue.withOpacity(.5),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.08,
            ),
            Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                  ),
                  onPressed: () async {
                    AuthService().verifyPhone(context, widget.verID,
                        _pinPutController.text, widget.phone);
                  },
                  child: Text(
                    verify,
                    style: GoogleFonts.raleway(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 23)),
                  ),
                )),
          ],
        ),
      ),
    )));
  }
}
