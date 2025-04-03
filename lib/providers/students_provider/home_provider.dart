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
    // Check if a user is already signed in.
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _subscribeToUserDetails(currentUser);
    }
    // Listen for auth state changes.
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToUserDetails(user);
      } else {
        _fullName = "User";
        _profilePicUrl = "";
        notifyListeners();
      }
    });
  }

  // Subscribe to Firestore user document for updates.
  void _subscribeToUserDetails(User user) {
    _firestore.collection("users").doc(user.uid).snapshots().listen(
          (userDoc) {
        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data()!;
          // Debug prints to check what data is received.
          print("User Data: $data");
          _fullName = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
          _profilePicUrl = data['profilePicUrl'] ?? "";
          notifyListeners();
        }
      },
      onError: (error) {
        print("Error listening to user details: $error");
      },
    );
  }
}
