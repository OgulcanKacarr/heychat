import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/FbErrorsMessages.dart';
import 'package:heychat/constants/ShowSnackBar.dart';

import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_storage_service.dart';

class FirebaseFirestoreService{
  final String _users_db = AppStrings.users;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Fberrorsmessages _fberrorsmessages = Fberrorsmessages();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorageService _firebaseStorageService = FirebaseStorageService();

  //Kullanıcı bilgilerini kullanıcnın collection yapısına ekle
  Future<void> addUserInfoInDatabase(BuildContext context,Users user) async {
    try{
      _firebaseFirestore.collection(_users_db)
          .doc(user.uid)
          .set(user.toFirestore()).then((onValue){

        ShowSnackBar.show(context, AppStrings.user_created_successfully);
        Navigator.pushReplacementNamed(context, "/home_page");

      });
    }on FirebaseAuthException catch (e) {
      String errorMessage = _fberrorsmessages.handleError(e.code);
      ShowSnackBar.show(context, errorMessage);
    } catch (e) {
      ShowSnackBar.show(context, AppStrings.error);
    }
  }

// Kullanıcı bilgilerini database'den çekme
  Future<Users?> getUsersInfoFromDatabase(BuildContext context, String user_id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(user_id)
          .get();
      if (snapshot.exists) {
        Users user = Users.fromFirestore(snapshot);
        // Kullanıcı verilerini kullanmak için burada userModel'i kullanabilirsiniz
        return user;
      } else {
        ShowSnackBar.show(context, AppStrings.user_not_found);
      }
    } catch (error) {
      print("Failed to get user info: $error");
      throw error; // Hatanın yukarıya doğru taşınmasını sağlamak
    }
    return null;
  }

  //kullanıcı profil fotoğrafını database ve storage ekleme
  Future<String> addProfilePhotoInFirebaseDatabase(BuildContext context, File image) async {
    if (image != null) {
      try {
        // Fotoğrafı Firebase Storage'a yükle ve indirme bağlantısını al
        String profilePhotoUrl = await _firebaseStorageService.addProfilePhotoInStorage(image, _auth);

        // Kullanıcı verilerini güncelle
        await _firebaseFirestore
            .collection(AppStrings.users)
            .doc(_auth.currentUser!.uid)
            .update({
          "profileImageUrl": profilePhotoUrl,
        });

        return profilePhotoUrl;
      } catch (e) {
        // Hata durumunda kullanıcıya bilgi ver
        ShowSnackBar.show(context, AppStrings.error);
        return "";
      }
    } else {
      return "";
    }
  }

  //Kullanıcı kapak fotoğrafını firebase'e ve storage'e ekle
  Future<String> addCoverPhotoInFirebaseDatabase(BuildContext context, File image) async {
    if (image != null) {
      try {
        // Fotoğrafı Firebase Storage'a yükle ve indirme bağlantısını al
        String coverImageUrl = await _firebaseStorageService.addCoverPhotoInStorage(image, _auth);

        // Kullanıcı verilerini güncelle
        await _firebaseFirestore
            .collection(AppStrings.users)
            .doc(_auth.currentUser!.uid)
            .update({
          "coverImageUrl": coverImageUrl,
        });

        return coverImageUrl;
      } catch (e) {
        // Hata durumunda kullanıcıya bilgi ver
        ShowSnackBar.show(context, AppStrings.error);
        return "";
      }
    } else {
      return "";
    }
  }


  //profil fotoğrafı silme metodu
  Future<String> deleteProfilePhotoInFirebaseDatabase(BuildContext context) async {
    try {
      // Kullanıcının UID'sini al
      String userId = _auth.currentUser!.uid;

      // Firebase Realtime Database'den profil fotoğrafı URL'sini al
      DocumentSnapshot userDoc = await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Profil fotoğrafı URL'sini al
        String profilePhotoUrl = userDoc.get("profileImageUrl");

        if (profilePhotoUrl.isNotEmpty) {
          // Firebase Storage'dan profil fotoğrafını sil
          String status = await _firebaseStorageService.deleteProfilePhotoInStorage(_auth);

          // Firebase Realtime Database'den profil fotoğrafı URL'sini temizle
          await _firebaseFirestore
              .collection(AppStrings.users)
              .doc(userId)
              .update({
            "profileImageUrl": FieldValue.delete(), // URL'yi sil
          });

          // Başarı mesajı (isteğe bağlı)
          return status;
        } else {
          return AppStrings.not_found_photo;        }
      } else {
        return AppStrings.not_found_photo;
      }
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      return AppStrings.not_found_photo;
    }
  }

//kapak fotoğrafı silme metodu
  Future<String> deleteCoverPhotoInFirebaseDatabase(BuildContext context) async {
    try {
      // Kullanıcının UID'sini al
      String userId = _auth.currentUser!.uid;

      // Firebase Realtime Database'den profil fotoğrafı URL'sini al
      DocumentSnapshot userDoc = await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Profil fotoğrafı URL'sini al
        String profilePhotoUrl = userDoc.get("coverImageUrl");

        if (profilePhotoUrl.isNotEmpty) {
          // Firebase Storage'dan profil fotoğrafını sil
          String status = await _firebaseStorageService.deleteCoverPhotoInStorage(_auth);

          // Firebase Realtime Database'den profil fotoğrafı URL'sini temizle
          await _firebaseFirestore
              .collection(AppStrings.users)
              .doc(userId)
              .update({
            "coverImageUrl": FieldValue.delete(), // URL'yi sil
          });

          // Başarı mesajı (isteğe bağlı)

          return status;

        } else {
          return AppStrings.not_found_photo;        }
      } else {
        return AppStrings.not_found_photo;
      }
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      return AppStrings.not_found_photo;
    }
  }


  //kullanıcıyı çevrimiçi yap
  Future<void> updateUserOnline(BuildContext context,User user, bool status) async {
    Map<String, bool> isOnline = {
      "isOnline": status,
    };
    _firebaseFirestore.collection(_users_db)
        .doc(user.uid)
        .update(isOnline);
  }

  // Kullanıcı adı daha önce kayıt olmuş mu?
  Future<bool> checkUsername(BuildContext context, String username) async {
    try {
      // Kullanıcılar koleksiyonunda username alanına göre sorgu yapın
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(AppStrings.users)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true; // Kullanıcı adı zaten kullanılıyor
      }
    } catch (e) {
      ShowSnackBar.show(context, AppStrings.error);
    }
    return false; // Kullanıcı adı kullanılabilir
  }


  //bilgileri güncelleme
  Future<void> updateUserInfo(BuildContext context, String process,
      Map<String, dynamic> data, String errorMessage) async {
    if (process.isEmpty) {
      ShowSnackBar.show(context, errorMessage);
    } else {
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(_auth.currentUser!.uid)
          .update(data)
          .whenComplete(() {
        ShowSnackBar.show(context, AppStrings.update_succes);
      });
    }
  }


  //kullanıcı arama metodu
  Future<Map<String, dynamic>?> searchUsersFromFirebase(
      BuildContext context, String username, DocumentSnapshot<Map<String, dynamic>>? lastDocument) async {
    try {
      Query<Map<String, dynamic>> query = _firebaseFirestore
          .collection(AppStrings.users)
          .where('username', isEqualTo: username)
          .limit(5);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument); // Son dokümandan sonrasını al
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        List<Users> users = snapshot.docs.map((doc) => Users.fromFirestore(doc)).toList();
        DocumentSnapshot<Map<String, dynamic>> lastVisible = snapshot.docs.last; // Son dokümanı alın

        return {
          'users': users,
          'lastDocument': lastVisible,
        };
      }
    } catch (e) {
      ShowSnackBar.show(context, "Hata: ${e.toString()}");
      return null;
    }
  }
}