import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heychat/model/Messages.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SendMessagePageViewModel extends ChangeNotifier {
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<List<Messages>>? _messagesSubscription;

  Users? user;
  List<Messages> messages = [];
  late String currentUserId;

  SendMessagePageViewModel() {
    currentUserId = _auth.currentUser!.uid;
  }

  Future<void> fetchUserInfo(BuildContext context, String userId) async {
    user = await _firestoreService.getUsersInfoFromDatabase(context,userId);
    fetchMessages(userId);
    notifyListeners();
  }

  Future<void> fetchMessages(String userId) async {
    _messagesSubscription = _firestoreService.getMessages(currentUserId, userId).listen((newMessages) {
      messages = newMessages;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }

  Future<void> sendMessage(String content, String receiverId) async {
    await _firestoreService.sendMessage(
      senderId: currentUserId,
      receiverId: receiverId,
      content: content,
    );
    notifyListeners();
  }

  Future<void> markChatsAsUnread(String messageId) async {
      await _firestoreService.markChatsAsUnread(messageId);
    notifyListeners();
  }
  Future<void> markChatsAsRead(String messageId) async {
    await _firestoreService.markChatsAsRead(messageId);
    notifyListeners();
  }
  Future<void> markMessagesAsRead(String receiverId, String messageId) async {
    if(receiverId ==  _auth.currentUser!.uid){
      await _firestoreService.markMessageAsRead(messageId);
    }
    notifyListeners();
  }
}
