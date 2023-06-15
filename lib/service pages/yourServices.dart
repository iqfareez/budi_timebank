import 'package:flutter/material.dart';

import '../components/constants.dart';
import '../custom widgets/customCardServiceRequest.dart';
import '../request pages/requestDetails1.dart';

class YourServices extends StatefulWidget {
  const YourServices({Key? key}) : super(key: key);

  @override
  State<YourServices> createState() => _YourServicesState();
}

class _YourServicesState extends State<YourServices> {
  late bool isLoad;
  // late dynamic listRequest;
  late dynamic listFiltered;
  late String user;
  late bool _isEmpty;
  //bool isRequest = false;
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

  void fetch() async {
    //setState(() {});
    from += 7;
    to += 7;
    // print('from ' + from.toString());
    // print('to ' + to.toString());
    final data1;
    //print('fetching data...');

    data1 = await supabase
        .from('service_requests')
        .select()
        .eq('requestor', user)
        .eq('applicants', []).range(from, to);

    // final data1 = await supabase
    //     .from('service_requests')
    //     .select()
    //     .neq('requestor', user)
    //     .range(from, to);
    setState(() {
      listFiltered.addAll(data1);
    });

    //print('new added list $listFiltered');
    // print(listFiltered);
    // print(listFiltered.length);
  }

  Future getinstance() async {
    setState(() {
      isLoad = true;
      from = 0;
      to = 6;
    });
    listFiltered = [];
    user = supabase.auth.currentUser!.id;

    listFiltered.addAll(await supabase
        .from('service_requests')
        .select()
        .or('state.eq.1,state.eq.2')
        .eq('provider', user)
        .range(from, to));
    data = await supabase
        .from('service_requests')
        .select()
        .or('state.eq.1,state.eq.2')
        .eq('provider', user);

    finalCount = data.length;
    //print(listRequest);
    setState(() {
      isLoad = false;
      isEmpty();
    });
    //print(listRequest.requests.length);
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
                              state: changeState(listFiltered[index]['state']),
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
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Color.fromARGB(255, 127, 17, 224),
      //   onPressed: () async {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => RequestForm(),
      //         )).then((value) => setState(
      //           () {
      //             getinstance();
      //           },
      //         ));
      //   },
      //   icon: Icon(Icons.add),
      //   label: Text('Add Request'),
      // )
    );
  }
}
