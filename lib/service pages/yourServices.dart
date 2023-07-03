import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom widgets/customCardServiceRequest.dart';
import '../db_helpers/client_service_request.dart';
import '../model/service_request.dart';
import 'job_details.dart';

class YourServices extends StatefulWidget {
  const YourServices({Key? key}) : super(key: key);

  @override
  State<YourServices> createState() => _YourServicesState();
}

class _YourServicesState extends State<YourServices> {
  late bool isLoad;
  late List<ServiceRequest> listFiltered;
  late String user;

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
    user = FirebaseAuth.instance.currentUser!.uid;

    var data = await ClientServiceRequest.getMyOngoingServices();

    setState(() {
      listFiltered = data;
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : listFiltered.isEmpty
              ? RefreshIndicator(
                  onRefresh: getinstance,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'What to help other people?\ntry to apply job in the next tab. At the moment, you have no ongoing services... ',
                            textAlign: TextAlign.center,
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 0),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'asset/help.png',
                                height:
                                    MediaQuery.of(context).size.height / 2.3,
                              )),
                        ],
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
                      itemCount: listFiltered.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => JobDetails(
                                        requestId: listFiltered[index].id!,
                                        user: user)))
                                .then((value) => setState(
                                      () {
                                        getinstance();
                                      },
                                    ));
                          },
                          child: CustomCardServiceRequest(
                            category: listFiltered[index].category,
                            location: listFiltered[index].location,
                            date: listFiltered[index].date,
                            status: listFiltered[index].status,
                            requestorId: listFiltered[index].requestorId,
                            title: listFiltered[index].title,
                            rate: listFiltered[index].rate.toString(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
