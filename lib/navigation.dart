// import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'components/constants.dart';
import 'dashboard%20pages/dashboard.dart';
import 'profile%20pages/profile.dart';
import 'request pages/request.dart';
import 'service pages/service.dart';

class BottomBarNavigation extends StatefulWidget {
  const BottomBarNavigation({Key? key}) : super(key: key);

  @override
  State<BottomBarNavigation> createState() => _BottomBarNavigationState();
}

class _BottomBarNavigationState extends State<BottomBarNavigation> {
  int _selectedIndex = 0;
  //bool _redirecting = false;
  final session = supabase.auth.currentSession;
  //late final StreamSubscription<AuthState> _authStateSubscription;

  final List<Widget> _widgetOptions = [
    const DashBoard(),
    const RequestPage(),
    const ServicePage(),
    const ProfilePage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    // _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
    //   if (_redirecting) return;
    //   final session = data.session;
    //   final AuthChangeEvent event = data.event;
    //   if (event == AuthChangeEvent.passwordRecovery && session != null) {
    //     // handle signIn
    //     Navigator.of(context).pushReplacementNamed('/passwordReset');
    //   }

    //   // if (session != null) {
    //   //   _redirecting = true;
    //   //   Navigator.of(context).pushReplacementNamed('/passwordReset');
    //   // }
    // });
    super.initState();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   //_authStateSubscription.cancel();
  //   super.dispose();
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: const Color.fromARGB(255, 234, 234, 234),
          selectedItemColor: const Color.fromARGB(255, 203, 197, 234),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 127, 17, 224),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.request_page), label: 'Request'),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment), label: 'Services'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: 'Account')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ));
  }
}
