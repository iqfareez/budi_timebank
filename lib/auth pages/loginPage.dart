import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testfyp/components/constants.dart';
import 'package:testfyp/auth%20pages/forgotPasword.dart';
import 'package:testfyp/auth%20pages/signUpPage.dart';
import 'package:testfyp/custom%20widgets/theme.dart';

import '../bin/common.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  bool _passwordVisible = false;
  late Common _common;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _logIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
        // emailRedirectTo:
        //     kIsWeb ? null : 'io.supabase.fluttercallback://Login-callback/',
      );
      // await ClientAuth(Common().channel)
      //     .signInUser(_emailController.text, _passwordController.text);

      // if (mounted) {
      //   context.showSnackBar(message: 'Check your email for Login link!');
      //   _emailController.clear();
      // }
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
      //print(error);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unable to log in!!');
    }
    setState(() {
      _common = Common();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      // final AuthChangeEvent event = data.event;
      // if (event == AuthChangeEvent.passwordRecovery && session != null) {
      //   // handle signIn
      //   Navigator.of(context).pushReplacementNamed('/passwordReset');
      // } else
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/navigation');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false, //avoid keyboard overflow
      // appBar: AppBar(
      //   title: const Text('Log In'),
      //   // backgroundColor: Color.fromARGB(255, 127, 17, 224),
      // ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15),
          //mainAxisAlignment: MainAxisAlignment.center,
          //padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeData1().primaryColor,
                      fontSize: 65,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'di',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeData1().primaryColor,
                      fontSize: 65,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Blockchain-Based ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeData1().secondaryHeaderColor,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Time Bank',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeData1().secondaryHeaderColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Log in with your email and password',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            TextFormField(
              //cursorColor: Color.fromARGB(255, 127, 17, 224),,
              controller: _emailController,
              //style: TextStyle(),

              decoration: InputDecoration(
                labelText: 'Email',
                // labelStyle: TextStyle(
                //   color: Color.fromARGB(255, 127, 17, 224),
                // ),
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 127, 17, 224)),
                ),
                // suffixIconColor: Color.fromARGB(255, 127, 17, 224),
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 127, 17, 224)),
                ),
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeData1().secondaryHeaderColor,
                foregroundColor: Colors.white,
                // side: BorderSide(
                //   width: 3.0,
                //   color: themeData1().secondaryHeaderColor,
                // )
              ),
              onPressed: _isLoading ? null : _logIn,
              child: Text(
                _isLoading ? 'Loading' : 'Login',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PasswordRecoveryPage(),
                    ));
              }),
              child: const Text('Forgot Password',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ));
              }),
              child: const Text(
                'Sign Up',
              ),
            ),
            // ElevatedButton(
            //     onPressed: (() {
            //       Navigator.of(context).pushNamed('/navigation');
            //     }),
            //     child: const Text('Skip (for developers)'))
          ],
        ),
      ),
    );
  }
}
