import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlumniHomeProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _fullName = "Alumni";
  String _profilePicUrl = "";

  String get fullName => _fullName;
  String get profilePicUrl => _profilePicUrl;

  AlumniHomeProvider() {
    listenToAlumniDetails();
  }

  void listenToAlumniDetails() {
    User? user = _auth.currentUser;
    if (user != null) {
      // Using the 'alumni' collection instead of 'users'
      _firestore.collection("alumni").doc(user.uid).snapshots().listen(
            (alumniDoc) {
          if (alumniDoc.exists) {
            _fullName = "${alumniDoc['firstName']} ${alumniDoc['lastName']}";
            _profilePicUrl = alumniDoc['profilePicUrl'] ?? "";
            notifyListeners();
          }
        },
        onError: (error) {
          print("Error listening to alumni details: $error");
        },
      );
    }
  }
}
