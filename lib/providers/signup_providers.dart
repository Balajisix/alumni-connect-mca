import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class SignupProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String?> signUp(UserModel user, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("🔍 Checking if roll number exists...");
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("users")
          .where("rollNo", isEqualTo: user.rollNo)
          .get();

      if (query.docs.isNotEmpty) {
        print("❌ Roll number already registered!");
        _isLoading = false;
        notifyListeners();
        return "Roll number already registered!";
      }

      print("🔐 Hashing password...");
      String hashedPassword = sha256.convert(utf8.encode(password)).toString();

      print("📝 Registering user with Firebase...");
      UserCredential? userCredential = await _authService.registerUser(user.email, password);

      if (userCredential?.user == null) {
        print("❌ User registration failed!");
        _isLoading = false;
        notifyListeners();
        return "User registration failed!";
      }

      // ✅ Fetch UID safely
      String uid = userCredential!.user!.uid;
      print("✅ User registered with UID: $uid");

      print("📦 Saving user to Firestore...");
      UserModel newUser = UserModel(
        uid: uid,  // ✅ Store UID in Firestore
        firstName: user.firstName,
        lastName: user.lastName,
        rollNo: user.rollNo,
        email: user.email,
        phone: user.phone,
        linkedIn: user.linkedIn,
        userType: user.userType,
        password: hashedPassword, // ✅ Store hashed password
      );

      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap());
      print("✅ User saved successfully in Firestore!");

      _isLoading = false;
      notifyListeners();
      return null; // ✅ Success
    } catch (e) {
      print("❌ Signup Error: $e");
      _isLoading = false;
      notifyListeners();
      return "Error: ${e.toString()}";
    }
  }
}
