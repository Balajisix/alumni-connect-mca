import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alumniconnectmca/models/profile_model.dart';

class StudentProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Profile> studentList = [];

  Future<void> fetchStudent() async {
    try {
      isLoading = true;
      notifyListeners();

      final studentQuerySnapshot = await FirebaseFirestore.instance
            .collection('profiles')
            .get();

      List<Profile> tempStudentList = [];

      for(var doc in studentQuerySnapshot.docs) {
        Profile profile = Profile.fromMap(doc.data());
        String uid = doc.data()['uid'] ?? doc.id;

        final userDocSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if(userDocSnapshot.exists) {
          Map<String, dynamic> userData = userDocSnapshot.data()!;

          profile = Profile(
            fullName: profile.fullName,
            profilePicUrl: profile.profilePicUrl,
            about: profile.about,
            education: profile.education,
            skills: profile.skills,
            experience: profile.experience,
            projects: profile.projects,
            achievements: profile.achievements,
            rollNo: userData['rollNo'] ?? '',
            email: userData['email'] ?? '',
            phone: userData['phone'] ?? '',
            linkedIn: userData['linkedIn'] ?? '',
          );
        }
        tempStudentList.add(profile);
      }
      studentList = tempStudentList;
    } catch(e) {
      debugPrint('Error fetching student: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}