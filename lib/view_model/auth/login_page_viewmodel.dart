import 'package:flutter/cupertino.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/services/firebase_auth_service.dart';

class LoginPageViewmodel extends ChangeNotifier{

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  //Kayıt sayfasına gönderme butonu
  void goRegisterPage(BuildContext context){
    Navigator.pushReplacementNamed(context, "/create_page");
  }

  //Şifre sıfırlama sayfasına gönderme butonu
  void goResetPasswordPage(BuildContext context){
    Navigator.pushReplacementNamed(context, "/reset_password_page");
  }

  Future<void> loginButton(BuildContext context, String email, String password) async {

    if (email.isEmpty) {
      ShowSnackBar.show(context, AppStrings.emtpy_email);
      return;
    }
    if (password.isEmpty) {
      ShowSnackBar.show(context, AppStrings.empty_password);
      return;
    }
    if(email.isNotEmpty && password.isNotEmpty){
      await _firebaseAuthService.loginUserWithFirebase(context, email, password);
      notifyListeners();
    }

  }

}