import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard%20pages/dashboard.dart';
import 'navigation.dart';
import 'auth%20pages/account_page.dart';
import 'auth%20pages/loginPage.dart';
import 'auth%20pages/password.dart';
import 'auth%20pages/signUpPage.dart';
import 'navigationPersistent.dart';
import 'service%20pages/service.dart';
import 'splash_page.dart';
import 'profile%20pages/profile.dart';
import 'custom widgets/theme.dart';
import 'request pages/request.dart';

//adb shell am start -W -a android.intent.action.VIEW -d "io.supabase.flutterquickstart://login-callback/"
//protoc -Iprotos protos/collection/service-request.proto --dart_out=grpc:lib/generated
//protoc -Iprotos protos/collection/rating.proto --dart_out=grpc:lib/generated
//protoc -Iprotos protos/auth.proto --dart_out=grpc:lib/generated
//protoc -Iprotos protos/misc.proto --dart_out=grpc:lib/generated
//protoc -Iprotos protos/user.proto --dart_out=grpc:lib/generated
Future<void> main() async {
  // const ujaiUrl = 'https://qcoqbidwruiakpykidlf.supabase.co';
  // const ujaiKey =
  //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjb3FiaWR3cnVpYWtweWtpZGxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjYzNDEzODYsImV4cCI6MTk4MTkxNzM4Nn0.ol5POkel6KTRNrDk7Z_yUvYhzJ7_SXbY7Yt94Wvzi-Q';
  const ammarUrl = 'https://quepskrrpovzwydvfezs.supabase.co';
  const ammarKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF1ZXBza3JycG92end5ZHZmZXpzIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjcxMjU1NzksImV4cCI6MTk4MjcwMTU3OX0.DCX9Qw3GKYdg-Ew96DHU-4wCIqdFm-AS7S63AAx8wFQ';

  await Supabase.initialize(url: ammarUrl, anonKey: ammarKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Flutter',
      theme: themeData1(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/signup': (_) => const SignUpPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
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
