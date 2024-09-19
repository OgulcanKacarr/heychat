import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heychat/model/Users.dart';

class Chats {
  final String chatId;
  final List<String> userIds;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final Users user;
  final bool isRead; // Yeni alan

  Chats({
    required this.chatId,
    required this.userIds,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.user,
    required this.isRead, // Yeni alan
  });

  factory Chats.fromMap(Map<String, dynamic> map, String chatId, Users user) {
    return Chats(
      chatId: chatId,
      userIds: List<String>.from(map['userIds'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTimestamp: (map['lastMessageTimestamp'] as Timestamp).toDate(),
      user: user,
      isRead: map['isRead'] ?? false, // Yeni alan
    );
  }
}