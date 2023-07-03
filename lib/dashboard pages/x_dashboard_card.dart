import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom widgets/customHeadline.dart';
import '../navigation.dart';

/// Dashboard card for "Your Request" and "Your Service"
class XDashboardCard extends StatelessWidget {
  const XDashboardCard(
      {super.key,
      required this.borderColor,
      required this.navBarIndex,
      required this.title,
      required this.content});

  final Color borderColor;
  final int navBarIndex;
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor,
          width: 3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      //elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              //fullscreenDialog: true,
              builder: (BuildContext context) =>
                  BottomBarNavigation(valueListenable: navBarIndex),
            ),
          );
        },
        child: Column(
          children: [CustomHeadline(heading: title), content],
        ),
      ),
    );
  }
}
