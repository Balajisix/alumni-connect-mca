import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alumniconnectmca/pages/students_page/home_page.dart';
import 'package:alumniconnectmca/pages/alumni_page/alumni_home.dart';
import 'package:alumniconnectmca/pages/login_page.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth changes
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authSnapshot.hasData) {
          // User is logged in; fetch their Firestore document once
          final user = authSnapshot.data!;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final data =
                userSnapshot.data!.data() as Map<String, dynamic>;
                final userType = data['userType'] ?? 'Student';
                // Debug log
                print('userType: $userType');

                // Navigate to AlumniHomePage if userType is Alumni
                if (userType == 'Alumni') {
                  return AlumniHomePage(); // Removed const keyword
                } else {
                  return HomePage();
                }
              }
              // If no user document, fallback to LoginPage
              return LoginPage();
            },
          );
        }
        return LoginPage();
      },
    );
  }
}
