import 'package:flutter/material.dart';
import '../bin/client_rating.dart';
import '../custom%20widgets/theme.dart';
import 'customCardRating.dart';

import '../bin/common.dart';
import '../components/constants.dart';
import 'ratingDetails.dart';

class RateReceivedPage extends StatefulWidget {
  const RateReceivedPage({super.key});

  @override
  State<RateReceivedPage> createState() => _RateReceivedPageState();
}

class _RateReceivedPageState extends State<RateReceivedPage> {
  late bool isLoad;
  late dynamic listRequest;
  // late dynamic listRequest.ratings;
  late String user;
  late bool _isEmpty;

  @override
  void initState() {
    isLoad = true;
    _isEmpty = true;
    getinstance();
    super.initState();
  }

  void getinstance() async {
    // listRequest.ratings = [];
    user = supabase.auth.currentUser!.id;

    //print(_userCurrent);
    listRequest = await ClientRating(Common().channel)
        .getResponseRating('recipient', user);
    //print(listRequest);
    // for (var i = 0; i < listRequest.ratings.length; i++) {
    //   if (listRequest.ratings[i].recipient == user) {
    //     listRequest.ratings.add(listRequest.ratings[i]);
    //   }
    //   //print(listRequest.ratings);
    // }
    setState(() {
      isLoad = false;
      isEmpty();
    });
    //print(listRequest.ratings.length);
  }

  bool isEmpty() {
    if (listRequest.ratings.length == 0) {
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
      appBar: AppBar(
          title: const Text('Received Rating'),
          backgroundColor: themeData1().secondaryHeaderColor),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : _isEmpty
              ? const Center(child: Text('No rating received...'))
              : ListView.builder(
                  itemCount: listRequest.ratings.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => RatingDetails(
                                      isProvider: false,
                                      ratingFor:
                                          listRequest.ratings[index].ratingFor,
                                      author: listRequest.ratings[index].author,
                                      recipient:
                                          listRequest.ratings[index].recipient,
                                      value: listRequest.ratings[index].value,
                                      comment:
                                          listRequest.ratings[index].comment,
                                      createdAt:
                                          listRequest.ratings[index].createdAt,
                                      updatedAt:
                                          listRequest.ratings[index].updatedAt,
                                      requestId:
                                          listRequest.ratings[index].requestId,
                                    )))
                            .then((value) => setState(
                                  () {
                                    //_isEmpty = true;
                                    getinstance();
                                  },
                                ));
                      },
                      child: CustomCardRating(
                        ratingFor: listRequest.ratings[index].ratingFor,
                        provider: listRequest.ratings[index].recipient,
                        value: listRequest.ratings[index].value,
                        //function: getinstance,
                        //id: listRequest.ratings[index].id,
                        requestor: listRequest.ratings[index].author,
                        //provider: listRequest.ratings[index].provider,
                        title: listRequest.ratings[index].comment,
                        // description:
                        //     listRequest.ratings[index].details.description,
                        // locationName: listRequest.ratings[index].location.name,
                        // latitude: listRequest.ratings
                        //     [index].location.coordinate.latitude,
                        // longitude: listRequest.ratings
                        //     [index].location.coordinate.longitude,
                        // state: listRequest.ratings[index].state,
                        rate: listRequest.ratings[index].value,
                        // applicants: listRequest.ratings[index].applicants,
                        // created: listRequest.ratings[index].createdAt,
                        // updated: listRequest.ratings[index].updatedAt,
                        // completed: listRequest.ratings[index].completedAt,
                        // media: listRequest[index].mediaAttachments,
                      ),
                    );
                  },
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
