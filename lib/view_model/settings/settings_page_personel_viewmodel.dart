import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_auth_service.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:photo_view/photo_view.dart';

class SettingsPagePersonelViewmodel extends ChangeNotifier {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //kullanıcı bilgileri güncelleme listesi
  Map<String, dynamic> data = {};






  //Güncelleme işlemleri
  //bio güncelleme
  Future<void> updateBio(BuildContext context, String bio) async {
    data = {
      "bio": bio,
    };
    await _firestoreService.updateUserInfo(
        context, bio, data, AppStrings.bio_is_not_empty);
    notifyListeners();
  }

  //Displayname güncelleme
  Future<void> updateNameAndSurname(
      BuildContext context, String nameAndSurname) async {
    data = {
      "displayName": nameAndSurname,
    };
    _auth.currentUser!.updateDisplayName(nameAndSurname);
    await _firestoreService.updateUserInfo(
        context, nameAndSurname, data, AppStrings.empty_name);
    notifyListeners();
  }

  //username güncelleme
  Future<void> updateUsername(BuildContext context, String username) async {
    data = {
      "username": username,
    };
    await _firestoreService.updateUserInfo(
        context, username, data, AppStrings.empty_username);
    notifyListeners();
  }

  //email güncelleme
  Future<void> updateEmail(BuildContext context, String email) async {
    data = {
      "email": email,
    };
    await _firestoreService.updateUserInfo(
        context, email, data, AppStrings.emtpy_email);
    notifyListeners();
  }

  //şifre güncelleme
  Future<void> updatePassword(
    BuildContext context,
    String newPassword,
    String reNewPassword,
  ) async {
    // Şifrelerin eşleşip eşleşmediğini kontrol et
    if (newPassword != reNewPassword) {
      ShowSnackBar.show(context, AppStrings.not_match_password);
      return;
    }
    if (newPassword.isEmpty) {
      ShowSnackBar.show(context, AppStrings.new_password);
      return;
    }
    if (reNewPassword.isEmpty) {
      ShowSnackBar.show(context, AppStrings.re_new_password);
      return;
    }
    try {
      _auth.currentUser!.updatePassword(newPassword).then((onValue){
        ShowSnackBar.show(context, AppStrings.update_password_succes);
      });

    } catch (e) {
      // Hata durumunu ele al
      ShowSnackBar.show(context, 'Şifre güncelleme hatası: ${e.toString()}');
    }
  }
}
