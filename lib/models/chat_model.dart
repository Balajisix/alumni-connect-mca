import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderType; // 'student' or 'alumni'
  final String content;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderType: map['senderType'] ?? '',
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderType': senderType,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}

class ChatConversation {
  final String id;
  final String studentId;
  final String studentName;
  final String alumniId;
  final String alumniName;
  final List<ChatMessage> messages;
  final DateTime lastMessageTime;
  final String lastMessage;
  final bool hasUnreadMessages;

  ChatConversation({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.alumniId,
    required this.alumniName,
    required this.messages,
    required this.lastMessageTime,
    required this.lastMessage,
    this.hasUnreadMessages = false,
  });

  factory ChatConversation.fromMap(Map<String, dynamic> map) {
    return ChatConversation(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      alumniId: map['alumniId'] ?? '',
      alumniName: map['alumniName'] ?? '',
      messages: (map['messages'] as List<dynamic>?)
          ?.map((msg) => ChatMessage.fromMap(msg))
          .toList() ?? [],
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'] ?? '',
      hasUnreadMessages: map['hasUnreadMessages'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'alumniId': alumniId,
      'alumniName': alumniName,
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessage': lastMessage,
      'hasUnreadMessages': hasUnreadMessages,
    };
  }
} 