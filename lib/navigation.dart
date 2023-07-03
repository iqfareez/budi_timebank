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
  // late Common _common;
  // late bool isLoad;
  // late dynamic listRequest;
  // late dynamic listFiltered;
  // late final user;
  // late String _userCurrent;
  // late bool _isEmpty;

  // //registered user (budi)
  // final ammar = 'f53809c5-68e6-480c-902e-a5bc3821a003';
  // final evergreen = '06a7a82f-b04f-4111-b0c9-a92d918d3207';
  // final ujaiahmad = '291b79a7-c67c-4783-b004-239cb334804d';

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late int _selectedIndex;

  final List<Widget> _widgetOptions = [
    const DashBoard(),
    const RequestPage(),
    const ServicePage(),
    const ProfilePage(
      isMyProfile: true,
    )
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
    // widget.toRequest ? _selectedIndex = 1 : _selectedIndex = 0;
    // widget.toService ? _selectedIndex = 2 : _selectedIndex = 0;
    // _common = Common();
    // isLoad = true;
    // _isEmpty = true;
    // getinstance();
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
          // selectedLabelStyle: ,
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
        body: _widgetOptions.elementAt(_selectedIndex)
        //   Navigator(
        //   initialRoute: '/dashboard',
        //   onGenerateRoute: (settings) {
        //     Widget page = DashBoard();
        //     //if (tabItem == )
        //     if (settings.name == '/service') page = ServicePage();
        //     if (settings.name == '/request') page = RequestPage();
        //     return MaterialPageRoute(builder: (_) => page);
        //   },
        // )
        // Container(
        //   child: ,
        // )
        );
  }
}
