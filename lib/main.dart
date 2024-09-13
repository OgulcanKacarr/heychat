import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppLifecycleObserver.dart';
import 'package:heychat/services/firebase_auth_service.dart';
import 'package:heychat/view/auth/create_page.dart';
import 'package:heychat/view/auth/login_page.dart';
import 'package:heychat/view/chats/chats_page.dart';
import 'package:heychat/view/nav/home_page.dart';
import 'package:heychat/view/post/post_page.dart';
import 'package:heychat/view/profile/look_profile.dart';
import 'package:heychat/view/profile/profile_page.dart';
import 'package:heychat/view/requests/requests_page.dart';
import 'package:heychat/view/reset_password/reset_password_page.dart';
import 'package:heychat/view/search_human/search_page.dart';
import 'package:heychat/view/settings/settings_app_color_page.dart';
import 'package:heychat/view/settings/settings_page.dart';
import 'package:heychat/view/settings/settings_personel_page.dart';
import 'package:heychat/view/splash/splas_page.dart';
import 'constants/AppThemes.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: Main()));
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with WidgetsBindingObserver {

  late AppLifecycleObserver _appLifecycleObserver;
  late AppLifecycleState appLifecycleState;

  final FirebaseAuthService _firebaseAuthService =FirebaseAuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _appLifecycleObserver = AppLifecycleObserver(
      onAppBackground: _onAppBackground,
      onAppForeground: _onAppForeground,
    );
    WidgetsBinding.instance.addObserver(_appLifecycleObserver);
    // Uygulama başladığında kullanıcıyı çevrimiçi yapma

  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    super.dispose();
  }


  void _onAppBackground() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _firebaseAuthService.setUserOffline(context, currentUser);
    }
  }

  void _onAppForeground() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _firebaseAuthService.setUserOnline(context, currentUser);
    }
  }

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
        "/chats_page": (context) =>  const ChatsPage(),
        "/search_page": (context) =>    SearchPage(),
        "/profile_page": (context) => const ProfilePage(),
        "/settings_page": (context) => const SettingsPage(),
        "/settings_feed_page": (context) =>   SettingsAppColorPage(),
        "/settings_personel_page": (context) =>   const SettingsPersonelPage(),
        "/look_page": (context) =>    LookProfile(),
        "/request_page": (context) =>    RequestsPage(),
        "/post_page": (context) =>    PostPage(),
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
