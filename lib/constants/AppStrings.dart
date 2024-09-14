import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppStrings {
  // App General Strings
  static const String appName = "Hey Chat";

  // Authentication & User Info
  static const String login = "Giriş Yap";
  static const String signUp = "Kayıt Ol";
  static const String registerButton = "Kayıt Ol";
  static const String loginFailed = "Giriş yapılamadı.";
  static const String unknownError = "Bilinmeyen bir hata oluştu";
  static const String userCreatedSuccessfully = "Kullanıcı başarıyla oluşturuldu.";
  static const String userCreationFailed = "Kullanıcı oluşturulamadı.";
  static const String userNotFound = "Kullanıcı bulunamadı.";
  static const String usernameAlreadyTaken = "Bu kullanıcı adı zaten alınmış.";
  static const String passwordsDoNotMatch = "Parolalar eşleşmiyor";

  // User Input Prompts & Errors
  static const String enterEmail = "Email";
  static const String emptyEmail = "Email boş olamaz";
  static const String enterPassword = "Parola";
  static const String emptyPassword = "Parola boş olamaz";
  static const String confirmPassword = "Parolayı Doğrula";
  static const String name = "İsim";
  static const String emptyName = "İsim boş olamaz";
  static const String surname = "Soyisim";
  static const String emptySurname = "Soyisim boş olamaz";
  static const String username = "Kullanıcı Adı";
  static const String emptyUsername = "Kullanıcı adı boş olamaz";
  static const String bio_is_not_empty = "Bio boş olamaz";
  static const String or = "Ya da";
  static const String failedToRetrieveUserInfo = "Kullanıcı bilgileri alınamadı.";
  static const String coverPhotoNotFound = "Kapak fotoğrafı yok.";
  static const String system_error = "Sistem kaynaklı bir hata oluştu, hata mesajı -> ";
  static const String noUploadProfilePhoto = "Profil fotoğrafı boş olduğu için işlem tamamlanamadı";
  static const String noUploadCoverPhoto = "Kapak fotoğrafı boş olduğu için işlem tamamlanamadı";
  static const String noPostSelectPhoto = "Gönderi fotoğrafı seçilmedi";
  static const String noCaption = "Açıklama eklemelisin!";

  // Navigation & Actionsc
  static const String nextPage = "İleri";
  static const String search = "Ara";
  static const String cancel = "İptal";
  static const String save = "Kaydet";
  static const String apply = "Uygula";
  static const String share = "Paylaş";
  static const String delete = "Sil";
  static const String select = "Seç";
  static const String logout = "Çıkış Yap";
  static const String change = "Değiştir";

  // Profile & Settings
  static const String profile = "Ben";
  static const String personalSettings = "Kişisel Ayarlar";
  static const String appSettings = "Ayarlar";
  static const String appColorSettings = "Renk Ayarları";
  static const String notificationSettings = "Bildirim Ayarları";
  static const String applySettings = "Ayarlar uygulandı";
  static const String changeProfilePhoto = "Profili Değiştir";
  static const String changeCoverPhoto = "Kapağı Değiştir";
  static const String sharePostSuccesful = "Gönderi paylaşıldı.";
  static const String changePassword = "Şifre Değiştir";
  static const String oldPassword = "Eski Şifre";
  static const String newPassword = "Yeni Şifre";
  static const String confirmNewPassword = "Yeni Şifreyi Doğrula";
  static const String updateSuccess = "Güncelleme başarılı.";
  static const String passwordUpdateSuccess = "Şifre başarıyla güncellendi.";
  static const String did_you_forget_your_password = "Şifreni mi unuttun?";
  static const String deleteProfilePhoto = "Profil fotoğrafı başarıyla silindi.";
  static const String deleteCoverPhoto = "Kapak fotoğrafı başarıyla silindi.";
  static const String noProfilePhoto = "Henüz profil fotoğrafı yüklenmedi.";
  static const String noCoverPhoto = "Henüz kapak fotoğrafı yüklenmedi.";
  static const String bio = "Biyografi";
  static const String enterBio = "Biyografi girin.";
  static const String errorFetchingUser = "Kullanıcı bilgileri alınamadı.";

  // Follow & Requests
  static const String follow = "Takip Et";
  static const String unfollow = "Takipten Çık";
  static const String sendFollowRequest = "Takip Et";
  static const String followRequestSent = "İstek gönderildi.";
  static const String requestAlreadySent = "İstek zaten gönderildi.";
  static const String followers = "Takipçi";
  static const String accept = "Kabul et";
  static const String noRequests = "Hiçbir istek yok.";

  // UI Elements
  static const String chats = "Sohbetler";
  static const String feed = "Akış";
  static const String add = "Ekle";
  static const String requests = "İstekler";
  static const String floatingActionButtonTitle = "Buton Rengi";
  static const String floatingActionButtonBackgroundColorTitle = "Arkaplan Rengi";
  static const String floatingActionButtonForegroundColorTitle = "İçerik Rengi";
  static const String activeColor = "Aktif Renk";
  static const String inactiveColor = "Pasif Renk";
  static const String chooseColor = "Bir renk seç";
  static const String bottomBarColorSettings = "Alt Bar Rengi";
  static const String appBarColorSettings = "Üst Bar Rengi";
  static const String add_post = "Gönderi paylaş";
  static const String description_hint = "Açıklama";
  static const String description_hint_error = "Lütfen bir fotoğraf seçin ve açıklama yazın.";
  static const String choose_photo = "Fotoğraf Seç";
  static const String enter_comment = "Yorum yap";

  // Registration Steps
  static const String registrationStep = "Yaklaştık";
  static const String finalRegistrationStep = "Son Aşama";

  // Firebase
  static const String users = "Users";
  static const String posts = "Posts";
  static const String profilePhotoInFirebase = "ProfilePhoto";
  static const String coverPhotoInFirebase = "CoverPhoto";

  // Paths & Assets
  static const String logo = "assets/images/logo.png";
  static const Icon profilePhotoIcon = Icon(Icons.person);

}

