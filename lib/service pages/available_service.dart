import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom widgets/custom_card_service_request.dart';
import '../custom%20widgets/theme.dart';
import '../db_helpers/client_service_request.dart';
import '../model/service_request.dart';
import 'job_details.dart';

class AvailableServices extends StatefulWidget {
  const AvailableServices({Key? key}) : super(key: key);

  @override
  State<AvailableServices> createState() => _AvailableServicesState();
}

class _AvailableServicesState extends State<AvailableServices> {
  late bool isLoad;
  // late dynamic listRequest;
  late List<ServiceRequest> listFiltered;
  late dynamic _userCurrent;
  late String user;

  final _categoryController = TextEditingController();
  final _stateController = TextEditingController();
  final _filterController = TextEditingController();

  List<String> listFilter = <String>[
    'Category',
    'State',
  ];

  List<String> listCategories = <String>[
    'All Categories',
    'Arts, Crafts & Music',
    'Business Services',
    'Community Activities',
    'Companionship',
    'Education',
    'Help at Home',
    'Recreation',
    'Transportation',
    'Wellness',
  ];

  List<String> listState = <String>[
    'Malaysia',
    'Kuala Lumpur',
    'Kelantan',
    'Kedah',
    'Johor',
    'labuan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Putrajaya',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
  ];

  @override
  void initState() {
    _categoryController.text = listCategories[0];
    _stateController.text = listState[0];
    _filterController.text = listFilter[0];
    super.initState();

    getinstance();
  }

  Future getinstance() async {
    setState(() {
      isLoad = true;
    });
    user = FirebaseAuth.instance.currentUser!.uid;

    var documents = await ClientServiceRequest.getMyAvailableServices();

    //_filter..by = 'state'..value = '0';
    // print('from ' + from.toString());
    // print('to ' + to.toString());
    if (_categoryController.text == 'All Categories' &&
        _stateController.text == listState[0]) {
      // listFiltered.addAll(await supabase
      //     .from('service_requests')
      //     .select()
      //     .neq('requestor', user)
      //     .eq('state', 0)
      //     .range(from, to));

      // data = await supabase
      //     .from('service_requests')
      //     .select()
      //     .eq('state', 0)
      //     .neq('requestor', user);
      // TODO: implement this part requester name
    } else if (_categoryController.text == 'All Categories' &&
        _stateController.text != listState[0]) {
      // listFiltered.addAll(await supabase
      //     .from('service_requests')
      //     .select()
      //     .neq('requestor', user)
      //     .eq('state', 0)
      //     .eq('location->>state', _stateController.text)
      //     .range(from, to));
      // TODO: implement this part requester name

      // data = await supabase
      //     .from('service_requests')
      //     .select()
      //     .neq('requestor', user)
      //     .eq('state', 0)
      //     .eq('location->>state', _stateController.text);
      // TODO: implement this part requester name
    } else if (_categoryController.text != 'All Categories' &&
        _stateController.text == listState[0]) {
      // listFiltered.addAll(await supabase
      //     .from('service_requests')
      //     .select()
      //     .neq('requestor', user)
      //     .eq('state', 0)
      //     .eq('category', _categoryController.text)
      //     .range(from, to));
      // TODO: implement this part requester name

      // data = await supabase
      //     .from('service_requests')
      //     .select()
      //     .neq('requestor', user)
      //     .eq('state', 0)
      //     .eq('category', _categoryController.text);
      // TODO: implement this part requester name

      // .like('location', '%${_stateController.text.toString()}%')
    } else if (_categoryController.text != 'All Categories' &&
        _stateController.text != listState[0]) {
      // listFiltered.addAll(await supabase
      //     .from('service_requests')
      //     .select()
      //     .neq('requestor', user)
      //     .eq('state', 0)
      //     .eq('category', _categoryController.text)
      //     .eq('location->>state', _stateController.text)
      //     .range(from, to));
      // TODO: implement this part requester name

      // data = await supabase
      //     .from('service_requests')
      //     .select()
      //     .neq('requestor', user)
      //     .eq('state', 0)
      //     .eq('category', _categoryController.text)
      //     .eq('location->>state', _stateController.text);
      // TODO: implement this part requester name
    }

    setState(() {
      listFiltered = documents;
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 50),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Icon(
                      //         Icons.tune,
                      //         color: themeData1().secondaryHeaderColor,
                      //       ),
                      //       const SizedBox(width: 3),
                      //       Container(
                      //         alignment: Alignment.center,
                      //         //margin: EdgeInsets.all(8),
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(15),
                      //             border: Border.all(
                      //               color: Theme.of(context)
                      //                   .secondaryHeaderColor,
                      //               width: 2,
                      //             )),
                      //         child: DropdownButton<String>(
                      //           underline: Container(
                      //             height: 0,
                      //           ),
                      //           iconEnabledColor: Colors.black,
                      //           value: _filterController.text,
                      //           items: listFilter
                      //               .map<DropdownMenuItem<String>>((e) {
                      //             return DropdownMenuItem<String>(
                      //                 value: e,
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 10),
                      //                   child: Text(
                      //                     e,
                      //                     style: const TextStyle(
                      //                         color: Colors.black,
                      //                         fontWeight: FontWeight.bold,
                      //                         fontSize: 15),
                      //                   ),
                      //                 ));
                      //           }).toList(),
                      //           onChanged: (value) {
                      //             setState(() {
                      //               _filterController.text =
                      //                   value.toString();
                      //               //print(_categoryController.text);
                      //               //getinstance();
                      //               //print(_genderController.text);
                      //             });
                      //           },
                      //         ),
                      //       ),
                      //       const SizedBox(width: 5),
                      //       Expanded(
                      //         child: ListView.builder(
                      //           // physics: const AlwaysScrollableScrollPhysics(),
                      //           shrinkWrap: true,
                      //           itemCount: 1,
                      //           itemBuilder:
                      //               (BuildContext context, int index) {
                      //             if (_filterController.text ==
                      //                 listFilter[1]) {
                      //               return Container(
                      //                 alignment: Alignment.center,
                      //                 //margin: EdgeInsets.all(8),
                      //                 decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(15),
                      //                     border: Border.all(
                      //                       color: Theme.of(context)
                      //                           .secondaryHeaderColor,
                      //                       width: 2,
                      //                     )),
                      //                 child: DropdownButton<String>(
                      //                   isExpanded: true,
                      //                   underline: Container(
                      //                     height: 0,
                      //                   ),
                      //                   iconEnabledColor: Colors.black,
                      //                   value: _stateController.text,
                      //                   items: listState
                      //                       .map<DropdownMenuItem<String>>(
                      //                           (e) {
                      //                     return DropdownMenuItem<String>(
                      //                         value: e,
                      //                         child: Padding(
                      //                           padding: const EdgeInsets
                      //                                   .symmetric(
                      //                               horizontal: 10),
                      //                           child: Text(
                      //                             e,
                      //                             style: const TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontWeight:
                      //                                     FontWeight.bold,
                      //                                 fontSize: 15),
                      //                           ),
                      //                         ));
                      //                   }).toList(),
                      //                   onChanged: (value) {
                      //                     setState(() {
                      //                       _stateController.text =
                      //                           value.toString();
                      //                       //print(_categoryController.text);
                      //                       getinstance();
                      //                       //print(_genderController.text);
                      //                     });
                      //                   },
                      //                 ),
                      //               );
                      //             } else {
                      //               return Container(
                      //                 alignment: Alignment.center,
                      //                 //margin: EdgeInsets.all(8),
                      //                 decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(15),
                      //                     border: Border.all(
                      //                       color: Theme.of(context)
                      //                           .secondaryHeaderColor,
                      //                       width: 2,
                      //                     )),
                      //                 child: DropdownButton<String>(
                      //                   isExpanded: true,
                      //                   underline: Container(
                      //                     height: 0,
                      //                   ),
                      //                   iconEnabledColor: Colors.black,
                      //                   value: _categoryController.text,
                      //                   items: listCategories
                      //                       .map<DropdownMenuItem<String>>(
                      //                           (e) {
                      //                     return DropdownMenuItem<String>(
                      //                         value: e,
                      //                         child: Padding(
                      //                           padding: const EdgeInsets
                      //                                   .symmetric(
                      //                               horizontal: 10),
                      //                           child: Text(
                      //                             e,
                      //                             style: const TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontWeight:
                      //                                     FontWeight.bold,
                      //                                 fontSize: 15),
                      //                           ),
                      //                         ));
                      //                   }).toList(),
                      //                   onChanged: (value) {
                      //                     setState(() {
                      //                       _categoryController.text =
                      //                           value.toString();
                      //                       //print(_categoryController.text);
                      //                       getinstance();
                      //                       //print(_genderController.text);
                      //                     });
                      //                   },
                      //                 ),
                      //               );
                      //             }
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const Text(
                        'All available jobs based on category will be listed here...\nSo far there are no available job...',
                        textAlign: TextAlign.center,
                      ),
                      Container(
                          //padding: EdgeInsets.only(top: 5),
                          height: MediaQuery.of(context).size.height / 4.6,
                          width: MediaQuery.of(context).size.width,
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //       image: AssetImage('asset/available_job.png'),
                          //       fit: BoxFit.fitWidth),
                          // ),
                          margin: const EdgeInsets.only(bottom: 0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Image.asset(
                              'asset/available_job.png',
                              height: MediaQuery.of(context).size.height / 3,
                              // width: double.infinity,
                              // repeat: ImageRepeat.repeatX,
                            ),
                          )),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //physics: NeverScrollableScrollPhysics(),
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15.0),
                    //   child: CustomHeadline(heading: 'Filter'),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Icon(
                    //         Icons.tune,
                    //         color: themeData1().secondaryHeaderColor,
                    //       ),
                    //       const SizedBox(width: 3),
                    //       Container(
                    //         alignment: Alignment.center,
                    //         //margin: EdgeInsets.all(8),
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(15),
                    //             border: Border.all(
                    //               color: Theme.of(context).secondaryHeaderColor,
                    //               width: 2,
                    //             )),
                    //         child: DropdownButton<String>(
                    //           underline: Container(
                    //             height: 0,
                    //           ),
                    //           iconEnabledColor: Colors.black,
                    //           value: _filterController.text,
                    //           items:
                    //               listFilter.map<DropdownMenuItem<String>>((e) {
                    //             return DropdownMenuItem<String>(
                    //                 value: e,
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 10),
                    //                   child: Text(
                    //                     e,
                    //                     style: const TextStyle(
                    //                         color: Colors.black,
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 15),
                    //                   ),
                    //                 ));
                    //           }).toList(),
                    //           onChanged: (value) {
                    //             setState(() {
                    //               _filterController.text = value.toString();
                    //               //print(_categoryController.text);
                    //               //getinstance();
                    //               //print(_genderController.text);
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //       const SizedBox(width: 5),
                    //       Expanded(
                    //         child: ListView.builder(
                    //           // physics: const AlwaysScrollableScrollPhysics(),
                    //           shrinkWrap: true,
                    //           itemCount: 1,
                    //           itemBuilder: (BuildContext context, int index) {
                    //             if (_filterController.text == listFilter[1]) {
                    //               return Container(
                    //                 alignment: Alignment.center,
                    //                 //margin: EdgeInsets.all(8),
                    //                 decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(15),
                    //                     border: Border.all(
                    //                       color: Theme.of(context)
                    //                           .secondaryHeaderColor,
                    //                       width: 2,
                    //                     )),
                    //                 child: DropdownButton<String>(
                    //                   isExpanded: true,
                    //                   underline: Container(
                    //                     height: 0,
                    //                   ),
                    //                   iconEnabledColor: Colors.black,
                    //                   value: _stateController.text,
                    //                   items: listState
                    //                       .map<DropdownMenuItem<String>>((e) {
                    //                     return DropdownMenuItem<String>(
                    //                         value: e,
                    //                         child: Padding(
                    //                           padding:
                    //                               const EdgeInsets.symmetric(
                    //                                   horizontal: 10),
                    //                           child: Text(
                    //                             e,
                    //                             style: const TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontWeight: FontWeight.bold,
                    //                                 fontSize: 15),
                    //                           ),
                    //                         ));
                    //                   }).toList(),
                    //                   onChanged: (value) {
                    //                     setState(() {
                    //                       _stateController.text =
                    //                           value.toString();
                    //                       //print(_categoryController.text);
                    //                       getinstance();
                    //                       //print(_genderController.text);
                    //                     });
                    //                   },
                    //                 ),
                    //               );
                    //             } else {
                    //               return Container(
                    //                 alignment: Alignment.center,
                    //                 //margin: EdgeInsets.all(8),
                    //                 decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(15),
                    //                     border: Border.all(
                    //                       color: Theme.of(context)
                    //                           .secondaryHeaderColor,
                    //                       width: 2,
                    //                     )),
                    //                 child: DropdownButton<String>(
                    //                   isExpanded: true,
                    //                   underline: Container(
                    //                     height: 0,
                    //                   ),
                    //                   iconEnabledColor: Colors.black,
                    //                   value: _categoryController.text,
                    //                   items: listCategories
                    //                       .map<DropdownMenuItem<String>>((e) {
                    //                     return DropdownMenuItem<String>(
                    //                         value: e,
                    //                         child: Padding(
                    //                           padding:
                    //                               const EdgeInsets.symmetric(
                    //                                   horizontal: 10),
                    //                           child: Text(
                    //                             e,
                    //                             style: const TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontWeight: FontWeight.bold,
                    //                                 fontSize: 15),
                    //                           ),
                    //                         ));
                    //                   }).toList(),
                    //                   onChanged: (value) {
                    //                     setState(() {
                    //                       _categoryController.text =
                    //                           value.toString();
                    //                       //print(_categoryController.text);
                    //                       getinstance();
                    //                       //print(_genderController.text);
                    //                     });
                    //                   },
                    //                 ),
                    //               );
                    //             }
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: getinstance,
                        child: ListView.builder(
                          itemCount: listFiltered.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => JobDetails(
                                            requestId: listFiltered[index].id!,
                                            user: user)))
                                    .then((value) => getinstance());
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
                  ],
                ),
      // FIXME: Search disabled sbb belum migrate
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Theme.of(context).secondaryHeaderColor,
      //   onPressed: () {
      //     showSearch(
      //         context: context, delegate: CustomSearchDelegate(data, user));
      //     //print(listFiltered);
      //   },
      //   icon: const Icon(Icons.search),
      //   label: const Text('Find Job'),
      // ),
    );
  }
}
