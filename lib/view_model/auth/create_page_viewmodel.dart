import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_auth_service.dart';

class CreatePageViewmodel extends ChangeNotifier {
  int pageview_current_index = 0;
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  //Giriş sayfasına gönderme butonu
  void goLoginPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login_page");
  }

  //Kullanıcı oluştur
  Future<void> createUser(
      BuildContext context,
      String name,
      String surname,
      String username,
      String email,
      String password,
      String re_password) async {
    // Önce boş alanların kontrolü yapılıyor
    if (name.isEmpty) {
      ShowSnackBar.show(context, AppStrings.empty_name);
      return;
    }
    if (surname.isEmpty) {
      ShowSnackBar.show(context, AppStrings.empty_surname);
      return;
    }
    if (username.isEmpty) {
      ShowSnackBar.show(context, AppStrings.empty_username);
      return;
    }
    if (email.isEmpty) {
      ShowSnackBar.show(context, AppStrings.emtpy_email);
      return;
    }
    if (password.isEmpty) {
      ShowSnackBar.show(context, AppStrings.empty_password);
      return;
    }
    if (re_password.isEmpty) {
      ShowSnackBar.show(context, AppStrings.repassword);
      return;
    }
    if (password != re_password) {
      ShowSnackBar.show(context, AppStrings.not_match_password);
      return;
    }
    //ismin ilk harfi büyük yap
    name = name[0].toUpperCase() + name.substring(1);
    String full_name = "$name ${surname.toUpperCase()}";

    if (name.isNotEmpty &&
        surname.isNotEmpty &&
        username.isNotEmpty &&
        email.isNotEmpty &&
        full_name.isNotEmpty &&
        password.contains(re_password)) {


      // İşlem başlamadan önce yükleme göstergesini başlat
      showDialog(
        context: context,
        barrierDismissible: false, // Dışarıya tıklanarak kapatılamaz
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        // Firebase servisi ile kullanıcı oluşturma işlemi
        await _firebaseAuthService.createUserWithFirebase(context, email, password, full_name, username);


      } catch (e) {
        // Hata durumunda hata mesajı gösterin
        ShowSnackBar.show(context, AppStrings.user_creation_failed);
      } finally {
        // İşlem tamamlandığında yükleme göstergesini kapat
        Navigator.of(context).pop();
      }
    }
  }
}
