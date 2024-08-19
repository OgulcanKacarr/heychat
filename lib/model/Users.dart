import 'Posts.dart';

class Users {
  String? user_uui;
  String name;
  String surname;
  String username;
  String email;
  String? bio;
  String? profile_photo;
  String? cover_photo;
  bool isOnline;
  List<String>? friends;
  List<Posts>? posts;
  List<String>? sent_friend_requests;
  List<String>? recived_friend_requests;
  DateTime created_time = DateTime.timestamp();

  Users({
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.isOnline,
  });



}
