import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  final String userId;
  final String text;
  final Timestamp createdAt;

  Comments({
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  factory Comments.fromFirestore(Map<String, dynamic> data) {
    return Comments(
      userId: data['userId'] as String,
      text: data['text'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'text': text,
      'createdAt': createdAt,
    };
  }
}
