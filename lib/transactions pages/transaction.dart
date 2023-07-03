import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom widgets/custom_divider.dart';
import '../custom%20widgets/theme.dart';
import '../db_helpers/client_service_request.dart';
import '../db_helpers/client_user.dart';
import '../extension_string.dart';
import '../model/earnings_history.dart';
import '../model/profile.dart';
import '../request pages/requestDetails.dart';

class _MyEarningHistory {
  EarningsHistory earningsHistory;
  String jobTitle;
  bool isReceived; // to paint the text red/green
  Profile? senderProfile; //from
  Profile? receiverProfile; //to
  String? senderUid;
  String? receiverUid;

  _MyEarningHistory({
    required this.earningsHistory,
    required this.jobTitle,
    required this.isReceived,
    // Profiles is used to display user name (if applicable)
    this.senderProfile,
    this.receiverProfile,
    // id is used to check current user
    this.senderUid,
    this.receiverUid,
  });
}

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late bool isLoad;
  late List<_MyEarningHistory> myEarningsHistory;

  @override
  void initState() {
    isLoad = true;

    getinstance();
    super.initState();
  }

  Future getinstance() async {
    setState(() {
      isLoad = true;
    });

    var earningsData = await ClientUser.getUserEarningsHistory();
    List<_MyEarningHistory> myEarnHistories = [];

    for (var earningData in earningsData) {
      Profile? receiveProfile, senderProfile;
      String? senderUid, receiverUid;
      bool isReceived = false;
      var receiveIdData = earningData.to;
      if (receiveIdData.startsWith('id:')) {
        receiverUid = receiveIdData.replaceFirst('id:', '');
        var profile = await ClientUser.getUserProfileById(receiverUid);
        receiveProfile = profile;
        isReceived = receiverUid == FirebaseAuth.instance.currentUser!.uid;
      } else {
        receiveProfile = null;
      }

      var senderIdData = earningData.from;
      if (senderIdData.startsWith('id:')) {
        senderUid = senderIdData.replaceFirst('id:', '');
        var profile = await ClientUser.getUserProfileById(senderUid);
        senderProfile = profile;
      } else {
        senderProfile = null;
      }

      var extractedJobId = extractJobId(earningData.reason);
      String? jobTitle;

      if (extractedJobId != null) {
        // the job id is valid, then, fetch the job details
        var job =
            await ClientServiceRequest.getServiceRequestById(extractedJobId);
        jobTitle = job.title;
      } else {
        // not a job id, then simply display the reason
        jobTitle = earningData.reason;
      }

      myEarnHistories.add(_MyEarningHistory(
          jobTitle: jobTitle.titleCase(),
          earningsHistory: earningData,
          isReceived: isReceived,
          senderProfile: senderProfile,
          receiverProfile: receiveProfile,
          senderUid: senderUid,
          receiverUid: receiverUid));
    }

    setState(() {
      isLoad = false;
      myEarningsHistory = myEarnHistories;
    });
  }

  String getTimeStamp(DateTime timestamp) {
    return 'Date: ${timestamp.day}/${timestamp.month}/${timestamp.year} Time: ${timestamp.hour}:${timestamp.minute}:${timestamp.second}';
  }

  String? extractJobId(String transactionReason) {
    if (!transactionReason.startsWith("job:")) return null;

    var id = transactionReason.replaceFirst('job:', '');
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Transaction Page'),
          backgroundColor: themeData1().primaryColor),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : myEarningsHistory.isEmpty
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
                      itemCount: myEarningsHistory.length,
                      itemBuilder: (context, index) {
                        // Give value to receiverName and senderName based on the data
                        // Possible values: You, System, <User Name>
                        String receiverName, senderName;

                        if (myEarningsHistory[index].receiverProfile == null) {
                          receiverName = "System";
                        } else {
                          if (myEarningsHistory[index].receiverUid ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            receiverName = "You";
                          } else {
                            receiverName =
                                myEarningsHistory[index].receiverProfile!.name;
                          }
                        }

                        if (myEarningsHistory[index].senderProfile == null) {
                          senderName = "System";
                        } else {
                          if (myEarningsHistory[index].senderUid ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            senderName = "You";
                          } else {
                            senderName =
                                myEarningsHistory[index].senderProfile!.name;
                          }
                        }

                        return InkWell(
                            onTap: () {
                              var jobId = extractJobId(myEarningsHistory[index]
                                  .earningsHistory
                                  .reason);

                              if (jobId == null) return;
                              // return the determine the isRequest
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                    builder: (context) => RequestDetails(
                                        requestId: jobId,
                                        user: FirebaseAuth
                                            .instance.currentUser!.uid),
                                  ))
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
                                                myEarningsHistory[index]
                                                    .jobTitle,
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
                                                    senderName,
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
                                                    receiverName,
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
                                            myEarningsHistory[index]
                                                .earningsHistory
                                                .amount
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: !myEarningsHistory[index]
                                                        .isReceived
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
                                    getTimeStamp(myEarningsHistory[index]
                                        .earningsHistory
                                        .date),
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
