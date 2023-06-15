import 'package:flutter/material.dart';

class Heading2 extends StatelessWidget {
  String heading2;

  Heading2(this.heading2, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Text(
        heading2,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          // decoration: TextDecoration.underline,
          //decorationThickness: 1.5
        ),
      ),
    );
  }
}
