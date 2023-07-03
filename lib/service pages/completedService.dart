import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom widgets/customCardServiceRequest.dart';
import '../db_helpers/client_service_request.dart';
import '../model/service_request.dart';
import 'job_details.dart';

class CompletedServices extends StatefulWidget {
  const CompletedServices({Key? key}) : super(key: key);

  @override
  State<CompletedServices> createState() => _CompletedServicesState();
}

class _CompletedServicesState extends State<CompletedServices> {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  late bool isLoad;
  late List<ServiceRequest> data;
  late dynamic listRating;
  bool isRequest = true;

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

    var completedServices = await ClientServiceRequest.getCompletedServices();

    // listFiltered.addAll(await supabase
    //     .from('service_requests')
    //     .select()
    //     .eq('provider', user)
    //     .eq('state', 3)
    //     .range(from, to));
    // data = await supabase
    //     .from('service_requests')
    //     .select()
    //     .eq('state', 3)
    //     .eq('provider', user);

    // listRating.addAll(await supabase
    //     .from('ratings')
    //     .select()
    //     .eq('recipient', user)
    //     .range(from, to));

    setState(() {
      data = completedServices;
      isLoad = false;
    });
  }

  isRated(jobId) {
    if (listRating.toString().contains(jobId)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
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
                            'When you service/help is completed, the job will be listed here. No completed job yet...',
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 0),
                            alignment: Alignment.center,
                            child: Image.asset(
                              'asset/completed_job.png',
                              height: MediaQuery.of(context).size.height / 2.3,
                            ),
                          ),
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
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => JobDetails(
                                        requestId: data[index].id!,
                                        user: currentUserUid)))
                                .then((value) => setState(
                                      () {
                                        getinstance();
                                      },
                                    ));
                          },
                          child: CustomCardServiceRequest(
                            category: data[index].category,
                            location: data[index].location,
                            date: data[index].date,
                            // status: isRated(listFiltered[index].id!)
                            //     ? 'Completed (Rated)'
                            //     : 'Completed (Unrated)',
                            status: data[index].status,
                            requestorId: data[index].requestorId,
                            title: data[index].title,
                            rate: data[index].rate.toString(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
