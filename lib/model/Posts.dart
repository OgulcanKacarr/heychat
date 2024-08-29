import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  String? post_id;
  String? user_id;
  String content;
  String? image_url;
  DateTime created_time;
  int likes;
  List<String>? comments;

  Posts({
    this.post_id,
    this.user_id,
    required this.content,
    this.image_url,
    DateTime? created_time,
    this.likes = 0,
    this.comments,
  }) : created_time = created_time ?? DateTime.now(); // Varsayılan olarak mevcut tarih atanır

  // Firestore'dan verileri alan fabrika yöntemi
  factory Posts.fromFirestore(Map<String, dynamic> data) {
    return Posts(
      post_id: data['post_id'],
      user_id: data['user_id'],
      content: data['content'] ?? '',
      image_url: data['image_url'],
      created_time: (data['created_time'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
      comments: data['comments'] != null ? List<String>.from(data['comments']) : null,
    );
  }

  // Verileri Firestore'a kaydetmek için bir harita yapısına dönüştüren yöntem
  Map<String, dynamic> toFirestore() {
    return {
      if (post_id != null) 'post_id': post_id,
      if (user_id != null) 'user_id': user_id,
      'content': content,
      if (image_url != null) 'image_url': image_url,
      'created_time': Timestamp.fromDate(created_time),
      'likes': likes,
      if (comments != null) 'comments': comments,
    };
  }
}
