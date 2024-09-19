import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  final String userId;
  final String displayName;
  final String text;
  final Timestamp createdAt;

  Comments({
    required this.userId,
    required this.displayName,
    required this.text,
    required this.createdAt,
  });

  factory Comments.fromFirestore(Map<String, dynamic> data) {
    return Comments(
      userId: data['userId'] as String,
      displayName: data['displayName'] as String,
      text: data['text'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'displayName': displayName,
      'text': text,
      'createdAt': createdAt,
    };
  }
}
