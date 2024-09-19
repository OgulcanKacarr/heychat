import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heychat/model/Comments.dart';

class Posts {
  String postId;
  String userId;
  String imageUrl;
  String caption;
  List<String> likes;
  List<Comments> comments;
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

    // `comments` alanını bir `List` olarak işleyin
    List<dynamic> commentsData = data['comments'] ?? [];
    List<Comments> commentsList = commentsData.map((comment) => Comments.fromFirestore(comment as Map<String, dynamic>)).toList();

    return Posts(
      postId: data['postId'],
      userId: data['userId'],
      imageUrl: data['imageUrl'],
      caption: data['caption'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      comments: commentsList,
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'userId': userId,
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
      'comments': comments.map((c) => c.toFirestore()).toList(),
      'createdAt': createdAt,
    };
  }

  void addLike(String userId) {
    if (!likes.contains(userId)) {
      likes.add(userId);
    }
  }

  void removeLike(String userId) {
    likes.remove(userId);
  }

  bool isLikedByUser(String userId) {
    return likes.contains(userId);
  }
}
