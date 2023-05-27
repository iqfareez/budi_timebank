import 'package:flutter/material.dart';

class CustomHeadline extends StatelessWidget {
  //const CustomHeadline({Key? key}) : super(key: key);
  final String heading;
  const CustomHeadline(this.heading, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        heading,
        style: const TextStyle(fontWeight: FontWeight.bold),
        //style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
