import 'package:alumniconnectmca/pages/login_page.dart';
import 'package:alumniconnectmca/pages/alumni_page/alumni_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    // Use a FutureBuilder to fetch profile data directly
    return FutureBuilder<DocumentSnapshot>(
      future: user != null
          ? FirebaseFirestore.instance.collection('alumni-profile').doc(user.uid).get()
          : null,
      builder: (context, snapshot) {
        String fullName = "Guest";
        String profilePicUrl = "";
        // Optionally, you can show a loading indicator in the drawer header
        if (snapshot.connectionState == ConnectionState.waiting) {
          fullName = "Loading...";
        } else if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          fullName = data['fullName'] ?? "Guest";
          profilePicUrl = data['profilePicUrl'] ?? "";
        }
        return Drawer(
          backgroundColor: Colors.grey[200],
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                accountName: Text(
                  fullName,
                  style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                accountEmail: Text(
                  user?.email ?? "guest@example.com",
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: profilePicUrl.isNotEmpty
                      ? NetworkImage(profilePicUrl)
                      : const AssetImage("assets/default_avatar.png")
                  as ImageProvider,
                ),
              ),
              // Drawer Items
              _buildDrawerItem(Icons.home, "Home", () {
                // Navigate to Home.
              }),
              _buildDrawerItem(Icons.person, "Profile", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePageAlumni()),
                );
              }),
              _buildDrawerItem(Icons.info, "About", () {
                // Navigate to About.
              }),
              const Divider(),
              const Spacer(),
              // Logout Button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
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
      },
    );
  }

  // Helper method to build drawer items.
  Widget _buildDrawerItem(
      IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
