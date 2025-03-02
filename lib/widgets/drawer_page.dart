import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alumniconnectmca/pages/login_page.dart';
import 'package:alumniconnectmca/pages/profile_page.dart'; // Import Profile Page

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String fullName = "Loading..."; // Default name

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection("users").doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          fullName =
          "${userDoc['firstName']} ${userDoc['lastName']}"; // Combine first & last name
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Drawer(
      backgroundColor: Colors.grey[200], // Light Grey Theme
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[300], // Soft Grey Background
            ),
            accountName: Text(
              fullName,
              style: TextStyle(
                  fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            accountEmail: Text(
              user?.email ?? "guest@example.com",
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.account_circle, size: 50, color: Colors.grey),
            ),
          ),

          // Menu Items
          _buildDrawerItem(Icons.home, "Home", () {
            // Navigate to Home
          }),
          _buildDrawerItem(Icons.person, "Profile", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }),
          _buildDrawerItem(Icons.info, "About", () {
            // Navigate to About
          }),

          Divider(),

          Spacer(),

          // Logout Button at Bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                await _auth.signOut();

                // Navigate to Login Page and remove all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create drawer items
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
