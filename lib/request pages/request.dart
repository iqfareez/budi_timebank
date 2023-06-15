import 'package:flutter/material.dart';
import 'completedRequest.dart';
import 'requestedJob.dart';
import 'yourRequest.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Color.fromARGB(255, 245, 167, 44),
          bottom: TabBar(
              indicatorColor: Theme.of(context).secondaryHeaderColor,
              tabs: const [
                Tab(text: '\t\t\tYour\nRequest'),
                Tab(text: 'Applied\nRequest'),
                Tab(text: 'Completed\n\t\t Request')
              ]),
          title: const Text('Need help from other people?'),
        ),
        body: const TabBarView(
            children: [YourRequest(), RequestedJob(), CompletedRequest()]),
      ),
    );
  }
}
