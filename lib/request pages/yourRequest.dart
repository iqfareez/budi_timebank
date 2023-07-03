import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom widgets/customCardServiceRequest.dart';
import '../custom%20widgets/theme.dart';
import '../db_helpers/client_service_request.dart';
import '../model/service_request.dart';
import 'requestDetails.dart';
import 'requestForm.dart';

class YourRequest extends StatefulWidget {
  const YourRequest({Key? key}) : super(key: key);

  @override
  State<YourRequest> createState() => _YourRequestState();
}

class _YourRequestState extends State<YourRequest> {
  late String userUid;
  late bool isLoad;
  //late dynamic listRequest;
  bool isRequest = true;
  late Future<List<ServiceRequest>> listRequestFuture;

  @override
  void initState() {
    super.initState();
    listRequestFuture = ClientServiceRequest.getPendingRequests();
    userUid = FirebaseAuth.instance.currentUser!.uid;
  }

  isRequested(list) {
    if (list.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<ServiceRequest>>(
            future: listRequestFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.isEmpty) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Need help from other people?\nRequest help to let people know...',
                          textAlign: TextAlign.center,
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 0),
                            alignment: Alignment.center,
                            child: Image.asset(
                              'asset/Team spirit-amico.png',
                              height: MediaQuery.of(context).size.height / 2.3,
                            )),
                      ],
                    ),
                  ),
                );
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.2,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => RequestDetails(
                                    requestId: snapshot.data![index].id!,
                                    user: userUid)))
                            .then((value) => setState(
                                  () {
                                    listRequestFuture;
                                  },
                                ));
                      },
                      child: CustomCardServiceRequest(
                        category: snapshot.data![index].category,
                        location: snapshot.data![index].location,
                        // ['state'],
                        date: snapshot.data![index].date,
                        // TODO: aku tak faham apa kaitan applicants dgn status
                        status: snapshot.data![index].status,
                        // status: isRequested(
                        //   snapshot.data![index].applicants,
                        // ).toString(),
                        requestorId: snapshot.data![index].requestorId,
                        title: snapshot.data![index].title,
                        rate: snapshot.data![index].rate.toString(),
                      ),
                    );
                  },
                ),
              );
            }),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: themeData1().primaryColor,
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequestForm(),
                ));
            setState(() {
              listRequestFuture = ClientServiceRequest.getPendingRequests();
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Request'),
        ));
  }
}
