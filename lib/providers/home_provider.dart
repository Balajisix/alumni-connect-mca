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
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
        await _firestore.collection("users").doc(user.uid).get();

        if (userDoc.exists) {
          _fullName = "${userDoc['firstName']} ${userDoc['lastName']}";
          _profilePicUrl = userDoc['profilePicUrl'] ?? "";
          notifyListeners();
        }
      } catch (e) {
        print("Error fetching user details: $e");
      }
    }
  }
}
