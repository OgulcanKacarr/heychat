
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:heychat/services/firebase_storage_service.dart';

class PostPageViewModel extends ChangeNotifier{
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final FirebaseStorageService _firebaseStorageService = FirebaseStorageService();
  ConstMethods _constMethods = ConstMethods();
  //seçilen fotoğraf
  File? _selectedImage;
  get getSelectedImage => _selectedImage;

  Future<void> selectPhoto(BuildContext context, String description) async {
    _selectedImage = await _constMethods.selectImage(context);
    notifyListeners();
  }
  Future<void> sharePost(BuildContext context, String description) async {
    await _firestoreService.addPost(context, _selectedImage!, description);
    ShowSnackBar.show(context, AppStrings.sharePostSuccesful);
    Navigator.pushReplacementNamed(context, "/home_page");
    notifyListeners();
  }



}