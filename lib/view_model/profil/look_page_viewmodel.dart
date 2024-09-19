import 'package:flutter/cupertino.dart';
import 'package:heychat/model/Comments.dart';
import 'package:heychat/model/Posts.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_firestore_service.dart';

class LookPageViewmodel extends ChangeNotifier {
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  bool _isFollowing = false;
  bool _isRequestSent = false;
  bool _isRequestReceived = false;
  bool _isUnFollow = false;

  bool get isFollowing => _isFollowing;

  bool get isRequestSent => _isRequestSent;

  bool get isRequestReceived => _isRequestReceived;

  bool get isUnFollow => _isUnFollow;


  //postları getir
  List<Posts> _getPost = [];
  get getPost => _getPost;

  //takipçileri getir
  late List<Users> _followers;
  get followers => _followers;

  //uorumları al
  List<Comments> comments = [];
  //postu beğenenleri al
  late List<Users> liked_post_users;


  Future<void> sendFollow(String currentUserId, String targetUserId) async {
    try {
      await _firestoreService.sendFollowRequest(currentUserId, targetUserId);
      //istek gönderildi
      _isRequestSent = true;
      notifyListeners();
    } catch (e) {
      print(e); // Consider showing an error message
    }
  }

  Future<void> acceptFollowRequest(
      String currentUserId, String targetUserId) async {
    try {
      await _firestoreService.acceptFollowRequest(currentUserId, targetUserId);
      // Durumları güncelle
      _isRequestReceived = false;
      _isFollowing = true;
      _isRequestSent = false;
      notifyListeners();
    } catch (e) {
      print(e); // Consider showing an error message
    }
  }

  Future<void> cancelFollowRequest(
      String currentUserId, String targetUserId) async {
    try {
      await _firestoreService.cancelFollowRequest(currentUserId, targetUserId);
      _isRequestSent = false;
      _isFollowing = false;
      notifyListeners();
    } catch (e) {
      print(e); // Consider showing an error message
    }
  }

  Future<void> unFollow(String currentUserId, String targetUserId) async {
    try {
      await _firestoreService.unFollowRequest(currentUserId, targetUserId);
      _isRequestSent = false;
      _isFollowing = false;
      _isUnFollow = false;
      notifyListeners();
    } catch (e) {
      print("Takipten çıkma işlemi sırasında hata oluştu: ${e.toString()}");
    }
  }

  Future<void> checkFollowReceive(
      String currentUserId, String targetUserId) async {
    try {
      bool isRequestReceived = await _firestoreService.checkFollowReceive(
          currentUserId, targetUserId);
      _isRequestSent = false;
      _isRequestReceived = isRequestReceived;
      notifyListeners();
    } catch (e) {
      print(e); // Consider showing an error message
    }
  }

  Future<void> checkFollowSend(
      String currentUserId, String targetUserId) async {
    try {
      bool isRequestSend =
          await _firestoreService.checkFollowSend(currentUserId, targetUserId);
      _isRequestSent = isRequestSend;
      notifyListeners();
    } catch (e) {
      print(e); // Consider showing an error message
    }
  }

  Future<void> checkFriends(
      String currentUserId, String targetUserId) async {
    try {
      bool isFollowing =
      await _firestoreService.checkFollowing(currentUserId, targetUserId);
      _isFollowing = isFollowing;
      notifyListeners();
    } catch (e) {
      print(e); // Consider showing an error message
    }
  }


  //postları getir
  Future<List<Posts>> getTargetPosts(String targetUserId) async {
    _getPost = await _firestoreService.getTargetPosts(targetUserId);
    notifyListeners();
    return _getPost;
  }

  //takipçileri getir
  Future<List<Users>> getFollowers(BuildContext context,String targetUserId) async {
    _followers = await _firestoreService.getFollowers(context, targetUserId);
    notifyListeners();
    return _followers;
  }


  //postu beğenen kullanıcıları getir
  Future<List<Users>> getLikedPostsUser(BuildContext context, String postId) async {
    liked_post_users = await _firestoreService.getLikedPostsUser(context,postId);
    notifyListeners();
    return liked_post_users;
  }



}
