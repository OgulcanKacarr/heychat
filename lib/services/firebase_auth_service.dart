import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/FbErrorsMessages.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/OneSignalService.dart';
import 'package:heychat/services/firebase_firestore_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Fberrorsmessages _fberrorsmessages = Fberrorsmessages();
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  final OnesignalService _oneSignaLService = OnesignalService();

  // Firebase ile yeni kullanıcı oluşturma metodu
  Future<void> createUserWithFirebase(BuildContext context, String email,
      String password, String display_name, String username) async {
    try {

      //kullanıcı adını kontrol et
      bool isUsernameTaken = await _firestoreService.checkUsername(context, username);
      if (isUsernameTaken) {
        ShowSnackBar.show(context, AppStrings.usernameAlreadyTaken);
        return;
      }
      //kullanıcı oluştur
      UserCredential value = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Users user = Users(
          uid: value.user!.uid,
          email: email,
          username: username,
          displayName: display_name);

      if (value.user != null) {
        //Kullanıcı adını gir
        value.user!.updateDisplayName(user.displayName);
        //kullanıcı şifresini gir
        value.user!.updatePassword(password);

        // Kullanıcı bilgilerini veritabanına ekle
        _firestoreService.addUserInfoInDatabase(context, user);
        await _oneSignaLService.setupOneSignal(_auth.currentUser!.uid);
      } else {
        ShowSnackBar.show(context, AppStrings.userCreationFailed);
      }
    } on FirebaseAuthException catch (e) {
      // Hata mesajını al ve kullanıcıya göster
      String errorMessage = _fberrorsmessages.handleError(e.code);
      ShowSnackBar.show(context, errorMessage);
    } catch (e) {
      // Diğer tüm hatalar için genel bir hata mesajı göster
      ShowSnackBar.show(context, AppStrings.system_error);
    }
  }

  // Firebase ile yeni kullanıcı oluşturma metodu
  Future<void> loginUserWithFirebase(BuildContext context, String email,
      String password) async {
    try {

      //kullanıcı oluştur
      UserCredential value = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //giriş yap ve online durumunu güncelle
      if (value.user != null) {
        User? user = value.user;
        setUserOnline(context, user!).then((onValue){
          Navigator.pushReplacementNamed(context, "/home_page");
        });

      } else {
        ShowSnackBar.show(context, AppStrings.loginFailed);
      }
    } on FirebaseAuthException catch (e) {
      // Hata mesajını al ve kullanıcıya göster
      String errorMessage = _fberrorsmessages.handleError(e.code);
      ShowSnackBar.show(context, errorMessage);
    } catch (e) {
      // Diğer tüm hatalar için genel bir hata mesajı göster
      ShowSnackBar.show(context, AppStrings.system_error);
    }
  }


  //Kullanıcı bilgilerini profil sayfası için çek
  Future<Users?> getUsersFromFirebase(BuildContext context,String user_id) async {
    Users? user_info = await _firestoreService.getUsersInfoFromDatabase(context,user_id);
    return user_info;

  }


  //Kullanıcının oturum açma/kapatma durumunu kontrol etme
  Future<void> checkUser(BuildContext context, User user) async {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user == null) {
        //Kullanıcı çıkış yaptıysa
        await setUserOffline(context,user!);
        Navigator.pushReplacementNamed(context, "/login_page");
      } else {
        //kullanıcı giriş yaptıysa
        await setUserOnline(context,user);
        Navigator.pushReplacementNamed(context, "/home_page");
      }
    });
  }

  //Kullanıcı daha önceden giriş yaptı mı?
  Future<bool> checkLoginStatus(BuildContext context) async {
    if (_auth.currentUser != null) {
      setUserOnline(context, _auth.currentUser!);
      await _oneSignaLService.setupOneSignal(_auth.currentUser!.uid);
       _oneSignaLService.handlerOneSignal(context);
      return true;
    } else {
      return false;
    }
  }

  //Kullanıcı isOnline değerini true yapma
  Future<void> setUserOnline(BuildContext context,User user) async {
    _firestoreService.updateUserOnline(context, user, true);
  }

  //Kullanıcı isOnline değerini false yapma
  Future<void> setUserOffline(BuildContext context, User user) async {
    _firestoreService.updateUserOnline(context, user, false);
  }

  //Kullanıcı çıkış yapma
  Future<void> signOut(BuildContext context) async {
    final user = _auth.currentUser;
    if (user != null) {
      // Kullanıcı çıkış yaparken Firestore'daki isOnline değerini false yap
      await setUserOffline(context,user);
    }

    await _auth.signOut().then((onValue){
      Navigator.pushReplacementNamed(context, "/login_page");
    });

  }
}
