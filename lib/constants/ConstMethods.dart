import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/SendNotificationService.dart';
import 'package:heychat/services/firebase_auth_service.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

class ConstMethods extends ChangeNotifier {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();


  // Kullanıcı bilgilerini çekme metodu
  Future<Users?> getUserInfo(BuildContext context, String user_id) async {
    Users? user_info =
        await _firebaseAuthService.getUsersFromFirebase(context, user_id);
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
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error)),
      );
    }
  }

  // Fotoğraf seçme ve yükleme metodu
  Future<File?> selectImage(BuildContext context) async {
    try {
      // Galeriden fotoğraf seç
      var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null;

      // Fotoğrafı kırp
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

      if (croppedImage == null) return null;

      // Fotoğrafı yeniden boyutlandır
      var resizedFile = await _resizeImage(context, croppedImage);
      if (resizedFile == null) return null;

      return resizedFile; // Fotoğrafı döndür
    } catch (e) {
      print(e.toString());
      ShowSnackBar.show(context, e.toString());
      return null; // Hata durumunda null döndür
    }
  }

  // Fotoğrafı yeniden boyutlandır
  Future<File?> _resizeImage(
      BuildContext context, CroppedFile croppedImage) async {
    try {
      var imageFile = File(croppedImage.path);
      var decodedImage = img.decodeImage(await imageFile.readAsBytes());
      if (decodedImage == null) {
        ShowSnackBar.show(context, AppStrings.system_error);
        return null;
      }

      int targetWidth = AppSizes.screenWidth(context).toInt();
      int targetHeight = (AppSizes.screenHeight(context) * 0.4).toInt();
      var resizedImage = img.copyResize(
        decodedImage,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.average,
      );

      final resizedFilePath = '${imageFile.path}_${_auth.currentUser?.uid}.png';
      File resizedFile = File(resizedFilePath);
      resizedFile.writeAsBytesSync(img.encodePng(resizedImage));

      return resizedFile;
    } catch (e) {
      ShowSnackBar.show(context, AppStrings.system_error);
      return null;
    }
  }

  // Profil fotoğrafı sil
  Future<void> removeProfilePhoto(BuildContext context) async {
    String status =
        await _firestoreService.deleteProfilePhotoInFirebaseDatabase(context);
    ShowSnackBar.show(context, status);
    notifyListeners();
  }

  // Kapak fotoğrafı sil
  Future<void> removeCoverPhoto(BuildContext context) async {
    String status =
        await _firestoreService.deleteCoverPhotoInFirebaseDatabase(context);
    ShowSnackBar.show(context, status);
    notifyListeners();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }


  Future<void> showFollowersModal(
      BuildContext context, String targetUserId) async {
    List<Users> followers = await _firestoreService.getFollowers(context, targetUserId);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              AppStrings.myFriends,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          followers.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(AppStrings.noMyFriends),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: followers.length,
                  itemBuilder: (context, index) {
                    Users users = followers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: users.profileImageUrl.isNotEmpty
                            ? NetworkImage(users.profileImageUrl)
                            : null,
                        child: users.profileImageUrl.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(users.displayName),
                      subtitle: Text(users.username),
                      onTap: (){
                        Navigator.pushReplacementNamed(context, "/look_page",arguments: users.uid!);
                      },
                    );
                  },
                )
        ]);
      },
    );
  }

  //postu beğenen kullanıcıları göster
  Future<void> showLikedUsersBottomSheet(BuildContext context, String targetUserId) async {
    List<Users> users = await _firestoreService.getFollowers(context, targetUserId);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Modalın içeriğe göre boyutlanmasını sağlar
              children: [
                const Text(
                  AppStrings.postLikedUsers,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Beğenen kullanıcıları liste halinde göstermek için ListView.builder kullanılır
                SizedBox(
                  height: 300, // Liste için sabit bir yükseklik tanımladım, isteğe göre değiştirilebilir.
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      Users user = users[index];
                      return Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: CircleAvatar(child: showCachedImage(user.profileImageUrl),),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, "/look_page",
                                  arguments: user.uid);
                            },
                            child: Text(user.username),
                          ),
                          // Takip et butonu sadece kullanıcı kendisi değilse gösterilecek
                          if (user.uid != _auth.currentUser!.uid) ...[
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, "/look_page",arguments: user.uid!);
                              },
                              child: const Text(AppStrings.go),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(AppStrings.ok),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //chat için takipçi listesini getir
  Future<void> showFollowersDialog(
      BuildContext context, String targetUserId) async {
    List<Users> allFollowers = await _firestoreService.getFollowers(context, targetUserId);

    List<Users> filteredFollowers = List.from(allFollowers);
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(AppStrings.myFriends),
              content: SizedBox(
                width: double.maxFinite, // Dialog genişliği
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Arama TextField
                    TextField(
                      onChanged: (query) {
                        setState(() {
                          searchQuery = query;
                          filteredFollowers = allFollowers.where((user) {
                            final nameMatch = user.displayName.toLowerCase().contains(searchQuery.toLowerCase());
                            final usernameMatch = user.username.toLowerCase().contains(searchQuery.toLowerCase());
                            return nameMatch || usernameMatch;
                          }).toList();
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: AppStrings.search,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Kullanıcıları listeleme
                    Flexible(
                      child: filteredFollowers.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(AppStrings.noMyFriends),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredFollowers.length,
                        itemBuilder: (context, index) {
                          Users user = filteredFollowers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: user.profileImageUrl.isNotEmpty
                                  ? NetworkImage(user.profileImageUrl)
                                  : null,
                              child: user.profileImageUrl.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(user.displayName),
                            subtitle: Text(user.username),
                            onTap: () {
                              Navigator.pushReplacementNamed(context, "/send_message_page", arguments: user.uid!);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(AppStrings.close),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //bildirim gönder
  static void sendNotification(String targetId, String message, String title, String targetPage, String receiverId) {
    sendNotificationService(
      target: targetId, // Alıcı kullanıcının ID'si
      message: message,
      title: title,
      targetPage:targetPage,
      receiverId: receiverId);
  }




}
