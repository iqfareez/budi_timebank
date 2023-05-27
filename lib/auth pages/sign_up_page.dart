import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  bool _passwordVisible = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signIn() async {
    //final session = supabase.auth.currentSession;
    // final userId = supabase.auth.currentUser!.id; //map the user ID
    // final data = await supabase.from('profiles').select().eq('id', userId);
    // print('The data is' + data['username']);
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        emailRedirectTo:
            kIsWeb ? null : 'io.supabase.fluttercallback://SignUp-callback/',
      );

      // ERROR: Prompt the user to try again!
      // print(response.user!.identities!.length);
      // if (session != null) {!
      //   context.showSnackBar(message: 'User Already Registered!!');
      // }
      if (response.user!.identities!.isEmpty) {
        context.showSnackBar(message: 'User Already Registered!!');
        // _emailController.clear();
        // _passwordController.clear();
      } else if (mounted) {
        context.showSnackBar(message: 'Check your email for sign up link!');
        // _emailController.clear();
        // _passwordController.clear();
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
    _passwordController = TextEditingController();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/account');
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
      appBar: AppBar(
        title: const Text('Sign Up'),
        // backgroundColor: Color.fromARGB(255, 127, 17, 224),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Sign in via the magic link with your email below'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              helperText: 'Do not close this page when signing up',
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
            onPressed: _isLoading ? null : _signIn,
            child: Text(_isLoading ? 'Loading' : 'Sign Up'),
          ),
          // ElevatedButton(
          //     onPressed: (() {
          //       Navigator.of(context).pushReplacementNamed('/navigation');
          //     }),
          //     child: Text('Skip (for developers)'))
        ],
      ),
    );
  }
}
