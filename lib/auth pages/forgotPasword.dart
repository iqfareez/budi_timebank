import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/constants.dart';
//import 'package:budi_timebank/pages/password.dart';
import 'signUpPage.dart';
import '../custom%20widgets/theme.dart';

// import '../splash_page.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  PasswordRecoveryPageState createState() => PasswordRecoveryPageState();
}

class PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  bool _isLoading = false;
  final bool _redirecting = false;
  late final TextEditingController _emailController;
  late final StreamSubscription<User?> _authStateSubscription;
  //final session = supabase.auth.currentSession;
  //late final TextEditingController _passwordController;
  //late final StreamSubscription<AuthState> _authStateSubscription;
  Future<void> _passwordRecover() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // await supabase.auth.resetPasswordForEmail(
      //   _emailController.text,
      //   redirectTo: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
      // );
      // TODO: I dont know about the code below. Need to check if is is really working
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
          actionCodeSettings: ActionCodeSettings(
              url: 'https://budi-timebank.web.app',
              handleCodeInApp: true,
              androidPackageName: 'com.iqfareez.budi_timebank',
              androidInstallApp: true,
              androidMinimumVersion: '16',
              iOSBundleId: 'com.example.budiTimebank',
              dynamicLinkDomain: 'budi-timebank.web.app'));
      if (mounted) {
        context.showSnackBar(
            message: 'Check your email for password recovery!');
      }
    } on FirebaseAuthException catch (error) {
      context.showErrorSnackBar(message: error.message.toString());
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error occured');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _authStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        // TODO: Handle bende alah ni
      } else {
        print('User is signed in!');
      }
    });
    // _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
    //   if (_redirecting) return;
    //   final session = data.session;
    //   final AuthChangeEvent event = data.event;
    //   //print(event);
    //   if (event == AuthChangeEvent.passwordRecovery && session != null) {
    //     // handle signIn
    //     Navigator.of(context).pushReplacementNamed('/passwordReset');
    //   }
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => const PasswordPage()));
    // });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    // _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Change'),
        backgroundColor: themeData2().primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Enter your email'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              //hintText: 'Do not close this page during password change',
              helperText: 'Do not close this page during password change',
              labelStyle: TextStyle(
                //fontSize: 35,
                color: Color.fromARGB(255, 89, 175, 89),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 89, 175, 89))),
            ),
          ),
          // const SizedBox(height: 18),
          // TextFormField(
          //   controller: _passwordController,
          //   decoration: const InputDecoration(labelText: 'Password'),
          // ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _isLoading ? null : _passwordRecover,
            child: Text(_isLoading ? 'Loading' : 'Submit'),
          ),
          // ElevatedButton(
          //   onPressed: _isLoading ? null : _passwordRecover,
          //   child: Text('Forgot Password'),
          // ),
          TextButton(
            onPressed: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ));
            }),
            child: const Text('Sign Up'),
          ),
          // ElevatedButton(
          //     onPressed: (() {
          //       Navigator.of(context).pushNamed('/navigation');
          //     }),
          //     child: const Text('Skip (for developers)'))
        ],
      ),
    );
  }
}
