import 'package:flutter/material.dart';

import '../custom widgets/customHeadline.dart';
import '../custom%20widgets/theme.dart';
import '../db_helpers/client_user.dart';
import '../rate pages/rateReceived.dart';
import '../rate%20pages/rateGiven.dart';
import '../transactions%20pages/transaction.dart';
import 'request_dashboard_content.dart';
import 'service_dashboard_content.dart';
import 'x_dashboard_card.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // late final double credit;
  // late final data;
  late final double points;
  // late final data1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCredit();
    //Future.delayed(Duration.zero, getCredit);
  }

  getCredit() async {
    setState(() {
      isLoading = true;
    });

    points = await ClientUser.getTotalPoints();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: themeData2().primaryColor,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        //elevation: 5,
                        color: themeData1().primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white),
                                    child: Icon(
                                      Icons.wallet,
                                      color: themeData1().primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Time Balance',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                  // TODO: Check what is data reserved?
                                  // 'Time/hour: ${(data.total - data.reserved).toStringAsFixed(2)}',
                                  'Time/hour: ${points.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            )
                          ],
                        )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: XDashboardCard(
                          title: "Your Request",
                          borderColor: themeData1().primaryColor,
                          navBarIndex: 1,
                          content: const RequestDashboardContent(),
                        ),
                      ),
                      Expanded(
                        child: XDashboardCard(
                          title: "Your Service",
                          borderColor: themeData1().secondaryHeaderColor,
                          navBarIndex: 2,
                          content: const ServiceDashboardContent(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  //CustomDivider(),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: CustomHeadline(heading: 'Services'),
                  ),
                  Expanded(
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Card(
                                    //elevation: 5,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    color: themeData1().primaryColor,
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TransactionPage()));
                                        },
                                        child: const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.receipt_long,
                                                color: Colors.white),
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                  'View Transaction History',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  // style: Theme.of(context)
                                                  //     .textTheme
                                                  //     .headline1,
                                                  ),
                                            ),
                                            //SizedBox(height: 10),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text(
                                                'Keep your balance in check',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            //SizedBox(height: 10),
                                            // Ink.image(
                                            //   image: AssetImage('asset/folder.png'),
                                            //   height: 40,
                                            //   width: 40,
                                            // ),
                                          ],
                                        )),
                                  ),
                                ),
                              ]),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: themeData1().primaryColor,
                                      width: 3,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                  ),
                                  //elevation: 5,
                                  //color: Color.fromARGB(255, 234, 234, 234),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RateGivenPage()));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.rate_review,
                                              color: themeData1().primaryColor),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              'Rate Given',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: themeData1()
                                                      .primaryColor),
                                              textAlign: TextAlign.center,
                                              //Theme.of(context).textTheme.headline1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0),
                                            child: Text(
                                              'Give feedback to other people',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: themeData1()
                                                      .primaryColor),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          // Image.asset('asset/Rate given.png')
                                        ],
                                      )),
                                ),
                              ),
                              //SizedBox(height: 15),
                              Flexible(
                                flex: 1,
                                child: Card(
                                  //elevatio n: 5,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  color: themeData1().secondaryHeaderColor,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RateReceivedPage()));
                                      },
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.thumbs_up_down,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              'Received Rating',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                              // style:
                                              //Theme.of(context).textTheme.headline1,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 7.0),
                                            child: Text(
                                              'See what other people thinks about you',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
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
                  const SizedBox(height: 10)
                ],
              ),
      ),
    );
  }
}
