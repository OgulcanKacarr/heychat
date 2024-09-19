import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/Comments.dart';
import 'package:heychat/model/PostWithUser.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:heychat/services/firebase_storage_service.dart';

class FeedPageViewModel extends ChangeNotifier{
  final FirebaseFirestoreService _firebaseFirestoreService = FirebaseFirestoreService();
  late Future<List<PostWithUser>> _postsWithUsers;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //post bilgileri
  get postWithUsers => _postsWithUsers;

  //yorum yapma butonu durumu
  bool _open_comment_status = false;
  bool get open_comment_status => _open_comment_status;

  //uorumları al
  List<Comments> comments = [];
  //postu beğenenleri al
  late List<Users> liked_post_users;






  //yorum yapma butonunu aç/kapat
  void enterComment() {
    _open_comment_status = !_open_comment_status;
    notifyListeners();
  }




  //Takipçilerin postlarını çek
  Future<List<PostWithUser>> getFeedPostsWithUserInfo(BuildContext context) async {
    _postsWithUsers = _firebaseFirestoreService.getFeedPostsWithUserInfo(context,_auth.currentUser!.uid);
    return _postsWithUsers;
  }

  //post beğenme
  Future<void> likePost(String posId, List<String> likes) async {
    await _firebaseFirestoreService.likePost(posId, likes);
    notifyListeners();
  }

  //yorum yap
  Future<void> sendComment(String postId, String newComment) async {
    await _firebaseFirestoreService.sendComment(postId, newComment);
    getComments(postId);
  }

  //yorumları getir
  Future<List<Comments>> getComments(String postId) async {
    comments = await _firebaseFirestoreService.getComments(postId);
    notifyListeners();
    return comments;
  }

  //postu beğenen kullanıcıları getir
  Future<List<Users>> getLikedPostsUser(BuildContext context, String postId) async {
    liked_post_users = await _firebaseFirestoreService.getLikedPostsUser(context,postId);
    notifyListeners();
    return liked_post_users;
  }



  Future<void> deleteCommentDialog(BuildContext context, String postId, String commentId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextButton(
            onPressed: () async {
              await _firebaseFirestoreService.deleteComment(postId, commentId);
              notifyListeners(); // Yorum silindikten sonra ekranı güncelle
              Navigator.pop(context); // Dialogu kapat
            },
            child: const Text(AppStrings.deleteComment),
          ),
        );
      },
    );
  }





}