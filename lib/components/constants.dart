import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    //Color backgroundColor,
    Color backgroundColor = const Color.fromARGB(255, 10, 161, 65),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        message,
        //style: TextStyle(color: Colors.black)
      ),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(
        message: message, backgroundColor: const Color.fromARGB(255, 244, 26, 10));
  }
}
