import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:heychat/view_model/profil/look_page_viewmodel.dart';


class RequestsPageViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  late LookPageViewmodel _lookPageViewmodel;

  //istekleri listede topla
  List<Map<String, dynamic>> _requests = [];
  List<Map<String, dynamic>> get requests => _requests;

  // Gelen arkadaşlık isteklerini göster
  Future<void> getRequests() async {
    _requests = await _firestoreService.getFriendRequests(_auth.currentUser!.uid);
    notifyListeners();
  }

  // Arkadaşlık isteğini kabul et
  Future<void> acceptRequest(String targetUserId) async {
    try {
      _lookPageViewmodel = LookPageViewmodel();
      await _lookPageViewmodel.acceptFollowRequest(_auth.currentUser!.uid, targetUserId);
      await getRequests();
    } catch (e) {
      print(e);
    }
  }
  // Arkadaşlık isteğini iptal et
  Future<void> cancelRequest(String targetUserId) async {
    await _lookPageViewmodel.cancelFollowRequest(_auth.currentUser!.uid, targetUserId);
    await getRequests();
  }

}
