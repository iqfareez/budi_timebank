import 'dart:async';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/constants.dart';
// import 'package:testfyp/pages/signUpPage.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  PasswordPageState createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
  bool _isLoading = false;
  //bool _redirecting = false;
  //late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  //late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _passwordRecovery() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.updateUser(
        UserAttributes(
          password: _passwordController.text,
        ),

        // _emailController.text,
        // redirectTo: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
      );
      if (mounted) {
        context.showSnackBar(message: 'Password Updated!');
        Navigator.of(context).pushReplacementNamed('/navigation');
        _passwordController.clear();
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
    // _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
    //   if (_redirecting) return;
    //   final session = data.session;
    //   if (session != null) {
    //     _redirecting = true;
    //     Navigator.of(context).pushReplacementNamed('/dashboard');
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    //_emailController.dispose();
    _passwordController.dispose();
    // _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset'),
        // backgroundColor: Color.fromARGB(255, 127, 17, 224),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Enter new password'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          // const SizedBox(height: 18),
          // TextFormField(
          //   controller: _passwordController,
          //   decoration: const InputDecoration(labelText: 'Password'),
          // ),
          // const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _isLoading ? null : _passwordRecovery,
            child: Text(_isLoading ? 'Loading' : 'Submit'),
          ),
          // ElevatedButton(
          //   onPressed: _isLoading ? null : _passwordRecover,
          //   child: Text('Forgot Password'),
          // ),
          // TextButton(
          //   onPressed: (() {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const SignUpPage(),
          //         ));
          //   }),
          //   child: Text('Sign Up'),
          // ),
          // ElevatedButton(
          //     onPressed: (() {
          //       Navigator.of(context).pushNamed('/navigation');
          //     }),
          //     child: Text('Skip (for developers)'))
        ],
      ),
    );
  }
}
