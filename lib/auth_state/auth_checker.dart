import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alumniconnectmca/pages/home_page.dart';
import 'package:alumniconnectmca/pages/login_page.dart';

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listens to auth state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ); // Show loader while checking
        }
        if (snapshot.hasData) {
          return HomePage(); // If user is logged in, go to HomePage
        }
        return LoginPage(); // Otherwise, go to LoginPage
      },
    );
  }
}
