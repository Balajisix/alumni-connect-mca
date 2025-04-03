import 'package:alumniconnectmca/providers/alumni_provider/alumni_profile_provider.dart';
import 'package:alumniconnectmca/widgets/alumni_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlumniHomePage extends StatelessWidget {
  const AlumniHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileAlumni = context.watch<ProfileProviderAlumni>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text(
          "Alumni Connect",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add notifications functionality here
            },
          ),
        ],
      ),
      drawer: DrawerPage(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner using profile data from ProfileProvider
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Optionally navigate to the profile page
                    },
                    child: Hero(
                      tag: "profilePic",
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: profileAlumni.profilePicController.text.isNotEmpty
                            ? NetworkImage(profileAlumni.profilePicController.text)
                            : const AssetImage("assets/default_avatar.png") as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, ${profileAlumni.fullNameController.text}!",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Stay connected with your alumni network",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Quick Access Buttons for Alumni Home Page
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "Find Alumni" routes to '/find-alumni'
                _quickAccessButton(Icons.group, "Find Students", onTap: () {
                  Navigator.pushNamed(context, '/find-alumni');
                }),
                _quickAccessButton(Icons.event, "Events Posting", onTap: () {
                  Navigator.pushNamed(context, '/events-posting');
                }),
                _quickAccessButton(Icons.work, "Job Posting", onTap: () {
                  Navigator.pushNamed(context, '/job-posting');
                }),
                _quickAccessButton(Icons.message, "Chat", onTap: () {
                  Navigator.pushNamed(context, '/chat');
                }),
              ],
            ),
            const SizedBox(height: 20),
            // Upcoming Event Postings Section
            _sectionTitle("Upcoming Event Postings"),
            _eventCard("Alumni Meetup", "March 15, 2025", "Virtual Event"),
            _eventCard("Tech Webinar", "April 10, 2025", "Zoom"),
            const SizedBox(height: 20),
            // Recent Posts (could be alumni updates)
            _sectionTitle("Recent Posts"),
            _postCard("John Doe", "Excited to share my journey post-2020!"),
            _postCard("Jane Smith", "Looking for collaboration opportunities."),
            const SizedBox(height: 20),
            // Job Postings Preview
            _sectionTitle("Job Postings"),
            _jobCard("Software Engineer", "Google, Remote"),
            _jobCard("Product Manager", "Amazon, New York"),
          ],
        ),
      ),
    );
  }

  /// Quick Access Button widget accepting an optional onTap callback.
  Widget _quickAccessButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _eventCard(String title, String date, String location) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$date • $location"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to event posting details
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
          child: const Icon(Icons.person, color: Colors.white),
          backgroundColor: Colors.blueAccent,
        ),
        title: Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.thumb_up_alt_outlined, size: 20),
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
        leading: const Icon(Icons.work, color: Colors.blueAccent),
        title: Text(jobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(company),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to job posting details
        },
      ),
    );
  }
}
