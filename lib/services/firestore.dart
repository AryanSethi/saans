import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:saans/standards/global_strings.dart';

class FirestoreService {
  String uid;
  FirestoreService({this.uid});
  final FirebaseFirestore firebase = FirebaseFirestore.instance;

  void addUserData({String name, String phone}) {
    final DocumentReference userDocument = firebase.collection(users).doc(uid);
    debugPrint("[LOG] from firestore service=> Adding user data to firestore");
    try {
      userDocument.set({'name': name, 'phone': phone});
      debugPrint("[LOG] from firestoreservice=> Added user data to firestore");
    } catch (e) {
      debugPrint(
          "[LOG] from firestoreservice=> Error while adding data to firestore -> ${e.toString()}");
    }
  }
}
