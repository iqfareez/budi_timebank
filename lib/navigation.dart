// import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'components/constants.dart';
import 'custom%20widgets/theme.dart';
import 'dashboard%20pages/dashboard.dart';
import 'profile%20pages/profile.dart';

import 'request pages/request.dart';
import 'service pages/service.dart';

class BottomBarNavigation extends StatefulWidget {
  final int valueListenable;
  // final toRequest;
  // final toService;
  const BottomBarNavigation({Key? key, required this.valueListenable})
      : super(key: key);

  @override
  State<BottomBarNavigation> createState() => _BottomBarNavigationState();
}

class _BottomBarNavigationState extends State<BottomBarNavigation> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late int _selectedIndex;

  final List<Widget> _widgetOptions = [
    const DashBoard(),
    const RequestPage(),
    const ServicePage(),
    const ProfilePage(isMyProfile: true)
  ];

  @override
  void initState() {
    if (widget.valueListenable == 0) {
      _selectedIndex = 0;
    } else if (widget.valueListenable == 1) {
      _selectedIndex = 1;
    } else {
      _selectedIndex = 2;
    }
    super.initState();
  }

  onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          //selectedItemColor: Color.fromARGB(255, 91, 71, 189),
          unselectedItemColor: Colors.white,
          //Color.fromARGB(255, 203, 197, 234)
          selectedFontSize: 15,
          unselectedFontSize: 10,
          showUnselectedLabels: true,
          //type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).primaryColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: 'Home',
                backgroundColor: themeData2().primaryColor),
            BottomNavigationBarItem(
                icon: const Icon(Icons.handshake),
                label: 'Need Help',
                backgroundColor: themeData1().primaryColor),
            BottomNavigationBarItem(
                icon: const Icon(Icons.emoji_people),
                label: 'Offer Help',
                backgroundColor: themeData1().secondaryHeaderColor),
            BottomNavigationBarItem(
                icon: const Icon(Icons.account_box),
                label: 'Account',
                backgroundColor: themeData2().primaryColor)
          ],
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
        ),
        body: _widgetOptions.elementAt(_selectedIndex));
  }
}
