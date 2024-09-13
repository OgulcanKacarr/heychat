import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_auth_service.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:photo_view/photo_view.dart';

class SettingsPagePersonelViewmodel extends ChangeNotifier {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConstMethods _constMethods = ConstMethods();
  //kullanıcı bilgileri güncelleme listesi
  Map<String, dynamic> data = {};

  //profil fotoğrafı
  File? _profilePhoto;
  get profilePhoto => _profilePhoto;

  //Kapak fotoğrafı
  File? _coverPhoto;
  get coverPhoto => _coverPhoto;






  //Güncelleme işlemleri
  //profil fotoğrafını güncelle
  Future<File?> updateProfilePhoto(BuildContext context) async {
    _profilePhoto = await _constMethods.selectImage(context);
    _firestoreService.addProfilePhotoInFirebaseDatabase(context, _profilePhoto!);
    notifyListeners();
    return _profilePhoto;
  }
  //kapak fotoğrafını güncelle
  Future<File?> updateCoverPhoto(BuildContext context) async {
    _coverPhoto = await _constMethods.selectImage(context);
    _firestoreService.addCoverPhotoInFirebaseDatabase(context, _coverPhoto!);
    notifyListeners();
    return _coverPhoto;
  }

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

    nameAndSurname = nameAndSurname[0].toUpperCase() + nameAndSurname.substring(1);

    data = {
      "displayName": nameAndSurname,
    };
    _auth.currentUser!.updateDisplayName(nameAndSurname);
    await _firestoreService.updateUserInfo(
        context, nameAndSurname, data, AppStrings.emptyName);
    notifyListeners();
  }



  //username güncelleme
  Future<void> updateUsername(BuildContext context, String username) async {
    data = {
      "username": username,
    };
    await _firestoreService.updateUserInfo(
        context, username, data, AppStrings.emptyUsername);
    notifyListeners();
  }

  //email güncelleme
  Future<void> updateEmail(BuildContext context, String email) async {
    data = {
      "email": email,
    };
    await _firestoreService.updateUserInfo(
        context, email, data, AppStrings.emptyEmail);
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
      ShowSnackBar.show(context, AppStrings.passwordsDoNotMatch);
      return;
    }
    if (newPassword.isEmpty) {
      ShowSnackBar.show(context, AppStrings.newPassword);
      return;
    }
    if (reNewPassword.isEmpty) {
      ShowSnackBar.show(context, AppStrings.confirmNewPassword);
      return;
    }
    try {
      _auth.currentUser!.updatePassword(newPassword).then((onValue){
        ShowSnackBar.show(context, AppStrings.passwordUpdateSuccess);
      });

    } catch (e) {
      // Hata durumunu ele al
      ShowSnackBar.show(context, 'Şifre güncelleme hatası: ${e.toString()}');
    }
  }
}
