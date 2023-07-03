import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color color;
  const CustomDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
        //horizontal line
        color: color,
        height: 30,
        thickness: 2,
        indent: 15,
        endIndent: 15);
  }
}
