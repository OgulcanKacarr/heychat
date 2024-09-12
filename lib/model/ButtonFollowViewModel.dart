import 'package:flutter/cupertino.dart';
import 'package:heychat/services/firebase_firestore_service.dart';

class Buttonfollowviewmodel extends ChangeNotifier {

  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  bool _isFollowing = false;
  bool _isRequestSent = false;
  bool _isRequestReceived = false;
  bool _isUnFollow = false;

  bool get isFollowing => _isFollowing;

  bool get isRequestSent => _isRequestSent;

  bool get isRequestReceived => _isRequestReceived;

  bool get isUnFollow => _isUnFollow;


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
      print(e);
    }
  }

}
