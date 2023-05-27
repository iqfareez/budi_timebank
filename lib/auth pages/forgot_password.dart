import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/constants.dart';
//import 'package:testfyp/pages/password.dart';
import 'sign_up_page.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  PasswordRecoveryPageState createState() => PasswordRecoveryPageState();
}

class PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  bool _isLoading = false;
  final bool _redirecting = false;
  late final TextEditingController _emailController;
  late final StreamSubscription<AuthState> _authStateSubscription;
  //final session = supabase.auth.currentSession;
  //late final TextEditingController _passwordController;
  //late final StreamSubscription<AuthState> _authStateSubscription;
  Future<void> _passwordRecover() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.resetPasswordForEmail(
        _emailController.text,
        redirectTo: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
      );
      // final data = await supabase
      //     .from('profiles')
      //     .select()
      //     .eq('Email', _emailController.text);
      // print(data);
      //final session = supabase.auth.currentSession;
      //print(session!.user.id.length);
      //print(object)
      // if (response.user!.identities!.length == 0) {
      //   context.showSnackBar(message: 'User Already Registered!!');
      //   // _emailController.clear();
      //   // _passwordController.clear();
      // } else
      if (mounted) {
        context.showSnackBar(
            message: 'Check your email for password recovery!');
        // _emailController.clear();
        // Navigator.of(context).popUntil((route) => route.isFirst);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (BuildContext context) => SplashPage()));
      }
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
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
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      final AuthChangeEvent event = data.event;
      //print(event);
      if (event == AuthChangeEvent.passwordRecovery && session != null) {
        // handle signIn
        Navigator.of(context).pushReplacementNamed('/passwordReset');
      }
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => const PasswordPage()));
    });
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
        // backgroundColor: Color.fromARGB(255, 127, 17, 224),
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
                helperText: 'Do not close this page during password change'),
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
