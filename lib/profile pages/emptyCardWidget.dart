import 'package:flutter/material.dart';

import '../custom widgets/theme.dart';

class emptyCardContact extends StatelessWidget {
  const emptyCardContact({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: themeData3().primaryColor,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          'No contact added',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
