import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_auth_service.dart';
import 'package:photo_view/photo_view.dart';

class ProfilePageViewmodel extends ChangeNotifier{

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  Future<Users?> getUserInfo(BuildContext context, String user_id) async {
    Users? user_info = await _firebaseAuthService.getUsersFromFirebase(context,user_id);
    notifyListeners();
    return user_info;
  }

  //Fotoğrafları getirme metodu
  Widget getPhoto(String image_url) {
    return PhotoView.customChild(
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 2,
      backgroundDecoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      initialScale: PhotoViewComputedScale.contained,
      child: CachedNetworkImage(
        imageUrl: image_url,
        fit: BoxFit.contain,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          if (downloadProgress.totalSize != null) {
            final percent =
            (downloadProgress.progress! * 100).toStringAsFixed(0);
            return Center(
              child: Text("$percent% tamamlandı"),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}