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
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("users")
          .where("rollNo", isEqualTo: user.rollNo)
          .get();

      if (query.docs.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return "Roll number already registered!";
      }

      // ✅ Hash the password before storing it
      String hashedPassword = sha256.convert(utf8.encode(password)).toString();

      UserCredential? userCredential = await _authService.registerUser(user.email, password);
      if (userCredential != null) {
        String uid = userCredential.user!.uid;

        // ✅ Create a new user with hashed password
        UserModel newUser = UserModel(
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

        _isLoading = false;
        notifyListeners();
        return null; // Success
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Error: ${e.toString()}";
    }

    return "Unknown error occurred!";
  }
}
