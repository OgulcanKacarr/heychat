import 'package:flutter/cupertino.dart';
import 'package:heychat/services/firebase_auth_service.dart';

class SettingsPageViewmodel extends ChangeNotifier{

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  //Çıkış yap ve login ekranına gönder
  Future<void> logout(BuildContext context) async{
    await _firebaseAuthService.signOut(context);
    notifyListeners();
  }
}