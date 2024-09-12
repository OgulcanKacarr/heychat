import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heychat/model/Posts.dart';

class Posts {
  String postId;
  String userId;
  String imageUrl;
  String caption;
  List<String> likes;
  List<String> comments;
  Timestamp createdAt;

  Posts({
    required this.postId,
    required this.userId,
    required this.imageUrl,
    required this.createdAt,
    this.caption = '',
    this.likes = const [],
    this.comments = const [],
  });

  factory Posts.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Posts(
      postId: data['postId'],
      userId: data['userId'],
      imageUrl: data['imageUrl'],
      caption: data['caption'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      comments: List<String>.from(data['comments'] ?? []),
      createdAt: data['createdAt'], // Firestore'dan timestamp olarak alıyoruz
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'userId': userId,
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
    };
  }
}