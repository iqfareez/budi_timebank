import 'package:flutter/material.dart';
import 'package:testfyp/custom%20widgets/customDivider.dart';
import 'package:testfyp/custom%20widgets/theme.dart';
import 'package:testfyp/request%20pages/requestDetails1.dart';

import '../bin/client_service_request.dart';
import '../bin/client_user.dart';
import '../bin/common.dart';
import '../components/constants.dart';
// import 'requestDetails.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late bool isLoad;
  //late dynamic listRequest;
  late dynamic listFiltered;
  late dynamic listTo;
  late dynamic listFrom;
  late dynamic listRequestName;
  late String user;

  //late bool _isEmpty;

  @override
  void initState() {
    isLoad = true;
    //_isEmpty = true;

    getinstance();
    super.initState();
  }

  Future getinstance() async {
    setState(() {
      isLoad = true;
      // from = 0;
      // to = 6;
    });
    listFiltered = [];
    listTo = [];
    listFrom = [];
    listRequestName = [];
    // dateJob = [];
    user = supabase.auth.currentUser!.id;

    listFiltered =
        await ClientUser(Common().channel).getTransactionHistory(user);

    // listFiltered.sort((a,b)) {

    // }

    for (int i = 0; i < listFiltered.data.length; i++) {
      //print(widget.applicants[i]);
      var name2 = await ClientServiceRequest(Common().channel)
          .getResponseById(listFiltered.data[i].requestId);
      listRequestName.add(name2.request.title);
      var name1 = await ClientUser(Common().channel)
          .getUserById(listFiltered.data[i].to);
      listTo.add(name1.user.name);
      var name = await ClientUser(Common().channel)
          .getUserById(listFiltered.data[i].from);
      listFrom.add(name.user.name);

      // dateJob[i] = DateTime.parse(listFiltered.data[i].timestamp);
    }
    // print(dateJob);
    //print(listRequestName);
    // dynamic user1 = await ClientUser(Common().channel).getUserById(user);
    // print(user1);
    //print(listFiltered);
    setState(() {
      isLoad = false;
      //isEmpty();
    });
    //print(listRequest.requests.length);
  }

  String getTimeStamp(timeStamp) {
    dynamic dateJob;
    dateJob = DateTime.parse(timeStamp);
    return 'Date: ${dateJob.day}/${dateJob.month}/${dateJob.year} Time: ${dateJob.hour}:${dateJob.minute}:${dateJob.second}';
  }

  bool isReceived(id) {
    final user = supabase.auth.currentUser!.id;

    if (id == user) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Transaction Page'),
          backgroundColor: themeData1().primaryColor),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : listFiltered.data.isEmpty
              ? RefreshIndicator(
                  onRefresh: getinstance,
                  child: const Center(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Text(
                        'No Transactions done',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: RefreshIndicator(
                    onRefresh: getinstance,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      //controller: _scrollController,
                      itemCount: listFiltered.data.length,
                      itemBuilder: (context, index) {
                        //if (index < listFiltered.length) {
                        return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => RequestDetails1(
                                          requestId: listFiltered
                                              .data[index].requestId,
                                          isRequest: isReceived(
                                              listFiltered.data[index].to),
                                          user: user)))
                                  .then((value) => setState(
                                        () {
                                          getinstance();
                                        },
                                      ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.work_outline_rounded,
                                              size: 25),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                listRequestName[index]
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  // Text(
                                                  //   'From: ',
                                                  //   style: TextStyle(
                                                  //       fontSize: 14,
                                                  //       fontWeight: FontWeight.bold),
                                                  // ),
                                                  Text(
                                                    listFrom[index].toString(),
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_right_alt_rounded,
                                                    size: 17,
                                                  ),
                                                  // Text(
                                                  //   'To: ',
                                                  //   style: TextStyle(
                                                  //       fontSize: 14,
                                                  //       fontWeight: FontWeight.bold),
                                                  // ),
                                                  Text(
                                                    listTo[index].toString(),
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            listFiltered.data[index].amount
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: isReceived(listFiltered
                                                        .data[index].to)
                                                    ? Colors.red
                                                    : Colors.green),
                                          ),
                                          const Text(
                                            ' Time/Hour',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Completed On:',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    getTimeStamp(
                                        listFiltered.data[index].timestamp),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  CustomDivider(
                                      color: themeData1().primaryColor)
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                ),
    );
  }
}
