import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String fullName = "User";
  String email = "";
  String profilePicUrl = "";
  String about = "";
  List<String> education = [];
  List<String> skills = [];
  List<String> experience = [];

  bool isLoading = false;

  ProfileProvider() {
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection("users").doc(user.uid).get();

      if (userDoc.exists) {
        fullName = "${userDoc['firstName']} ${userDoc['lastName']}";
        email = userDoc['email'];
        profilePicUrl = userDoc['profilePicUrl'] ?? "";
        about = userDoc['about'] ?? "";
        education = List<String>.from(userDoc['education'] ?? []);
        skills = List<String>.from(userDoc['skills'] ?? []);
        experience = List<String>.from(userDoc['experience'] ?? []);
      }
    }
    notifyListeners();
  }

  Future<void> updateProfile(String field, dynamic value) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection("users").doc(user.uid).update({field: value});
      await fetchUserProfile();
    }
  }

  Future<void> pickAndUploadProfilePic() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      User? user = _auth.currentUser;
      if (user != null) {
        String filePath = "profile_pictures/${user.uid}.jpg";
        TaskSnapshot uploadTask =
        await _storage.ref(filePath).putFile(file);
        profilePicUrl = await uploadTask.ref.getDownloadURL();
        await updateProfile("profilePicUrl", profilePicUrl);
      }
    }
  }
}
