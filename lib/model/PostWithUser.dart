import 'package:heychat/model/Posts.dart';
import 'package:heychat/model/Users.dart';

class PostWithUser {
  final Posts post;
  final Users user;

  PostWithUser({required this.post, required this.user});
}