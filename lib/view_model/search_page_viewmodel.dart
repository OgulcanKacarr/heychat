import 'package:flutter/cupertino.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPageViewmodel extends ChangeNotifier {
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();

  List<Users> usersList = [];
  DocumentSnapshot<Map<String, dynamic>>? lastDocument; // Son document'ı takip etmek için
  bool hasMore = false; // Daha fazla veri olup olmadığını takip eder

  Future<void> searchUser(BuildContext context, String username) async {
    try {
      var result = await _firestoreService.searchUsersFromFirebase(context, username, lastDocument);

      if (result != null) {
        List<Users> newUsers = result['users'];
        lastDocument = result['lastDocument']; // Son document'ı güncelleyin

        // Kullanıcıları listeye eklemeden önce var olanları kontrol et
        Set<String?> existingUserIds = usersList.map((user) => user.uid).toSet();
        List<Users> filteredUsers = newUsers.where((user) => !existingUserIds.contains(user.uid)).toList();

        if (filteredUsers.isNotEmpty) {
          usersList.addAll(filteredUsers); // Yeni kullanıcıları mevcut listeye ekleyin
          notifyListeners(); // Dinleyicilere güncellemeyi bildirin
        }

        // Daha fazla veri olup olmadığını belirle
        hasMore = newUsers.length == 5;
      }
    } catch (e) {
      // Hata yönetimi: Kullanıcıya uygun bir mesaj gösterebilirsiniz
      print("Arama sırasında bir hata oluştu: $e");
    }
  }

  void resetSearch() {
    usersList.clear();
    lastDocument = null;
    hasMore = false; // Arama sıfırlandığında daha fazla veri olmadığını varsay
    notifyListeners();
  }
}
