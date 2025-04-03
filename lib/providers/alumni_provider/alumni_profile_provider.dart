import 'dart:io';
import 'package:alumniconnectmca/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Helper class for dynamic Experience fields.
class ExperienceFieldData {
  final TextEditingController companyController;
  final TextEditingController roleController;
  final TextEditingController durationController;
  final TextEditingController descriptionController;

  ExperienceFieldData({
    String? company,
    String? role,
    String? duration,
    String? description,
  })  : companyController = TextEditingController(text: company),
        roleController = TextEditingController(text: role),
        durationController = TextEditingController(text: duration),
        descriptionController = TextEditingController(text: description);

  void dispose() {
    companyController.dispose();
    roleController.dispose();
    durationController.dispose();
    descriptionController.dispose();
  }
}

/// Helper class for dynamic Project fields.
class ProjectFieldData {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController technologiesController;
  final TextEditingController linkController;

  ProjectFieldData({
    String? title,
    String? description,
    String? technologies,
    String? link,
  })  : titleController = TextEditingController(text: title),
        descriptionController = TextEditingController(text: description),
        technologiesController = TextEditingController(text: technologies),
        linkController = TextEditingController(text: link);

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    technologiesController.dispose();
    linkController.dispose();
  }
}

/// Provider that manages the profile state.
class ProfileProviderAlumni extends ChangeNotifier {
  bool isEditing = false;
  bool isLoading = true;

  // Basic Information Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController profilePicController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  // Education Controllers (single entry for simplicity)
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController fieldOfStudyController = TextEditingController();
  final TextEditingController startYearController = TextEditingController();
  final TextEditingController endYearController = TextEditingController();

  // Skills & Achievements (comma separated)
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController achievementsController = TextEditingController();

  // Dynamic lists for Experiences and Projects
  List<ExperienceFieldData> experienceFields = [];
  List<ProjectFieldData> projectFields = [];

  // For profile picture selection
  File? profileImage;
  final ImagePicker picker = ImagePicker();

  ProfileProviderAlumni() {
    _listenToProfileData();
  }

  /// Listen for real-time updates of profile data.
  void _listenToProfileData() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        debugPrint("No user is logged in. Clearing profile fields.");
        _setBlankFields();
        isLoading = false;
        notifyListeners();
        return;
      }

      // Listen to profile data changes for the logged in user in the "alumni-profile" collection.
      FirebaseFirestore.instance
          .collection('alumni-profile') // or 'users' if that's your intended collection
          .doc(user.uid)
          .snapshots()
          .listen((docSnapshot) {
        if (!docSnapshot.exists) {
          // Document doesn't exist yet, so set blank data
          _setBlankFields();
        } else {
          final data = docSnapshot.data()!;
          final profile = Profile.fromMap(data);
          _populateControllers(profile);
        }
        isLoading = false;
        notifyListeners();
      }, onError: (error) {
        debugPrint("Error listening to profile data: $error");
        isLoading = false;
        notifyListeners();
      });
    });
  }

  /// Sets all fields to blank if there's no profile document.
  void _setBlankFields() {
    fullNameController.text = "";
    profilePicController.text = "";
    aboutController.text = "";
    institutionController.text = "";
    degreeController.text = "";
    fieldOfStudyController.text = "";
    startYearController.text = "";
    endYearController.text = "";
    skillsController.text = "";
    achievementsController.text = "";
    experienceFields = [ExperienceFieldData()];
    projectFields = [ProjectFieldData()];
  }

  /// Populates controllers based on the provided Profile model.
  void _populateControllers(Profile profile) {
    fullNameController.text = profile.fullName;
    profilePicController.text = profile.profilePicUrl;
    aboutController.text = profile.about;

    if (profile.education.isNotEmpty) {
      final edu = profile.education.first;
      institutionController.text = edu.institution;
      degreeController.text = edu.degree;
      fieldOfStudyController.text = edu.fieldOfStudy;
      startYearController.text = edu.startYear;
      endYearController.text = edu.endYear;
    } else {
      institutionController.text = "";
      degreeController.text = "";
      fieldOfStudyController.text = "";
      startYearController.text = "";
      endYearController.text = "";
    }

    skillsController.text = profile.skills.join(', ');
    achievementsController.text = profile.achievements.join(', ');

    // Populate experiences.
    if (profile.experience.isNotEmpty) {
      experienceFields = profile.experience.map((exp) {
        return ExperienceFieldData(
          company: exp.company,
          role: exp.role,
          duration: exp.duration,
          description: exp.description,
        );
      }).toList();
    } else {
      experienceFields = [ExperienceFieldData()];
    }

    // Populate projects.
    if (profile.projects.isNotEmpty) {
      projectFields = profile.projects.map((proj) {
        return ProjectFieldData(
          title: proj.title,
          description: proj.description,
          technologies: proj.technologies.join(', '),
          link: proj.link,
        );
      }).toList();
    } else {
      projectFields = [ProjectFieldData()];
    }
  }

  /// Pick a new profile picture from the gallery.
  Future<void> pickProfileImage(BuildContext context) async {
    // Pick and compress image: imageQuality reduces file size (0-100, lower means more compression).
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Adjust this value if needed.
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final int fileSize = await file.length();
      // 1.5MB = 1572864 bytes.
      if (fileSize > 1572864) {
        // Show error message if image is too large.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image size must be less than 1.5MB.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // If the image is valid, set profileImage and update UI.
      profileImage = file;
      notifyListeners();
    }
  }

  /// Uploads the profile picture to Firebase Storage and returns its download URL.
  Future<String> uploadProfilePicture(File file) async {
    final user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('${user!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  /// Save the profile data to Firestore ("alumni-profile" collection).
  Future<void> saveProfile() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload new profile picture if available.
        if (profileImage != null) {
          String downloadUrl = await uploadProfilePicture(profileImage!);
          profilePicController.text = downloadUrl;
        }

        // Gather dynamic experiences.
        List<Experience> experiences = experienceFields.map((field) {
          return Experience(
            company: field.companyController.text,
            role: field.roleController.text,
            duration: field.durationController.text,
            description: field.descriptionController.text,
          );
        }).toList();

        // Gather dynamic projects.
        List<Project> projects = projectFields.map((field) {
          return Project(
            title: field.titleController.text,
            description: field.descriptionController.text,
            technologies: field.technologiesController.text
                .split(',')
                .map((s) => s.trim())
                .toList(),
            link: field.linkController.text,
          );
        }).toList();

        final profile = Profile(
          fullName: fullNameController.text,
          profilePicUrl: profilePicController.text,
          about: aboutController.text,
          education: [
            Education(
              institution: institutionController.text,
              degree: degreeController.text,
              fieldOfStudy: fieldOfStudyController.text,
              startYear: startYearController.text,
              endYear: endYearController.text,
            )
          ],
          skills: skillsController.text
              .split(',')
              .map((s) => s.trim())
              .toList(),
          experience: experiences,
          projects: projects,
          achievements: achievementsController.text
              .split(',')
              .map((s) => s.trim())
              .toList(),
        );

        // Use the user's UID for the doc
        await FirebaseFirestore.instance
            .collection('alumni-profile')
            .doc(user.uid)
            .set(profile.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("Error saving profile: $e");
    } finally {
      isEditing = false;
      isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle edit mode.
  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  /// Add a new empty Experience field.
  void addExperience() {
    experienceFields.add(ExperienceFieldData());
    notifyListeners();
  }

  /// Remove an Experience field by index (if more than one exists).
  void removeExperience(int index) {
    if (experienceFields.length > 1) {
      experienceFields[index].dispose();
      experienceFields.removeAt(index);
      notifyListeners();
    }
  }

  /// Add a new empty Project field.
  void addProject() {
    projectFields.add(ProjectFieldData());
    notifyListeners();
  }

  /// Remove a Project field by index (if more than one exists).
  void removeProject(int index) {
    if (projectFields.length > 1) {
      projectFields[index].dispose();
      projectFields.removeAt(index);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    profilePicController.dispose();
    aboutController.dispose();
    institutionController.dispose();
    degreeController.dispose();
    fieldOfStudyController.dispose();
    startYearController.dispose();
    endYearController.dispose();
    skillsController.dispose();
    achievementsController.dispose();
    for (var exp in experienceFields) {
      exp.dispose();
    }
    for (var proj in projectFields) {
      proj.dispose();
    }
    super.dispose();
  }
}