import 'package:alumniconnectmca/pages/profile_page.dart';
import 'package:alumniconnectmca/widgets/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/providers/home_provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          "Alumni Connect",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: DrawerPage(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Hero(
                      tag: "profilePic",
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: homeProvider.profilePicUrl.isNotEmpty
                            ? NetworkImage(homeProvider.profilePicUrl)
                            : AssetImage("assets/default_avatar.png")
                        as ImageProvider,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, ${homeProvider.fullName}!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Stay connected with your alumni network",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Quick Access Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quickAccessButton(Icons.group, "Find Alumni"),
                _quickAccessButton(Icons.event, "Events"),
                _quickAccessButton(Icons.work, "Jobs"),
                _quickAccessButton(Icons.message, "Chat"),
              ],
            ),
            SizedBox(height: 20),

            // Upcoming Events
            _sectionTitle("Upcoming Events"),
            _eventCard("Alumni Meetup", "March 15, 2025", "Virtual Event"),
            _eventCard("Tech Webinar", "April 10, 2025", "Zoom"),
            SizedBox(height: 20),

            // Recent Posts
            _sectionTitle("Recent Posts"),
            _postCard("John Doe", "Excited to share my experience at Google!"),
            _postCard("Jane Smith", "Looking for startup co-founders!"),
            SizedBox(height: 20),

            // Job Board Preview
            _sectionTitle("Job Opportunities"),
            _jobCard("Software Engineer", "Google, Remote"),
            _jobCard("Product Manager", "Amazon, New York"),
          ],
        ),
      ),
    );
  }

  Widget _quickAccessButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueAccent,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _eventCard(String title, String date, String location) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.event, color: Colors.blueAccent),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$date • $location"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to event details
        },
      ),
    );
  }

  Widget _postCard(String author, String content) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person, color: Colors.white),
          backgroundColor: Colors.blueAccent,
        ),
        title: Text(author, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Icon(Icons.thumb_up_alt_outlined, size: 20),
        onTap: () {
          // Navigate to post details
        },
      ),
    );
  }

  Widget _jobCard(String jobTitle, String company) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.work, color: Colors.blueAccent),
        title: Text(jobTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(company),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to job details
        },
      ),
    );
  }
}
