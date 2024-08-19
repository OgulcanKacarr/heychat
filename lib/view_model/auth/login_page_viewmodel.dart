import 'package:flutter/cupertino.dart';

class LoginPageViewmodel extends ChangeNotifier{

  //Kayıt sayfasına gönderme butonu
  void goRegisterPage(BuildContext context){
    Navigator.pushReplacementNamed(context, "/create_page");
  }
}