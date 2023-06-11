//splash screen that will be shown
//to users right after they open the app.
//This screen retrieves the current session and
//redirects the user accordingly.
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'components/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //bool _redirecting = false;
  //late final StreamSubscription<AuthState> _authStateSubscription;
  bool _redicrectCalled = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //_passwordRecovery();
    _redirect();
  }

  // Future<void> _passwordRecovery() async {
  //   _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
  //     //if (_redirecting) return;
  //     final session = data.session;
  //     final AuthChangeEvent event = data.event;
  //     //print(event);
  //     if (event == AuthChangeEvent.passwordRecovery && session != null) {
  //       // handle signIn
  //       Navigator.of(context).pushReplacementNamed('/passwordReset');
  //     }
  //     // Navigator.pushReplacement(
  //     //     context,
  //     //     MaterialPageRoute(
  //     //         builder: (BuildContext context) => const PasswordPage()));
  //   });
  // }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (_redicrectCalled || !mounted) {
      return;
    }

    _redicrectCalled = true;

    final session = FirebaseAuth.instance.currentUser;
    //print('The session is ' + session.toString());
    // _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
    //   //if (_redirecting) return;
    //   final session1 = data.session;
    //   final AuthChangeEvent event = data.event;
    //   if (event == AuthChangeEvent.passwordRecovery && session1 != null) {
    //     // handle signIn
    //     Navigator.of(context).pushReplacementNamed('/passwordReset');
    //   } else
    // });

    print('session is ' + session.toString());

    if (session != null) {
      Navigator.of(context).pushReplacementNamed('/navigation');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    //_authStateSubscription.cancel();
    super.dispose();
  }

  // @override
  // void initState() {
  //   _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
  //     //if (_redirecting) return;
  //     final session = data.session;
  //     final AuthChangeEvent event = data.event;
  //     if (event == AuthChangeEvent.passwordRecovery) {
  //       // handle signIn
  //       Navigator.of(context).pushReplacementNamed('/passwordReset');
  //     }
  //   });
  //   _redirect();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
