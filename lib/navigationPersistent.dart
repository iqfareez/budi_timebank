// import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'components/constants.dart';
import 'custom%20widgets/theme.dart';
import 'dashboard%20pages/dashboard.dart';
import 'profile%20pages/profile.dart';

import 'request pages/request.dart';
import 'service pages/service.dart';

class PersistentBottomNavigationBar extends StatefulWidget {
  const PersistentBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<PersistentBottomNavigationBar> createState() =>
      _PersistentBottomNavigationBarState();
}

class _PersistentBottomNavigationBarState
    extends State<PersistentBottomNavigationBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  int _selectedIndex = 0;
  final session = supabase.auth.currentSession;

  //https://pub.dev/packages/persistent_bottom_nav_bar

  // final List<Widget> _widgetOptions = [
  //   DashBoard(),
  //   RequestPage(),
  //   ServicePage(),
  //   ProfilePage()
  // ];

  List<Widget> _buildScreens() {
    return [
      const DashBoard(),
      const RequestPage(),
      const ServicePage(),
      const ProfilePage(
        isMyProfile: true,
      )
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          CupertinoIcons.home,
          // color: Colors.white,
        ),
        title: ("Home"),

        //routeAndNavigatorSettings: ,
        activeColorSecondary: themeData1().primaryColor,
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.handshake),
        title: ("Need Help?"),
        activeColorSecondary: themeData1().primaryColor,
        activeColorPrimary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.emoji_people),
        title: ("Offer Help?"),
        activeColorSecondary: CupertinoColors.white,
        activeColorPrimary: themeData1().secondaryHeaderColor,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_box),
        title: ("Settings"),
        activeColorSecondary: CupertinoColors.white,
        activeColorPrimary: themeData1().secondaryHeaderColor,
        inactiveColorPrimary: CupertinoColors.white,
      ),
    ];
  }

  @override
  void initState() {
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
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: themeData1().primaryColor, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      // decoration: NavBarDecoration(
      //   borderRadius: BorderRadius.circular(10.0),
      //   colorBehindNavBar: Colors.white,
      // ),

      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style10, // Choose the nav bar style with this property.
    );
  }
}
