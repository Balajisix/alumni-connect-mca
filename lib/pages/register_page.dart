import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alumniconnectmca/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _linkedInController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _signup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        QuerySnapshot query = await FirebaseFirestore.instance
            .collection("users")
            .where("rollNo", isEqualTo: _rollNoController.text)
            .get();

        if (query.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Roll number already registered!")),
          );
          return;
        }

        String hashedPassword = sha256.convert(utf8.encode(_passwordController.text)).toString();

        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String uid = userCredential.user!.uid;

        UserModel newUser = UserModel(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          rollNo: _rollNoController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          linkedIn: _linkedInController.text,
          password: hashedPassword,
        );

        await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup Successful! Redirecting to login...")),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                Hero(
                  tag: 'logo',
                  child: Image.asset('assets/sign.gif', height: 110),
                ),
                SizedBox(height: 15),
                Text(
                  "Create Account",
                  style: GoogleFonts.poppins(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign up to get started",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 20),

                _buildTextField(_firstNameController, "First Name", Icons.person),
                _buildTextField(_lastNameController, "Last Name", Icons.person),
                _buildTextField(_rollNoController, "Roll No", Icons.confirmation_number),
                _buildTextField(_emailController, "Email", Icons.email, isEmail: true),
                _buildTextField(_phoneController, "Phone No", Icons.phone, isPhone: true),
                _buildTextField(_linkedInController, "LinkedIn Profile", Icons.link),
                _buildPasswordField(_passwordController, "Password", Icons.lock, true),
                _buildPasswordField(_confirmPasswordController, "Confirm Password", Icons.lock, false),

                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () => _signup(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.blue[900], fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Login",
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon,
      {bool isPassword = false, bool isEmail = false, bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isPhone
            ? TextInputType.phone
            : TextInputType.text,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText, IconData icon, bool isPasswordField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordField ? _obscurePassword : _obscureConfirmPassword,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: IconButton(
            icon: Icon(isPasswordField ? (_obscurePassword ? Icons.visibility_off : Icons.visibility) : (_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility), color: Colors.white70),
            onPressed: () {
              setState(() {
                if (isPasswordField) {
                  _obscurePassword = !_obscurePassword;
                } else {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                }
              });
            },
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
