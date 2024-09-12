import 'package:flutter/cupertino.dart';
import 'package:heychat/model/ButtonFollowViewModel.dart';
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

}
