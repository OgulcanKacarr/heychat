import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService{

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  
  //Kullanıcının profil fotoğrafını depoya ekle
  Future<String> addProfilePhotoInStorage(File image, FirebaseAuth _auth) async {
    Reference _ref = _firebaseStorage.ref()
    .child(AppStrings.users)
    .child(_auth.currentUser!.uid)
    .child(AppStrings.profilePhotoInFirebase);
    UploadTask task = _ref.putFile(image);
    TaskSnapshot snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  //Kullanıcının kapak fotoğrafını depoya ekle
  Future<String> addCoverPhotoInStorage(File image, FirebaseAuth _auth) async {
    Reference _ref = _firebaseStorage.ref()
        .child(AppStrings.users)
        .child(_auth.currentUser!.uid)
        .child(AppStrings.coverPhotoInFirebase);
    UploadTask task = _ref.putFile(image);
    TaskSnapshot snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }


  //kullanıcıların profil fotoğrafını sil
  Future<String> deleteProfilePhotoInStorage(FirebaseAuth _auth) async {
    String status = "";
    try {

      // Firebase Storage referansını oluştur
      Reference _ref = FirebaseStorage.instance
          .ref()
          .child(AppStrings.users)
          .child(_auth.currentUser!.uid)
          .child(AppStrings.profilePhotoInFirebase);

      // Fotoğrafı sil
      await _ref.delete();

      status = AppStrings.deleteProfilePhoto;
      return status;
    } catch (e) {
      status = "Hata: ${e.toString()}";
      return status;
      // Burada hata mesajını kullanıcıya göstermek için bir mekanizma ekleyebilirsiniz
    }
  }

  //kullanıcı kapak fotoğrafını sil
  Future<String> deleteCoverPhotoInStorage(FirebaseAuth _auth) async {
    String status = "";
    try {

      // Firebase Storage referansını oluştur
      Reference _ref = FirebaseStorage.instance
          .ref()
          .child(AppStrings.users)
          .child(_auth.currentUser!.uid)
          .child(AppStrings.coverPhotoInFirebase);

      // Fotoğrafı sil
      await _ref.delete();

      status = AppStrings.deleteCoverPhoto;
      return status;
    } catch (e) {
      status = "Hata: ${e.toString()}";
      return status;
      // Burada hata mesajını kullanıcıya göstermek için bir mekanizma ekleyebilirsiniz
    }
  }



  //Post ekle
  Future<String> addPostInStorage(File image, String userId) async {
    Uuid uuid = const Uuid();
    Reference _ref = _firebaseStorage.ref().child("${AppStrings.posts}/$userId/${uuid.v4()}.jpg");
    UploadTask task = _ref.putFile(image);
    TaskSnapshot snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }



}