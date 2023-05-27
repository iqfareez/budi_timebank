import 'package:flutter/material.dart';
import '../custom widgets/custom_headline.dart';
import '../custom widgets/custom_ongoing_task.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List listService = [
    'Service 1',
    'Service 2',
    'Service 3',
    'Service 4',
    'Service 5',
    'Service 6',
    'Service 8',
  ];
  List listRequest = [
    'Request 1',
    'Request 2',
    'Request 3',
    'Request 4',
    'Request 5',
    'Request 6',
    'Request 8',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        // backgroundColor: Color.fromARGB(255, 127, 17, 224),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeadline('Your Service'),
            CustomOngoingTask(listService),
            const CustomHeadline('Your Request'),
            CustomOngoingTask(listRequest),
            const SizedBox(
              height: 10,
            ),
            const Card(
                elevation: 5,
                color: Color.fromARGB(255, 219, 216, 233),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Time Balance',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 24, 54, 66)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('\$time/hour: 15.50',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 24, 54, 66))),
                    )
                  ],
                )),
            const Divider(
                //horizontal line
                height: 30,
                thickness: 2,
                indent: 20,
                endIndent: 20),
            Expanded(
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 5,
                            color: const Color.fromARGB(255, 234, 234, 234),
                            child: InkWell(
                                onTap: () {},
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text('Find a service request',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)
                                          // style: Theme.of(context)
                                          //     .textTheme
                                          //     .headline1,
                                          ),
                                    ),
                                    //SizedBox(height: 10),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child:
                                          Text('Help others with your skills'),
                                    ),
                                    //SizedBox(height: 10),
                                    Ink.image(
                                      image:
                                          const AssetImage('asset/folder.png'),
                                      height: 40,
                                      width: 40,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ]),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Card(
                            elevation: 5,
                            color: const Color.fromARGB(255, 234, 234, 234),
                            child: InkWell(
                                onTap: () {},
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Make a request',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      //Theme.of(context).textTheme.headline1,
                                    ),
                                    Text(
                                      'Let others help you',
                                      style: TextStyle(fontSize: 13),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )),
                          ),
                        ),
                        //SizedBox(height: 15),
                        Flexible(
                          flex: 1,
                          child: Card(
                            elevation: 5,
                            color: const Color.fromARGB(255, 234, 234, 234),
                            child: InkWell(
                                onTap: () {},
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Transaction History',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      // style:
                                      //Theme.of(context).textTheme.headline1,
                                    ),
                                    Text(
                                      'View previous transactions',
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
