import 'package:alumniconnectmca/widgets/alumni_drawer.dart';
import 'package:alumniconnectmca/pages/alumni_page/student_page.dart';
import 'package:alumniconnectmca/pages/alumni_page/event_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/providers/alumni_provider/alumni_home_provider.dart';
import 'package:alumniconnectmca/providers/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlumniHomePage extends StatelessWidget {  // Changed class name
  AlumniHomePage({super.key});

  // Define theme colors
  final Color primaryBlue = Color(0xFF1E88E5);
  final Color lightBlue = Color(0xFF64B5F6);
  final Color darkBlue = Color(0xFF0D47A1);
  final Color pureWhite = Colors.white;
  final Color offWhite = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<AlumniHomeProvider>();

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
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "Welcome, ${homeProvider.fullName}!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: pureWhite,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            "${homeProvider.company ?? 'Company'} • ${homeProvider.role ?? 'Position'}",
                            style: TextStyle(
                              color: pureWhite.withOpacity(0.85),
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),

            // Statistics Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(context, "12", "Connections"),
                      _divider(),
                      _statItem(context, "5", "Mentees"),
                      _divider(),
                      _statItem(context, "3", "Jobs Shared"),
                    ],
                  ),
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
                  _sectionTitle("Quick Actions"),
                  SizedBox(height: 10),
                  Container(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _quickAccessButton(
                            context,
                            Icons.school,
                            "Find Students",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StudentPage()),
                              );
                            }
                        ),
                        _quickAccessButton(
                            context,
                            Icons.event,
                            "Events",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AlumniEventListPage()),
                              );
                            }
                        ),
                        _quickAccessButton(context, Icons.work, "Post Job"),
                        _quickAccessButton(context, Icons.message, "Mentoring"),
                        _quickAccessButton(context, Icons.people, "Network"),
                        _quickAccessButton(context, Icons.chat, "Chat"),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Mentor Requests
                  _sectionTitle("Mentorship Requests"),
                  SizedBox(height: 10),
                  _mentorshipRequestCard("Rahul Sharma", "Looking for career guidance in AI/ML", "3rd Year MCA", context),
                  SizedBox(height: 8),
                  _mentorshipRequestCard("Priya Patel", "Seeking advice for internship opportunities", "2nd Year MCA", context),
                  SizedBox(height: 20),

                  // Upcoming Events
                  _sectionTitle("Upcoming Events"),
                  SizedBox(height: 10),
                  _eventCard("Alumni Reunion", "May 15, 2025", "Campus", context),
                  SizedBox(height: 8),
                  _eventCard("Career Fair", "April 20, 2025", "Virtual", context),
                  SizedBox(height: 20),

                  // Job Opportunities - Alumni can post
                  _sectionTitle("Your Job Postings"),
                  SizedBox(height: 10),
                  _jobPostingCard("Senior Developer", "Your Company • Remote", "12 applicants", context),
                  SizedBox(height: 8),
                  _jobPostingCard("Product Manager", "Your Company • Hybrid", "8 applicants", context),
                  SizedBox(height: 20),

                  // Recent News From Campus
                  _sectionTitle("Campus Updates"),
                  SizedBox(height: 10),
                  _newsCard("New Research Center", "The university launched a new AI research center with industry partnerships.", "2 days ago", context),
                  SizedBox(height: 8),
                  _newsCard("Student Achievement", "MCA students won the national hackathon for the second consecutive year.", "1 week ago", context),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        child: Icon(Icons.post_add, color: pureWhite),
        onPressed: () {
          // Add post or job listing
        },
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _statItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
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
                      .fetchConversations(currentUser.uid, 'alumni');
                  Navigator.pushNamed(context, '/alumni/chats');
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

  Widget _mentorshipRequestCard(String name, String request, String year, BuildContext context) {
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
                    name.substring(0, 1),
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
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        year,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              request,
              style: TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Decline",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Accept",
                    style: TextStyle(
                      color: pureWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobPostingCard(String jobTitle, String company, String applicants, BuildContext context) {
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Row(
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
              SizedBox(height: 3),
              Text(
                applicants,
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "View",
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

  Widget _newsCard(String title, String content, String timeAgo, BuildContext context) {
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
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school,
                    color: primaryBlue,
                    size: 20,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
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
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                "Read more",
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}