import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../db_helpers/client_service_request.dart';
import '../model/service_request.dart';
import 'requestDetails.dart';
import '../custom widgets/customCardServiceRequest.dart';

class CompletedRequest extends StatefulWidget {
  const CompletedRequest({Key? key}) : super(key: key);

  @override
  State<CompletedRequest> createState() => _CompletedRequestState();
}

class _CompletedRequestState extends State<CompletedRequest> {
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

  isRated(jobId) {
    if (listRating.toString().contains(jobId)) {
      return true;
    } else {
      return false;
    }
  }

  Future getinstance() async {
    setState(() => isLoad = true);

    var completedReqs = await ClientServiceRequest.getCompletedRequest();
    // TODO: Implement rating

    // listRating.addAll(await supabase
    //     .from('ratings')
    //     .select()
    //     .eq('author', user)
    //     .range(from, to));

    setState(() {
      data = completedReqs;
      isLoad = false;
    });
    //print(listRequest.requests.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'All completed request will be listed here, remember to declare the job to "Completed". No completed requests...',
                      textAlign: TextAlign.center,
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 0),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'asset/Business deal-pana.png',
                          height: MediaQuery.of(context).size.height / 2.3,
                        )),
                  ],
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
                                    builder: (context) => RequestDetails(
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
                            // status: isRated(listFiltered[index].id)
                            //     ? 'Completed (Rated)'
                            //     : 'Completed (Unrated)',
                            // TODO: implement rated/notrated
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
