import 'package:alumniconnectmca/pages/login_page.dart';
import 'package:alumniconnectmca/pages/students_page/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    // Color theme constants
    final primaryBlue = Colors.blue[800];
    final accentBlue = Colors.blue[600];
    final lightBlue = Colors.blue[100];

    return FutureBuilder<DocumentSnapshot>(
      future: user != null
          ? FirebaseFirestore.instance.collection('profiles').doc(user.uid).get()
          : null,
      builder: (context, snapshot) {
        String fullName = "Guest";
        String profilePicUrl = "";
        String role = "Student"; // Default role
        String department = "Department of Computer Applications"; // Default department

        if (snapshot.connectionState == ConnectionState.waiting) {
          fullName = "Loading...";
        } else if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          fullName = data['fullName'] ?? "Guest";
          profilePicUrl = data['profilePicUrl'] ?? "";
          role = data['role'] ?? "Student";
          department = data['department'] ?? "Department of Computer Applications";
        }

        return Drawer(
          elevation: 16.0,
          backgroundColor: Colors.white,
          child: Column(
            children: [
              // Enhanced drawer header with custom design
              Container(
                width: double.infinity,
                height: 230,
                child: Stack(
                  children: [
                    // Background with gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              primaryBlue!.withOpacity(0.9),
                              primaryBlue,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Profile info at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            // Profile picture with customized border
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: profilePicUrl.isNotEmpty
                                    ? NetworkImage(profilePicUrl)
                                    : const AssetImage("assets/default_avatar.png") as ImageProvider,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // User info with better layout
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    fullName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black54,
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.email ?? "guest@example.com",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[100],
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black54,
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              role == "Alumni" ? Icons.school : Icons.person,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              role,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Department banner
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            department,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Drawer Items with enhanced styling
              const SizedBox(height: 8),
              _buildDrawerItem(
                Icons.home_rounded,
                "Home",
                    () {
                  Navigator.pop(context);
                  // Navigate to Home
                },
                primaryBlue,
              ),
              _buildDrawerItem(
                Icons.person_rounded,
                "Profile",
                    () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                primaryBlue,
              ),
              _buildDrawerItem(
                Icons.post_add_rounded,
                "Add Post",
                    () {
                  Navigator.pop(context);
                  // Navigate to Add Post page
                  // TODO: Add navigation to post creation page
                },
                primaryBlue,
              ),
              _buildDrawerItem(
                Icons.notifications_rounded,
                "Notifications",
                    () {
                  Navigator.pop(context);
                  // Navigate to Notifications page
                },
                primaryBlue,
              ),
              _buildDrawerItem(
                Icons.info_rounded,
                "About",
                    () {
                  Navigator.pop(context);
                  // Navigate to About page
                },
                primaryBlue,
              ),

              Divider(color: lightBlue, thickness: 1),

              _buildDrawerItem(
                Icons.settings_rounded,
                "Settings",
                    () {
                  Navigator.pop(context);
                  // Navigate to Settings page
                },
                primaryBlue,
              ),

              const Spacer(),

              // Logout Button with enhanced styling
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Show confirmation dialog
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text("Cancel", style: TextStyle(color: accentBlue)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Enhanced helper method to build drawer items with animations and styling
  Widget _buildDrawerItem(
      IconData icon, String title, VoidCallback onTap, Color? primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: primaryColor, size: 26),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: primaryColor),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: Colors.blue[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        dense: true,
      ),
    );
  }
}