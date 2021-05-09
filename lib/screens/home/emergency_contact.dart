import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saans/services/auth.dart';
import 'package:saans/services/firestore.dart';
import 'package:saans/standards/global_strings.dart';

class EmergencyContact extends StatefulWidget {
  @override
  _EmergencyContactState createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  final AuthService _authService = AuthService();
  final docNameController = TextEditingController();
  final docContactController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final FirestoreService _firestoreService =
        FirestoreService(uid: _authService.currentUserFunc()!.uid);

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
            if (inp!.isEmpty) {
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

    return FutureBuilder<QuerySnapshot>(
      future: _firestoreService.doctorsInfo,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Widget> doctorTiles = [];
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          try {
            bool addWidget = false;
            for (final DocumentSnapshot doc in snapshot.data.docs) {
              addWidget = true;
              doctorTiles.add(Column(
                children: [
                  Text(
                    doc[docName].toString(),
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.05)),
                  ),
                  Text(
                    doc[docContact].toString(),
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(color: Colors.blue)),
                  ),
                  SizedBox(
                    height: width * 0.01,
                  )
                ],
              ));
            }
            if (addWidget) {
              doctorTiles.insertAll(0, [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Added Contacts",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: width * 0.06,
                    )),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
              ]);
            }
            setState(() {});
          } catch (_) {
            debugPrint("No doctor data");
          }
        } else {
          doctorTiles.add(Container(
              alignment: Alignment.topLeft,
              child: const Text("No doctors added")));
        }
        return SafeArea(
          child: Scaffold(
            body: Container(
              width: width,
              height: height,
              child: SingleChildScrollView(
                  child: Column(children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.15),
                  alignment: Alignment.center,
                  child: Text(
                    "Enter the whatsapp Contact of your family Doctor",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: width * 0.08,
                    )),
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      customFormField(
                          'Doctor Name', docNameController, height, width),
                      customFormField('Whatsapp Contact', docContactController,
                          height, width),
                      SizedBox(
                        height: height * 0.06,
                      ),
                      Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                            ),
                            onPressed: () {
                              setState(() {
                                _firestoreService.addDocInfo(
                                  name: docNameController.text,
                                  phone: docContactController.text,
                                );
                              });
                            },
                            child: Text(
                              "Save",
                              style: GoogleFonts.raleway(
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 23)),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.08,
                ),
                ...doctorTiles
              ])),
            ),
          ),
        );
      },
    );
  }
}
