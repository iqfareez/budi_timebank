import 'package:flutter/material.dart';

class CustomHeadline extends StatelessWidget {
  //const CustomHeadline({Key? key}) : super(key: key);
  final heading;
  final color;

  const CustomHeadline({super.key, required this.heading, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: Text(
        heading,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),

        //style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
