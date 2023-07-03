import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'auth pages/setup_profile.dart';
import 'auth%20pages/account_page.dart';
import 'auth%20pages/loginPage.dart';
import 'auth%20pages/password.dart';
import 'auth%20pages/signUpPage.dart';
import 'custom widgets/theme.dart';
import 'dashboard%20pages/dashboard.dart';
import 'firebase_options.dart';
import 'navigation.dart';
import 'navigationPersistent.dart';
import 'profile%20pages/profile.dart';
import 'request pages/request.dart';
import 'service%20pages/service.dart';
import 'splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // emulator settings
  // if (kDebugMode) {
  //   FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   // FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BUDI Timebank',
      theme: themeData1(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/signup': (_) => const SignUpPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/setupProfile': (_) => const SetupProfile(),
        '/navigation': (_) => const BottomBarNavigation(valueListenable: 0),
        '/navigationP': (_) => const PersistentBottomNavigationBar(),
        '/profile': (_) => const ProfilePage(isMyProfile: true),
        '/passwordReset': (_) => const PasswordPage(),
        '/request': (_) => const RequestPage(),
        '/service': (_) => const ServicePage(),
        '/dashboard': (_) => const DashBoard(),
      },
    );
  }
}
