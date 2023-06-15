import 'package:flutter/material.dart' hide Badge;
import 'package:testfyp/service%20pages/available_service.dart';
import 'package:testfyp/service%20pages/completedService.dart';
import 'package:testfyp/service%20pages/yourServices.dart';
import 'package:badges/badges.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              bottom:
                  TabBar(indicatorColor: Theme.of(context).primaryColor, tabs: const [
                Badge(
                    showBadge: false,
                    badgeContent: Text('!'),
                    badgeAnimation: BadgeAnimation.scale(
                        animationDuration: Duration(milliseconds: 100)),
                    child: Tab(text: 'Available\n\tRequest')),
                Tab(text: 'Ongoing\nRequest'),
                Tab(text: 'Completed\n\t\tRequest')
              ]),
              // backgroundColor: Color.fromARGB(255, 127, 17, 224),
              title: const Text('Want to help other people?'),
            ),
            body: const TabBarView(
              children: [
                AvailableServices(),
                YourServices(),
                CompletedServices()
              ],
            )));
  }
}
