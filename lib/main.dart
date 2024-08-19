import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/services/firebase_auth_service.dart';
import 'package:heychat/view/auth/login_page.dart';
import 'package:heychat/view/home_page.dart';
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
