import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/chat_provider.dart';
import '../students_page/chat_detail_page.dart';
import 'package:alumniconnectmca/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlumniChatListPage extends StatefulWidget {
  const AlumniChatListPage({Key? key}) : super(key: key);

  @override
  State<AlumniChatListPage> createState() => _AlumniChatListPageState();
}

class _AlumniChatListPageState extends State<AlumniChatListPage> {
  final Color primaryBlue = Color(0xFF1E88E5);
  final Color lightBlue = Color(0xFF64B5F6);
  final Color darkBlue = Color(0xFF0D47A1);
  final Color pureWhite = Colors.white;
  final Color offWhite = Color(0xFFF8F9FA);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Fetch conversations when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        Provider.of<ChatProvider>(context, listen: false)
            .fetchConversations(currentUser.uid, 'alumni');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please sign in to view chats'),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryBlue.withOpacity(0.1),
              offWhite,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        'Chats',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: pureWhite,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          // TODO: Implement search functionality
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Chat List
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  if (chatProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (chatProvider.error != null) {
                    return Center(
                      child: Text(
                        'Error: ${chatProvider.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (chatProvider.conversations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: primaryBlue.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No conversations yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: darkBlue.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: chatProvider.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = chatProvider.conversations[index];
                      return _ChatListItem(
                        conversation: conversation,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/alumni/chat/detail',
                            arguments: {
                              'conversation': conversation,
                              'currentUserId': currentUser.uid,
                              'currentUserName': currentUser.displayName ?? 'Alumni',
                              'currentUserType': 'alumni',
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;

  const _ChatListItem({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Color(0xFF1E88E5);
    final Color lightBlue = Color(0xFF64B5F6);
    final Color darkBlue = Color(0xFF0D47A1);
    final Color pureWhite = Colors.white;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryBlue.withOpacity(0.1),
                pureWhite,
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: primaryBlue,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.studentName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.lastMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: darkBlue.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('MMM dd').format(conversation.lastMessageTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: darkBlue.withOpacity(0.5),
                    ),
                  ),
                  if (conversation.hasUnreadMessages) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 