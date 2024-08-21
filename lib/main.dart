import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/services/firebase_auth_service.dart';
import 'package:heychat/view/auth/create_page.dart';
import 'package:heychat/view/auth/login_page.dart';
import 'package:heychat/view/nav/chats_page.dart';
import 'package:heychat/view/nav/flow_page.dart';
import 'package:heychat/view/nav/home_page.dart';
import 'package:heychat/view/nav/profile_page.dart';
import 'package:heychat/view/reset_password_page.dart';
import 'package:heychat/view/search_page.dart';
import 'package:heychat/view/settings/settings_feed_page.dart';
import 'package:heychat/view/settings/settings_page.dart';
import 'package:heychat/view/splas_page.dart';
import 'constants/AppThemes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: Main()));
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: AppThemes.darkTheme,
      theme: AppThemes.lightTheme,
      home: FutureBuilder(
        future: checkInitialLoginStatus(context),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data as Widget;
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),

      routes: {
        "/home_page": (context) => HomePage(),
        "/splash_page": (context) => const SplashPage(),
        "/create_page": (context) => const CreatePage(),
        "/login_page": (context) => const LoginPage(),
        "/reset_password_page": (context) => const ResetPasswordPage(),
        "/chats_page": (context) => const ChatsPage(),
        "/search_page": (context) => const SearchPage(),
        "/flow_page": (context) => const FlowPage(),
        "/profile_page": (context) => const ProfilePage(),
        "/settings_page": (context) => const SettingsPage(),
        "/settings_feed_page": (context) =>   SettingsFeedPage(),
      },
    );
  }

  Future<Widget> checkInitialLoginStatus(BuildContext context) async {
    final authService = FirebaseAuthService();
    Future<bool> isLogin = authService.checkLoginStatus(context);
    if (await isLogin) {
      return const HomePage();
    } else {
      return LoginPage();
    }
  }
}
