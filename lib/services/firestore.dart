import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:saans/standards/global_strings.dart';

class FirestoreService {
  String? uid;
  FirestoreService({this.uid});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addLoggerInfo({
    required String name,
    required String phone,
  }) {
    final DocumentReference userDocument =
        _firestore.collection(appDownloads).doc(uid);
    debugPrint(
        "[LOG] from firestore service=> Adding appLevelInfo to firestore.");
    try {
      userDocument.set({loggerName: name, loggerContact: phone});
      debugPrint("[LOG] from firestoreservice=> Added  data to firestore");
    } catch (e) {
      debugPrint(
          "[LOG] from firestoreservice=> Error while adding data to firestore -> ${e.toString()}");
    }
  }

  void addDocInfo({
    required String name,
    required String phone,
  }) {
    final DocumentReference userDocument = _firestore
        .collection(appDownloads)
        .doc(uid)
        .collection(doctors)
        .doc("${name}_$phone");
    debugPrint(
        "[LOG] from firestore service=> Adding appLevelInfo to firestore.");
    try {
      userDocument.set({docName: name, docContact: phone});
      debugPrint("[LOG] from firestoreservice=> Added  data to firestore");
    } catch (e) {
      debugPrint(
          "[LOG] from firestoreservice=> Error while adding data to firestore -> ${e.toString()}");
    }
  }

  Future<QuerySnapshot> get doctorsInfo {
    return _firestore
        .collection(appDownloads)
        .doc(uid)
        .collection(doctors)
        .get();
  }

  // void addUserProfile({String? name, String? phone, String? infoAbout}) {
  //   final DocumentReference userDocument = firebase.collection(appDownloads).doc(uid);
  //   debugPrint("[LOG] from firestore service=> Adding appLevelInfo to firestore");
  //   try {
  //     userDocument.set({infoAbout: name, 'phone': phone});
  //     debugPrint("[LOG] from firestoreservice=> Added user data to firestore");
  //   } catch (e) {
  //     debugPrint(
  //         "[LOG] from firestoreservice=> Error while adding data to firestore -> ${e.toString()}");
  //   }
  // }
}
