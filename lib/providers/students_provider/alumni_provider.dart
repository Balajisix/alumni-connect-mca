import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alumniconnectmca/models/profile_model.dart'; // Import your common profile model

class AlumniProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Profile> alumniList = [];

  Future<void> fetchAlumni() async {
    try {
      isLoading = true;
      notifyListeners();

      // Fetch all alumni profiles
      final alumniQuerySnapshot = await FirebaseFirestore.instance
          .collection('alumni-profile')
          .get();

      List<Profile> tempAlumniList = [];

      // Iterate over each alumni profile
      for (var doc in alumniQuerySnapshot.docs) {
        // Parse the basic profile data
        Profile profile = Profile.fromMap(doc.data());

        // Assume your alumni-profile document has a field 'uid' or you can use doc.id.
        String uid = doc.data()['uid'] ?? doc.id;

        // Fetch additional fields from the users collection using the uid
        final userDocSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (userDocSnapshot.exists) {
          Map<String, dynamic> userData = userDocSnapshot.data()!;

          // Create a new Profile object including the extra fields.
          // Adjust the constructor if you've made these fields optional or required.
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

        tempAlumniList.add(profile);
      }

      alumniList = tempAlumniList;
    } catch (e) {
      debugPrint('Error fetching alumni: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
