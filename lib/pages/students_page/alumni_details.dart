import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/providers/chat_provider.dart';
import 'package:alumniconnectmca/models/chat_model.dart';

class AlumniDetailPage extends StatelessWidget {
  final Map<String, dynamic> alumni;
  const AlumniDetailPage({Key? key, required this.alumni}) : super(key: key);

  // Define theme colors for consistency
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color lightBlue = Color(0xFFBBDEFB);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom app bar with profile image
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                alumni['fullName'],
                style: const TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [darkBlue, primaryBlue],
                      ),
                    ),
                  ),
                  // Decorative pattern
                  Opacity(
                    opacity: 0.1,
                    child: Image.network(
                      'https://www.transparenttextures.com/patterns/cubes.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Profile picture overlay
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: Hero(
                      tag: 'alumni-${alumni['id']}',
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: white,
                        backgroundImage: (alumni['profilePicUrl']?.isNotEmpty ?? false)
                            ? NetworkImage(alumni['profilePicUrl'])
                            : null,
                        child: (alumni['profilePicUrl']?.isEmpty ?? true)
                            ? Text(
                          alumni['fullName'][0],
                          style: TextStyle(fontSize: 40, color: primaryBlue),
                        )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: primaryBlue,
            actions: [
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () async {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    // Create a new conversation
                    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                    
                    // Create conversation
                    final conversationId = await chatProvider.createConversation(
                      studentId: currentUser.uid,
                      studentName: 'You',
                      alumniId: alumni['rollNo'] ?? currentUser.uid,
                      alumniName: alumni['fullName'] ?? 'Alumni',
                    );

                    // Navigate to chat
                    Navigator.pushNamed(
                      context,
                      '/student/chat/detail',
                      arguments: {
                        'conversation': ChatConversation(
                          id: conversationId,
                          studentId: currentUser.uid,
                          studentName: 'You',
                          alumniId: alumni['rollNo'] ?? currentUser.uid,
                          alumniName: alumni['fullName'] ?? 'Alumni',
                          messages: [],
                          lastMessageTime: DateTime.now(),
                          lastMessage: '',
                          hasUnreadMessages: false,
                        ),
                        'currentUserId': currentUser.uid,
                        'currentUserName': 'You',
                        'currentUserType': 'student'
                      }
                    );
                  }
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About section
                if (alumni['about'] != null && alumni['about'].isNotEmpty)
                  _buildInfoCard(
                    title: "About",
                    icon: Icons.person,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        alumni['about'],
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),

                // Contact information
                _buildInfoCard(
                  title: "Contact Information",
                  icon: Icons.contact_mail,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _contactRow(Icons.email, alumni['email'] ?? "Not provided"),
                        if (alumni['phone'] != null)
                          _contactRow(Icons.phone, alumni['phone']),
                        if (alumni['linkedin'] != null)
                          _contactRow(Icons.link, alumni['linkedin'], isLink: true),
                      ],
                    ),
                  ),
                ),

                // Current Position
                if (alumni['currentPosition'] != null)
                  _buildInfoCard(
                    title: "Current Position",
                    icon: Icons.work,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alumni['currentPosition'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (alumni['company'] != null)
                            Text(
                              alumni['company'],
                              style: const TextStyle(fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                  ),

                // Skills Section
                if (alumni['skills'] != null && (alumni['skills'] as List).isNotEmpty)
                  _buildInfoCard(
                    title: "Skills",
                    icon: Icons.lightbulb,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (alumni['skills'] as List).map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: primaryBlue.withOpacity(0.5)),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(color: darkBlue),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                // Experience Section
                if (alumni['experience'] != null && (alumni['experience'] as List).isNotEmpty)
                  _buildInfoCard(
                    title: "Experience",
                    icon: Icons.work_history,
                    child: Column(
                      children: (alumni['experience'] as List)
                          .map((exp) => _experienceTile(exp))
                          .toList(),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Information card container
  Widget _buildInfoCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: lightBlue.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: primaryBlue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
              ],
            ),
          ),
          // Card content
          child,
        ],
      ),
    );
  }

  // Contact information row
  Widget _contactRow(IconData icon, String text, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryBlue),
          const SizedBox(width: 12),
          Expanded(
            child: isLink
                ? InkWell(
              onTap: () async {
                if (await canLaunch(text)) {
                  await launch(text);
                }
              },
              child: Text(
                text,
                style: TextStyle(
                  color: primaryBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
                : Text(text),
          ),
        ],
      ),
    );
  }

  // Experience Tile
  Widget _experienceTile(dynamic exp) {
    Map<String, dynamic> expMap;
    if (exp is Map<String, dynamic>) {
      expMap = exp;
    } else {
      expMap = exp.toMap();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.business, color: primaryBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expMap['role'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expMap['company'],
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  expMap['duration'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  expMap['description'],
                  style: const TextStyle(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}