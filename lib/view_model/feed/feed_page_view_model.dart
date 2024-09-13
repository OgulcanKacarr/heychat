import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:heychat/model/PostWithUser.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:heychat/services/firebase_storage_service.dart';

class FeedPageViewModel extends ChangeNotifier{
  final FirebaseFirestoreService _firebaseFirestoreService = FirebaseFirestoreService();
  late Future<List<PostWithUser>> _postsWithUsers;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get postWithUsers => _postsWithUsers;

  //Takipçilerin postlarını çek
  Future<List<PostWithUser>> getFeedPostsWithUserInfo(BuildContext context) async {
    _postsWithUsers = _firebaseFirestoreService.getFeedPostsWithUserInfo(context,_auth.currentUser!.uid);
    notifyListeners();
    return _postsWithUsers;
  }


  }