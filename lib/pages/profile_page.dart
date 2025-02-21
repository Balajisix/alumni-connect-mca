import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String fullName;
  final String profilePicUrl;

  ProfilePage(this.fullName, this.profilePicUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "profilePic",
              child: CircleAvatar(
                radius: 80,
                backgroundImage: profilePicUrl.isNotEmpty
                    ? NetworkImage(profilePicUrl)
                    : AssetImage("assets/default_avatar.png") as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            Text(
              fullName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
