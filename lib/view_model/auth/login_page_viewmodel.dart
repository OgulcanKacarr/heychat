import 'package:flutter/cupertino.dart';

class LoginPageViewmodel extends ChangeNotifier{

  //Kayıt sayfasına gönderme butonu
  void goRegisterPage(BuildContext context){
    Navigator.pushReplacementNamed(context, "/create_page");
  }

  //Şifre sıfırlama sayfasına gönderme butonu
  void goResetPasswordPage(BuildContext context){
    Navigator.pushReplacementNamed(context, "/reset_password_page");
  }

}