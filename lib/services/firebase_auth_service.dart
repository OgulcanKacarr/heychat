import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:heychat/constants/AppStrings.dart';

class FirebaseAuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _users_db = AppStrings.users;




  //Kullanıcının oturum açma/kapatma durumunu kontrol etme
   Future<void> checkUser(BuildContext context, User user) async{
    FirebaseAuth.instance
        .userChanges()
        .listen((user) async {
      if (user == null) {
        //Kullanıcı çıkış yaptıysa
        await setUserOffline(user!);
        Navigator.pushReplacementNamed(context, "/login_page");
      } else {
        //kullanıcı giriş yaptıysa
        await setUserOnline(user);
        Navigator.pushReplacementNamed(context, "/home_page");
      }
    });
  }

  //Kullanıcı daha önceden giriş yaptı mı?
   Future<bool> checkLoginStatus(BuildContext context) async {
     if(_auth.currentUser != null){
       return true;
     }else{
       return false;
     }
  }

  //Kullanıcı isOnline değerini true yapma
  Future<void> setUserOnline(User user) async {

  }
  //Kullanıcı isOnline değerini false yapma
  Future<void> setUserOffline(User user) async {

  }

  //Kullanıcı çıkış yapma
  Future<void> signOut(BuildContext context) async {
    final user = _auth.currentUser;
    if (user != null) {
      // Kullanıcı çıkış yaparken Firestore'daki isOnline değerini false yap
      await setUserOffline(user);
    }

    await _auth.signOut();
    Navigator.pushReplacementNamed(context, "/login_page");
  }
}