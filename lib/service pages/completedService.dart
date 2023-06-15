import 'package:flutter/material.dart';
import '../components/constants.dart';
import '../custom widgets/customCardServiceRequest.dart';
import '../request pages/requestDetails1.dart';

class CompletedServices extends StatefulWidget {
  const CompletedServices({Key? key}) : super(key: key);

  @override
  State<CompletedServices> createState() => _CompletedServicesState();
}

class _CompletedServicesState extends State<CompletedServices> {
  late bool isLoad;
  //late dynamic listRequest;
  late dynamic listFiltered;
  late dynamic listRating;
  late String user;
  late bool _isEmpty;
  bool isRequest = true;
  //for pagination
  late int from;
  late int to;
  late int finalCount;
  late dynamic data;
  //for listview controller;
  final _scrollController = ScrollController();

  @override
  void initState() {
    isLoad = true;
    _isEmpty = true;
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          fetch();
          // from += 5;
          // to += 5;

        }
      },
    );
    getinstance();
    super.initState();
  }

  Future getinstance() async {
    setState(() {
      isLoad = true;
      from = 0;
      to = 6;
    });
    listFiltered = [];
    listRating = [];

    user = supabase.auth.currentUser!.id;
    listFiltered.addAll(await supabase
        .from('service_requests')
        .select()
        .eq('provider', user)
        .eq('state', 3)
        .range(from, to));
    data = await supabase
        .from('service_requests')
        .select()
        .eq('state', 3)
        .eq('provider', user);

    listRating.addAll(await supabase
        .from('ratings')
        .select()
        .eq('recipient', user)
        .range(from, to));

    finalCount = data.length;

    //print(listRequest);
    setState(() {
      isLoad = false;
      isEmpty();
    });
    //print(listRequest.requests.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  changeState(state) {
    switch (state) {
      case 0:
        return 'Pending';
      case 1:
        return 'Accepted';
      case 2:
        return 'Ongoing';
      case 3:
        return 'Completed';
      case 4:
        return 'Aborted';
    }
  }

  isRated(jobId) {
    if (listRating.toString().contains(jobId)) {
      return true;
    } else {
      return false;
    }
  }

  bool isEmpty() {
    if (listFiltered.length == 0) {
      _isEmpty = true;
      return _isEmpty;
    } else {
      _isEmpty = false;
      return _isEmpty;
    }
  }

  void fetch() async {
    from += 7;
    to += 7;

    final data1;
    final ratingData;

    data1 = await supabase
        .from('service_requests')
        .select()
        .eq('requestor', user)
        .eq('applicants', []).range(from, to);

    ratingData = await supabase
        .from('ratings')
        .select()
        .eq('recipient', user)
        .range(from, to);

    setState(() {
      listRating.addAll(ratingData);
      listFiltered.addAll(data1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : _isEmpty
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
                      controller: _scrollController,
                      itemCount: listFiltered.length + 1,
                      itemBuilder: (context, index) {
                        if (index < listFiltered.length) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => RequestDetails1(
                                          requestId: listFiltered[index]['id'],
                                          isRequest: false,
                                          user: user)))
                                  .then((value) => setState(
                                        () {
                                          getinstance();
                                        },
                                      ));
                            },
                            child: CustomCardServiceRequest(
                              category: listFiltered[index]['category'],
                              location: listFiltered[index]['location']
                                  ['state'],
                              date: listFiltered[index]['date'],
                              state: isRated(listFiltered[index]['id'])
                                  ? 'Completed (Rated)'
                                  : 'Completed (Unrated)',
                              requestor: listFiltered[index]['requestor'],
                              title: listFiltered[index]['title'],
                              rate: listFiltered[index]['rate'],
                            ),
                          );
                        } else {
                          if (finalCount < 6) {
                            return const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text('No more request...'),
                            );
                          }
                          if (finalCount < from) {
                            return const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text('No more request...'),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }
                      },
                    ),
                  ),
                ),
    );
  }
}
