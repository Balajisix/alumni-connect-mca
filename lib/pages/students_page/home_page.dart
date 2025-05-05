import 'package:alumniconnectmca/widgets/drawer_page.dart';
import 'package:alumniconnectmca/pages/students_page/alumni_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/providers/students_provider/home_provider.dart';
import 'package:alumniconnectmca/providers/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Define theme colors
  final Color primaryBlue = Color(0xFF1E88E5);
  final Color lightBlue = Color(0xFF64B5F6);
  final Color darkBlue = Color(0xFF0D47A1);
  final Color pureWhite = Colors.white;
  final Color offWhite = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        title: Text(
          "Alumni Connect",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: pureWhite,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: pureWhite),
            onPressed: () {},
          ),
        ],
      ),
      drawer: DrawerPage(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Curved top section with profile info
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Hero(
                        tag: "profilePic",
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: pureWhite, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: homeProvider.profilePicUrl.isNotEmpty
                                ? NetworkImage(homeProvider.profilePicUrl)
                                : AssetImage("assets/default_avatar.png") as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome, ${homeProvider.fullName}!",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: pureWhite,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Stay connected with your alumni network",
                            style: TextStyle(
                              color: pureWhite.withOpacity(0.85),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),

            // Quick Access Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Quick Access"),
                  SizedBox(height: 10),
                  Container(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _quickAccessButton(
                            context,
                            Icons.group,
                            "Find Alumni",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AlumniPage()),
                              );
                            }
                        ),
                        _quickAccessButton(
                            context,
                            Icons.event,
                            "Events",
                            onTap: () {
                              Navigator.pushNamed(context, '/student/events');
                            }
                        ),
                        _quickAccessButton(context, Icons.work, "Jobs"),
                        _quickAccessButton(context, Icons.message, "Chat"),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Upcoming Events
                  _sectionTitle("Upcoming Events"),
                  SizedBox(height: 10),
                  _eventCard("Alumni Meetup", "March 15, 2025", "Virtual Event", context),
                  SizedBox(height: 8),
                  _eventCard("Tech Webinar", "April 10, 2025", "Zoom", context),
                  SizedBox(height: 20),

                  // Recent Posts
                  _sectionTitle("Recent Posts"),
                  SizedBox(height: 10),
                  _postCard("John Doe", "Excited to share my experience at Google! Just completed my first month and wanted to share some insights with fellow alumni.", context),
                  SizedBox(height: 8),
                  _postCard("Jane Smith", "Looking for startup co-founders! If anyone is interested in joining a fintech venture, please reach out to me.", context),
                  SizedBox(height: 20),

                  // Job Board Preview
                  _sectionTitle("Job Opportunities"),
                  SizedBox(height: 10),
                  _jobCard("Software Engineer", "Google, Remote", context),
                  SizedBox(height: 8),
                  _jobCard("Product Manager", "Amazon, New York", context),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAccessButton(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: label == "Chat" 
            ? () {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  Provider.of<ChatProvider>(context, listen: false)
                      .fetchConversations(currentUser.uid, 'student');
                  Navigator.pushNamed(context, '/student/chats');
                }
              }
            : onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: pureWhite,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 32
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 24,
          decoration: BoxDecoration(
            color: darkBlue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _eventCard(String title, String date, String location, BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              pureWhite,
              Color(0xFFE3F2FD),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event, color: primaryBlue),
          ),
          title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "$date • $location",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          trailing: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.arrow_forward,
              color: pureWhite,
              size: 18,
            ),
          ),
          onTap: () {
            // Navigate to event details
          },
        ),
      ),
    );
  }

  Widget _postCard(String author, String content, BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryBlue,
                  child: Text(
                    author.substring(0, 1),
                    style: TextStyle(
                      color: pureWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "2 hours ago",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.black54),
              ],
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_alt_outlined,
                      color: primaryBlue,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "12",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: primaryBlue,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "5",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      color: primaryBlue,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Share",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobCard(String jobTitle, String company, BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              pureWhite,
              Color(0xFFE3F2FD),
            ],
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.work, color: primaryBlue),
          ),
          title: Text(
              jobTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: Colors.black54,
                ),
                SizedBox(width: 4),
                Text(
                  company,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Apply",
              style: TextStyle(
                color: pureWhite,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          onTap: () {
            // Navigate to job details
          },
        ),
      ),
    );
  }
}