import 'package:flutter/cupertino.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPageViewmodel extends ChangeNotifier {
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();

  List<Users> usersList = [];
  DocumentSnapshot<Map<String, dynamic>>? lastDocument; // Son document'ı takip etmek için

  Future<void> searchUser(BuildContext context, String username) async {
    var result = await _firestoreService.searchUsersFromFirebase(context, username, lastDocument);

    if (result != null) {
      List<Users> newUsers = result['users'];
      lastDocument = result['lastDocument']; // Son document'ı güncelleyin

      if (newUsers.isNotEmpty) {
        usersList.addAll(newUsers); // Yeni kullanıcıları mevcut listeye ekleyin
        notifyListeners(); // Dinleyicilere güncellemeyi bildirin
      }
    }
  }

  void resetSearch() {
    usersList.clear();
    lastDocument = null;
    notifyListeners();
  }
}
