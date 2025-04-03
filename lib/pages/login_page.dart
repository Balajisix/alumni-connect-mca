import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alumniconnectmca/pages/register_page.dart';
import 'package:alumniconnectmca/services/google_auth_service.dart';
import 'package:alumniconnectmca/pages/forgot_password.dart';
import 'package:alumniconnectmca/auth_state/auth_checker.dart'; // Navigate to AuthChecker after login

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum UserType { Student, Alumni }

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  // Default to Student. User can change this.
  UserType _selectedUserType = UserType.Student;

  Future<void> _updateUserTypeAndNavigate(User user) async {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final selectedType = _selectedUserType == UserType.Alumni ? "Alumni" : "Student";

    // Check if the user's document exists.
    final docSnapshot = await userDocRef.get();
    if (docSnapshot.exists) {
      // Use the stored userType for validation.
      final data = docSnapshot.data() as Map<String, dynamic>;
      final storedType = data['userType'] ?? 'Student';

      // If the selected type doesn't match the stored type, show an error.
      if (storedType != selectedType) {
        Fluttertoast.showToast(
          msg: "Selected user type does not match your account type!",
        );
        return;
      }
    } else {
      // If document does not exist, create it with the selected type.
      await userDocRef.set({'userType': selectedType}, SetOptions(merge: true));
    }

    // Proceed to navigate to AuthChecker.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthChecker()),
    );
  }

  Future<void> _signInWithEmail() async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Fluttertoast.showToast(msg: "Login Successful");
      // Update userType in Firestore and navigate accordingly.
      await _updateUserTypeAndNavigate(credential.user!);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      UserCredential? credential = await _googleAuthService.signInWithGoogle();
      if (credential != null) {
        await _updateUserTypeAndNavigate(credential.user!);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Widget _buildUserTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I am a:",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
        Row(
          children: [
            Radio<UserType>(
              value: UserType.Student,
              groupValue: _selectedUserType,
              onChanged: (UserType? value) {
                if (value != null) {
                  setState(() {
                    _selectedUserType = value;
                  });
                }
              },
            ),
            Text(
              "Student",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            SizedBox(width: 20),
            Radio<UserType>(
              value: UserType.Alumni,
              groupValue: _selectedUserType,
              onChanged: (UserType? value) {
                if (value != null) {
                  setState(() {
                    _selectedUserType = value;
                  });
                }
              },
            ),
            Text(
              "Alumni",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Image.asset('assets/login.gif', height: 120),
                  SizedBox(height: 20),
                  Text(
                    "Welcome Back!",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Login to continue",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField(_emailController, "Email", Icons.email),
                        SizedBox(height: 15),
                        _buildTextField(_passwordController, "Password", Icons.lock, isPassword: true),
                        SizedBox(height: 10),
                        _buildUserTypeSelector(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _signInWithEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/google-logo.png', height: 24),
                        SizedBox(width: 10),
                        Text(
                          "Sign in with Google",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
