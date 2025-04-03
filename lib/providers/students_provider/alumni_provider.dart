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

      // Query the 'alumni-profile' collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('alumni-profile')
          .get();

      alumniList = querySnapshot.docs
          .map((doc) => Profile.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching alumni: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
