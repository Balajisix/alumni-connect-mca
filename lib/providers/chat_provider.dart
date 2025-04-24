import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ChatConversation> _conversations = [];
  bool _isLoading = false;
  String? _error;

  List<ChatConversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch conversations for a user (student or alumni)
  Future<void> fetchConversations(String userId, String userType) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('conversations')
          .where(userType == 'student' ? 'studentId' : 'alumniId', isEqualTo: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      _conversations = querySnapshot.docs
          .map((doc) => ChatConversation.fromMap({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
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
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: senderId,
        senderName: senderName,
        senderType: senderType,
        content: content,
        timestamp: DateTime.now(),
      );

      await _firestore.collection('conversations').doc(conversationId).update({
        'messages': FieldValue.arrayUnion([message.toMap()]),
        'lastMessage': content,
        'lastMessageTime': Timestamp.now(),
        'hasUnreadMessages': true,
      });

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
      _error = e.toString();
      notifyListeners();
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
      final docRef = await _firestore.collection('conversations').add({
        'studentId': studentId,
        'studentName': studentName,
        'alumniId': alumniId,
        'alumniName': alumniName,
        'messages': [],
        'lastMessageTime': Timestamp.now(),
        'lastMessage': '',
        'hasUnreadMessages': false,
      });

      return docRef.id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 