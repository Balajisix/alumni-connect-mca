import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _fullName = "User";
  String _profilePicUrl = "";

  String get fullName => _fullName;
  String get profilePicUrl => _profilePicUrl;

  HomeProvider() {
    listenToUserDetails();
  }

  void listenToUserDetails() {
    User? user = _auth.currentUser;
    if (user != null) {
      _firestore.collection("users").doc(user.uid).snapshots().listen((userDoc) {
        if (userDoc.exists) {
          _fullName = "${userDoc['firstName']} ${userDoc['lastName']}";
          _profilePicUrl = userDoc['profilePicUrl'] ?? "";
          notifyListeners();
        }
      }, onError: (error) {
        print("Error listening to user details: $error");
      });
    }
  }
}
