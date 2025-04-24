import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlumniHomeProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _fullName = "Alumni";
  String _profilePicUrl = "";
  String _company = "";
  String _role = "";

  String get fullName => _fullName;
  String get profilePicUrl => _profilePicUrl;
  String get company => _company;
  String get role => _role;

  AlumniHomeProvider() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _subscribeToProfileDetails(currentUser);
    }

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToProfileDetails(user);
      } else {
        _fullName = "Alumni";
        _profilePicUrl = "";
        _company = "";
        _role = "";
        notifyListeners();
      }
    });
  }

  void _subscribeToProfileDetails(User user) {
    _firestore.collection("users").doc(user.uid).snapshots().listen(
          (profileDoc) {
        if (profileDoc.exists && profileDoc.data() != null) {
          final data = profileDoc.data()!;
          // Use fullName if available, else fallback to firstName and lastName.
          _fullName = data['fullName'] ??
              "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
          _profilePicUrl = data['profilePicUrl'] ?? "";

          // Extract experience information if available.
          if (data['experience'] != null) {
            final experiences = List<Map<String, dynamic>>.from(data['experience']);
            if (experiences.isNotEmpty) {
              final firstExp = experiences.first;
              _company = firstExp['company'] ?? "";
              _role = firstExp['role'] ?? "";
            } else {
              _company = "";
              _role = "";
            }
          } else {
            _company = "";
            _role = "";
          }
          notifyListeners();
        }
      },
      onError: (error) {
        print("Error listening to profile details: $error");
      },
    );
  }
}
