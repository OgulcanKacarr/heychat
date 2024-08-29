
import 'AppStrings.dart';

class Fberrorsmessages {
  static const
  Map<String, String> authErrors = {
  // Kullanıcı giriş ve kayıt hataları
  "email-already-in-use":"Bu e-posta adresi zaten başka bir hesap tarafından kullanılıyor.",
  "invalid-email":"E-posta adresi hatalı biçimlendirilmiş.",
  "wrong-password":"Şifre geçersiz veya kullanıcı bir şifreye sahip değil.",
  "user-not-found":"Bu e-posta adresine sahip bir kullanıcı bulunamadı.",
  "account-exists-with-different-credential":"Aynı e-posta adresine sahip bir hesap farklı kimlik bilgileriyle mevcut. Bu e-posta adresiyle ilişkili bir sağlayıcıyı kullanarak oturum açın.",
  "credential-already-in-use":"Bu kimlik bilgisi zaten başka bir kullanıcı hesabıyla ilişkilendirilmiş.",
  "operation-not-allowed":"Belirtilen oturum açma sağlayıcısı bu Firebase projesinde devre dışı bırakılmış. Firebase konsolundan etkinleştirin.",
  "requires-recent-login":"Bu işlem hassas olduğundan, son bir kimlik doğrulaması gerektirir. Bu isteği tekrar denemeden önce tekrar giriş yapın.",
  "user-disabled":"Bu kullanıcı hesabı devre dışı bırakılmış.",
  "invalid-credential":"Sağlanan kimlik bilgisi bozuk veya süresi dolmuş.",
  "missing-email":"E-posta adresi sağlanmamış.",
  "missing-password":"Şifre sağlanmamış.",
  "invalid-action-code":"İşlem kodu geçersiz. Bu, kod bozuk, süresi dolmuş veya daha önce kullanılmış olabilir.",
  "expired-action-code":"İşlem kodunun süresi doldu.",
  "weak-password":"Şifre yanlış.",
  "email-change-needs-verification":"Çok faktörlü kullanıcıların her zaman doğrulanmış bir e-posta adresine sahip olması gerekir.",
};

  String handleError(String errorCode){
    String errorMessage = authErrors[errorCode] ?? AppStrings.error;
    return errorMessage;
  }
}
