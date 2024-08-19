import 'package:flutter/cupertino.dart';

class CreatePageViewmodel extends ChangeNotifier{
  int pageview_current_index = 0;


  //Giriş sayfasına gönderme butonu
  void goLoginPage(BuildContext context){
    Navigator.pushReplacementNamed(context, "/login_page");
  }






}