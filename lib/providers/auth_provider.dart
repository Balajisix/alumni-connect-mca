import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _error;

  User? get user => _user;
  String? get error => _error;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  CustomAuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 