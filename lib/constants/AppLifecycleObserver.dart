import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final Function onAppBackground;
  final Function onAppForeground;

  AppLifecycleObserver({
    required this.onAppBackground,
    required this.onAppForeground,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        onAppBackground();
        break;
      case AppLifecycleState.resumed:
        onAppForeground();
        break;
      default:
        break;
    }
  }
}
