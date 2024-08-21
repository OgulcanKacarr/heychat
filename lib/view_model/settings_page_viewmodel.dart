import 'package:flutter/cupertino.dart';

class SettingsPageViewmodel extends ChangeNotifier{


  //Çıkış yap ve login ekranına gönder
  Future<void> logout(BuildContext context) async{
    Navigator.pushReplacementNamed(context, "/login_page");
    notifyListeners();
  }
}