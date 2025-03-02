import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/providers/signup_providers.dart';
import 'package:alumniconnectmca/models/user_model.dart';
import 'package:alumniconnectmca/widgets/custom_textfield.dart';
import 'package:alumniconnectmca/widgets/password_field.dart';

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
  String _selectedUserType = "Student";

  /// 🔥 Updated this function to call `_signup(context)`
  void _signUp() {
    if (_formKey.currentState!.validate()) {
      _signup(context); // 🔥 Call actual signup function
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all the fields.")),
      );
    }
  }

  /// ✅ Correct Signup Logic
  void _signup(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    // Create user model
    UserModel newUser = UserModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      rollNo: _rollNoController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      linkedIn: _linkedInController.text,
      userType: _selectedUserType,
      password: _passwordController.text,
    );

    // Call signup provider
    String? error = await context.read<SignupProvider>().signUp(newUser, _passwordController.text);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Successful! Redirecting to login...")),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = context.watch<SignupProvider>().isLoading;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/register.gif', height: 100),
                SizedBox(height: 10),
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 20),

                // Glassmorphic Card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _firstNameController,
                          hintText: "First Name",
                          icon: Icons.person,
                          textCapitalization: TextCapitalization.sentences,
                          borderColor: Colors.blue,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _lastNameController,
                          hintText: "Last Name",
                          icon: Icons.person,
                          textCapitalization: TextCapitalization.sentences,
                          borderColor: Colors.blue,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _rollNoController,
                          hintText: "Roll No",
                          icon: Icons.numbers,
                          borderColor: Colors.blue,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _emailController,
                          hintText: "Email",
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          borderColor: Colors.blue,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: "Phone No",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          borderColor: Colors.blue,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _linkedInController,
                          hintText: "LinkedIn Profile",
                          icon: Icons.link,
                          borderColor: Colors.blue,
                        ),
                        SizedBox(height: 10),

                        // Password Fields
                        PasswordField(controller: _passwordController, hintText: "Password"),
                        SizedBox(height: 10),
                        PasswordField(controller: _confirmPasswordController, hintText: "Confirm Password"),
                        SizedBox(height: 10),

                        // User Type Dropdown
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade600),
                          ),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(border: InputBorder.none),
                            value: _selectedUserType,
                            dropdownColor: Colors.white,
                            style: TextStyle(color: Colors.blue.shade900, fontSize: 16),
                            items: ["Student", "Alumni"].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedUserType = value!),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Signup Button
                        ElevatedButton(
                          onPressed: isLoading ? null : _signUp, // Disable button when loading
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45),
                              side: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.blue)
                              : Text(
                            "Sign Up",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
