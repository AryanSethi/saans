import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saans/screens/home/homepage.dart';

class EmergencyContact extends StatefulWidget {
  @override
  _EmergencyContactState createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final docNameController = TextEditingController();
    final docContactController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    @override
    void dispose() {
      docNameController.dispose();
      docContactController.dispose();
      super.dispose();
    }

    Widget customFormField(String hint, TextEditingController controller,
        double height, double width) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.12, vertical: 3),
        child: TextFormField(
          validator: (inp) {
            if (inp.isEmpty) {
              return "Can't be empty";
            } else {
              return null;
            }
          },
          autofocus: true,
          keyboardType: hint == "Whatsapp Contact"
              ? TextInputType.number
              : TextInputType.name,
          onChanged: (_) {},
          onFieldSubmitted: (_) {},
          decoration: InputDecoration(
            labelText: hint,
            fillColor: Colors.white,
          ),
          controller: controller,
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: width,
            height: height,
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.2),
                alignment: Alignment.center,
                child: Text(
                  "Enter the whatsapp number\nof your family Dcotor",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  )),
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Column(
                children: [
                  customFormField(
                      'Doctor Name', docNameController, height, width),
                  customFormField(
                      'Whatsapp Contact', docContactController, height, width),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                        onPressed: () => {Navigator.pop(context)},
                        child: Text(
                          "Save",
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 23)),
                        ),
                      ))
                ],
              ),
            ])),
      ),
    );
  }
}
