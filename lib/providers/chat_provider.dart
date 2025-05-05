import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ChatConversation> _conversations = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<QuerySnapshot>? _conversationsSubscription;

  List<ChatConversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch conversations for a user (student or alumni)
  Future<void> fetchConversations(String userId, String userType) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Validate user type
      if (userType.toLowerCase() != 'student' && userType.toLowerCase() != 'alumni') {
        throw Exception('Invalid user type. Must be either "student" or "alumni"');
      }

      // Cancel any existing subscription
      await _conversationsSubscription?.cancel();

      // Set up real-time listener
      _conversationsSubscription = _firestore
          .collection('conversations')
          .where(userType.toLowerCase() == 'student' ? 'studentId' : 'alumniId', isEqualTo: userId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .listen((snapshot) {
        _conversations = snapshot.docs
            .map((doc) {
              final data = doc.data();
              final messages = (data['messages'] as List?)?.map((msg) => ChatMessage.fromMap(msg)).toList() ?? [];
              return ChatConversation(
                id: doc.id,
                studentId: data['studentId'] ?? '',
                studentName: data['studentName'] ?? '',
                alumniId: data['alumniId'] ?? '',
                alumniName: data['alumniName'] ?? '',
                messages: messages,
                lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
                lastMessage: data['lastMessage'] ?? '',
                hasUnreadMessages: data['hasUnreadMessages'] ?? false,
              );
            })
            .toList();
        _isLoading = false;
        notifyListeners();
      }, onError: (error) {
        _isLoading = false;
        _error = error.toString();
        notifyListeners();
      });

    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Listen to a specific conversation for real-time updates
  Stream<ChatConversation> listenToConversation(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            throw Exception('Conversation not found');
          }
          final data = doc.data()!;
          final messages = (data['messages'] as List?)?.map((msg) => ChatMessage.fromMap(msg)).toList() ?? [];
          return ChatConversation(
            id: doc.id,
            studentId: data['studentId'] ?? '',
            studentName: data['studentName'] ?? '',
            alumniId: data['alumniId'] ?? '',
            alumniName: data['alumniName'] ?? '',
            messages: messages,
            lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
            lastMessage: data['lastMessage'] ?? '',
            hasUnreadMessages: data['hasUnreadMessages'] ?? false,
          );
        });
  }

  // Send a message
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String senderType,
    required String content,
  }) async {
    try {
      // Validate sender type
      if (senderType.toLowerCase() != 'student' && senderType.toLowerCase() != 'alumni') {
        throw Exception('Invalid sender type. Must be either "student" or "alumni"');
      }

      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: senderId,
        senderName: senderName,
        senderType: senderType.toLowerCase(),
        content: content,
        timestamp: DateTime.now(),
      );

      // Get the current conversation document
      final conversationDoc = await _firestore.collection('conversations').doc(conversationId).get();
      
      // Initialize messages array if it doesn't exist
      List<Map<String, dynamic>> messages = [];
      if (conversationDoc.exists && conversationDoc.data()?['messages'] != null) {
        messages = List<Map<String, dynamic>>.from(conversationDoc.data()!['messages']);
      }

      // Add the new message
      messages.add(message.toMap());

      // Get the recipient's FCM token
      String? recipientId;
      if (senderType.toLowerCase() == 'student') {
        recipientId = conversationDoc.data()?['alumniId'] as String?;
      } else {
        recipientId = conversationDoc.data()?['studentId'] as String?;
      }
      
      if (recipientId != null) {
        final recipientDoc = await _firestore.collection('users').doc(recipientId).get();
        final recipientToken = recipientDoc.data()?['fcmToken'] as String?;
        
        if (recipientToken != null) {
          // Send notification
          await _sendNotification(
            token: recipientToken,
            title: senderName,
            body: content,
            conversationId: conversationId,
          );
        } else {
          debugPrint('Recipient FCM token not found for user: $recipientId');
        }
      } else {
        debugPrint('Recipient ID not found in conversation: $conversationId');
      }

      // Update the conversation document
      await _firestore.collection('conversations').doc(conversationId).set({
        'messages': messages,
        'lastMessage': content,
        'lastMessageTime': Timestamp.now(),
        'hasUnreadMessages': true,
        'studentId': conversationDoc.data()?['studentId'] ?? '',
        'studentName': conversationDoc.data()?['studentName'] ?? '',
        'alumniId': conversationDoc.data()?['alumniId'] ?? '',
        'alumniName': conversationDoc.data()?['alumniName'] ?? '',
      }, SetOptions(merge: true));

      // Update local state
      final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (conversationIndex != -1) {
        final updatedConversation = ChatConversation(
          id: _conversations[conversationIndex].id,
          studentId: _conversations[conversationIndex].studentId,
          studentName: _conversations[conversationIndex].studentName,
          alumniId: _conversations[conversationIndex].alumniId,
          alumniName: _conversations[conversationIndex].alumniName,
          messages: [..._conversations[conversationIndex].messages, message],
          lastMessageTime: DateTime.now(),
          lastMessage: content,
          hasUnreadMessages: true,
        );

        _conversations[conversationIndex] = updatedConversation;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Send notification using Firebase Cloud Messaging
  Future<void> _sendNotification({
    required String token,
    required String title,
    required String body,
    required String conversationId,
  }) async {
    try {
      debugPrint('Sending notification to token: $token');
      await _firestore.collection('notifications').add({
        'to': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'conversationId': conversationId,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'priority': 'high',
        'time_to_live': 3600,
      });
      debugPrint('Notification sent successfully');
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String conversationId) async {
    try {
      await _firestore.collection('conversations').doc(conversationId).update({
        'hasUnreadMessages': false,
      });

      final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (conversationIndex != -1) {
        _conversations[conversationIndex] = ChatConversation(
          id: _conversations[conversationIndex].id,
          studentId: _conversations[conversationIndex].studentId,
          studentName: _conversations[conversationIndex].studentName,
          alumniId: _conversations[conversationIndex].alumniId,
          alumniName: _conversations[conversationIndex].alumniName,
          messages: _conversations[conversationIndex].messages,
          lastMessageTime: _conversations[conversationIndex].lastMessageTime,
          lastMessage: _conversations[conversationIndex].lastMessage,
          hasUnreadMessages: false,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Create a new conversation
  Future<String> createConversation({
    required String studentId,
    required String studentName,
    required String alumniId,
    required String alumniName,
  }) async {
    try {
      final conversation = ChatConversation(
        id: '${studentId}_${alumniId}',
        studentId: studentId,
        studentName: studentName,
        alumniId: alumniId,
        alumniName: alumniName,
        messages: [],
        lastMessageTime: DateTime.now(),
        lastMessage: '',
        hasUnreadMessages: false,
      );

      await _firestore.collection('conversations').doc(conversation.id).set(conversation.toMap());
      _conversations.add(conversation);
      notifyListeners();
      return conversation.id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _conversationsSubscription?.cancel();
    super.dispose();
  }
} 