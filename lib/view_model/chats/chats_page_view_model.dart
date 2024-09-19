import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/Chats.dart';
import 'package:heychat/services/firebase_firestore_service.dart';


class ChatsPageViewModel extends ChangeNotifier {
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConstMethods _constMethods = ConstMethods();


  // Arkadaş listesi
  late List<String> _myFriendsList;
  List<String> get friendsList => _myFriendsList;

  // Sohbet edilen kişileri getir
  late Stream<List<Chats>> _chatsStream;
  Stream<List<Chats>> get chatsStream => _chatsStream;

  // Okunmamış mesajları takip etme
  int _unreadMessageCount = 0;
  int get unreadMessageCount => _unreadMessageCount;

  ChatsPageViewModel() {
    _chatsStream = _firestoreService.getChatsStream(_auth.currentUser!.uid);
    _chatsStream.listen((chats) {
      _unreadMessageCount = chats.where((chat) => !chat.isRead).length;
      notifyListeners();
    });
  }



  // Arkadaş listesini getir
  Future<void> getMyFriends(BuildContext context) async {
    _myFriendsList = await _firestoreService.getMyFriends(_auth.currentUser!.uid);
    await _constMethods.showFollowersDialog(context, _auth.currentUser!.uid);
    notifyListeners();
  }

  Future<void> deleteChat({
    required String chatId,
  }) async {
    await _firestoreService.deleteChat(chatId: chatId);
    notifyListeners();
  }

  Future<void> refreshChats() async {
    // Force refresh chat stream
    _chatsStream = _firestoreService.getChatsStream(_auth.currentUser!.uid);
    notifyListeners();
  }

  Future<void> markMessagesAsRead(String messageId) async {
    await _firestoreService.markMessageAsRead(messageId);
    notifyListeners();
  }
}
