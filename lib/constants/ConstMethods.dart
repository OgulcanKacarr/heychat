import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_auth_service.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image/image.dart' as img;

class ConstMethods extends ChangeNotifier{
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();



  //kullanıcı bilgilerini çekme metodu
   Future<Users?> getUserInfo(BuildContext context, String user_id) async {
    Users? user_info = await _firebaseAuthService.getUsersFromFirebase(context,user_id);
    notifyListeners();
    return user_info;
  }


  // Fotoğrafları getirme metodu
  Widget showCachedImage(
      String imageUrl, {
        double? width,
        double? height,
      }) {
    if (imageUrl.isEmpty) {
      // Display a local asset image when the URL is empty
      return Image.asset(
        AppStrings.logo, // Ensure this is a valid local asset path
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else {
      // Use CachedNetworkImage for valid URLs
      return CachedNetworkImage(
        imageUrl: imageUrl.toString(),
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
      );
    }
  }


  //Kullanıcının Galerisinden Fotoğraf seç ve database'e ekle
  Future<void> selectAndUploadImage(
      BuildContext context, bool isCoverPhoto) async {
    try {
      // Galeriden fotoğraf seç
      var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      // galeriden alınan Fotoğrafı kırp
      var croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
        ],
      );

      if (croppedImage == null) return;

      // Fotoğrafı yeniden boyutlandır
      var resizedFile = await _resizeImage(context, croppedImage);
      if (resizedFile == null) return;

      // Fotoğrafı Firebase'e yükle
      //kapak fotoğrafı mı profil fotoğrafı mı olarak değer ver
      String download_url = "";
      if (isCoverPhoto) {
          download_url = await _firestoreService.addCoverPhotoInFirebaseDatabase(context, resizedFile);
      } else {
         download_url = await _firestoreService.addProfilePhotoInFirebaseDatabase(context, resizedFile);
      }
      notifyListeners();

    } catch (e) {
      print(e.toString());
      ShowSnackBar.show(context, e.toString());
    }
    notifyListeners();
  }

  // Fotoğrafı yeniden boyutlandır
  Future<File?> _resizeImage(BuildContext context, CroppedFile croppedImage) async {
    try {
      var imageFile = File(croppedImage.path);
      var decodedImage = img.decodeImage(await imageFile.readAsBytes());
      if (decodedImage == null) {
        ShowSnackBar.show(context, AppStrings.system_error);
        return null;
      }

      int targetWidth = AppSizes.screenWidth(context).toInt();
      int targetHeight = (AppSizes.screenHeight(context) * 0.4).toInt();
      var resizedImage = img.copyResize(decodedImage, width: targetWidth, height: targetHeight);

      final resizedFilePath = '${imageFile.path}_${_auth.currentUser?.uid}.png';
      File resizedFile = File(resizedFilePath);
      resizedFile.writeAsBytesSync(img.encodePng(resizedImage));

      return resizedFile;
    } catch (e) {
      ShowSnackBar.show(context, AppStrings.system_error);
      return null;
    }
  }


  //Profil fotoğrafı sil
  Future<void> removeProfilPhoto(BuildContext context) async {
    String status =  await _firestoreService.deleteProfilePhotoInFirebaseDatabase(context);
    ShowSnackBar.show(context, status);
     notifyListeners();
  }
  //kapak fotoğrafı sil
  Future<void> removeCoverPhoto(BuildContext context) async {
    String status =  await _firestoreService.deleteCoverPhotoInFirebaseDatabase(context);
    ShowSnackBar.show(context, status);
    notifyListeners();
  }


}