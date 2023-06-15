import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../bin/client_user.dart';
import '../bin/common.dart';
import '../custom%20widgets/theme.dart';
import 'serviceDashboardCard.dart';
import '../navigation.dart';
import '../rate%20pages/rateGiven.dart';
import '../transactions%20pages/transaction.dart';
import '../components/constants.dart';
import '../custom widgets/customHeadline.dart';
import '../rate pages/rateReceived.dart';

class DashBoard extends StatefulWidget {
  final onTapped;
  const DashBoard({Key? key, this.onTapped}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late final credit;
  late final data;
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
    final user = supabase.auth.currentUser!.id;
    //print(user);
    data = await ClientUser(Common().channel).getUserCreditBalance(user);
    // data1 = await ClientUser(Common().channel).getTransactionHistory(user);
    //print(data1.toString());

    //print(data);

    // data = await supabase
    //     .from('user_credits')
    //     .select()
    //     .eq('user_id', user)
    //     .single() as Map;

    setState(() {
      isLoading = false;
    });
    //print(data!['total']);
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
                                  'Time/hour: ${(data.total - data.reserved).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            )
                          ],
                        )),
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: themeData1().primaryColor,
                              width: 3,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          //elevation: 5,
                          child: InkWell(
                            onTap: () {
                              //d_onItemTapped
                              Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                  //fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      const BottomBarNavigation(
                                          valueListenable: 1),
                                ),
                              );

                              // Navigator.of(context).pushReplacement(
                              //   CupertinoPageRoute(
                              //     builder: (BuildContext context) {
                              //       return RequestPage();
                              //     },
                              //   ),
                              // );
                              //Navigator.of(context).pushNamed('/request');
                              // PersistentNavBarNavigator.pushNewScreen(
                              //   context,
                              //   screen: RequestPage(),
                              //   //settings: Navigator.pushNamed(),
                              //   withNavBar:
                              //       true, // OPTIONAL VALUE. True by default.
                              //   pageTransitionAnimation:
                              //       PageTransitionAnimation.cupertino,
                              // );
                            },
                            child: const Column(
                              children: [
                                CustomHeadline(heading: 'Your Request'),
                                ServiceDashboardCard(isRequest: true)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: themeData1().secondaryHeaderColor,
                              width: 3,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          //elevation: 5,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                CupertinoPageRoute(
                                  //fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      const BottomBarNavigation(
                                          valueListenable: 2),
                                ),
                                // MaterialPageRoute(
                                //   builder: (context) => BottomBarNavigation(
                                //         valueListenable: 2,
                                //       ))
                              );
                            },
                            child: const Column(
                              children: [
                                CustomHeadline(heading: 'Your Service'),
                                ServiceDashboardCard(isRequest: false)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
