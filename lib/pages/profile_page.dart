import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/providers/profile_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editProfileDialog(context, profileProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                profileProvider.pickAndUploadProfilePic();
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileProvider.profilePicUrl.isNotEmpty
                    ? NetworkImage(profileProvider.profilePicUrl)
                    : AssetImage("assets/default_avatar.png") as ImageProvider,
              ),
            ),
            SizedBox(height: 10),
            Text(
              profileProvider.fullName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              profileProvider.email,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            _sectionTitle("About"),
            _editableField(
              profileProvider.about.isEmpty ? "Add About" : profileProvider.about,
                  () => _editField(context, profileProvider, "about"),
            ),
            _sectionTitle("Education"),
            _editableField(
              profileProvider.education.isEmpty
                  ? "Add Education"
                  : profileProvider.education.join("\n"),
                  () => _editField(context, profileProvider, "education"),
            ),
            _sectionTitle("Skills"),
            _editableField(
              profileProvider.skills.isEmpty
                  ? "Add Skills"
                  : profileProvider.skills.join(", "),
                  () => _editField(context, profileProvider, "skills"),
            ),
            _sectionTitle("Experience"),
            _editableField(
              profileProvider.experience.isEmpty
                  ? "Add Experience"
                  : profileProvider.experience.join("\n"),
                  () => _editField(context, profileProvider, "experience"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _editableField(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  void _editProfileDialog(BuildContext context, ProfileProvider provider) {
    _editField(context, provider, "about");
  }

  void _editField(BuildContext context, ProfileProvider provider, String field) {
    TextEditingController controller = TextEditingController(
      text: field == "education" || field == "experience"
          ? provider.education.join("\n")
          : field == "skills"
          ? provider.skills.join(", ")
          : provider.about,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          controller: controller,
          maxLines: field == "education" || field == "experience" ? 3 : 1,
          decoration: InputDecoration(hintText: "Enter $field"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              provider.updateProfile(field, field == "skills"
                  ? controller.text.split(", ")
                  : controller.text.split("\n"));
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
