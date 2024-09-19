import 'dart:ui' as ui;
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OnesignalService {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<void> setupOneSignal(String userId) async {
    try {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final String deviceId = await androidInfo.id;
      final String deviceLang =
          ui.PlatformDispatcher.instance.locale.languageCode;

      OneSignal.Notifications.requestPermission(true);
      OneSignal.initialize(AppStrings.appId);
      OneSignal.login(userId);
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.User.setLanguage(deviceLang.toString());
      OneSignal.User.addTags({"userId":userId,"deviceId": deviceId, "deviceLang": deviceLang});

    } catch (e) {
      print("OneSignal kurulumu sırasında hata: $e");
    }
  }

  void handlerOneSignal(BuildContext context) {
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      if (data != null) {
        String? targetPage = data['targetPage'];
        String? receiverId = data['receiverId']; // receiverId'yi alıyoruz
        if (targetPage != null && receiverId != null) {
          // Gelen targetPage ve receiverId değerine göre sayfaya yönlendiriyoruz
          if (targetPage == 'send_message_page') {
            Navigator.pushNamed(context, '/send_message_page', arguments: receiverId);
          }
        }
      }
    });
  }

}
