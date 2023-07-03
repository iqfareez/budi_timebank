import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../custom widgets/heading2.dart';
import '../custom%20widgets/customHeadline.dart';
import '../custom%20widgets/theme.dart';
import '../db_helpers/client_service_request.dart';
import '../db_helpers/client_user.dart';
import '../extension_string.dart';
import '../model/profile.dart';
import '../model/rating.dart';
import '../model/service_request.dart';
import '../request pages/requestDetails.dart';

class RatingDetails extends StatefulWidget {
  final bool isProvider;
  final Rating ratingDetails;

  const RatingDetails({
    super.key,
    required this.isProvider,
    required this.ratingDetails,
  });

  @override
  State<RatingDetails> createState() => _RatingDetailsState();
}

class _RatingDetailsState extends State<RatingDetails> {
  final String userUid = FirebaseAuth.instance.currentUser!.uid;
  late Profile _userRequestor;
  late Profile _userProvider;
  late ServiceRequest requestDetails;

  bool isLoad = false;

  @override
  void initState() {
    _getInstance();
    super.initState();
  }

  _getInstance() async {
    setState(() {
      isLoad = true;
    });
    _userRequestor =
        await ClientUser.getUserProfileById(widget.ratingDetails.authorId);

    _userProvider =
        await ClientUser.getUserProfileById(widget.ratingDetails.rateeId);

    requestDetails = await ClientServiceRequest.getMyServiceRequestById(
        widget.ratingDetails.jobId);

    setState(() {
      isLoad = false;
    });
  }

  isNull(dynamic stuff) {
    if (stuff == '' || stuff.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  void _deleteRating(String id, String ratingFor) async {
    throw UnimplementedError('delete rating not implemented');
  }

  //final rateServiceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.isProvider
            ? themeData1().primaryColor
            : themeData1().secondaryHeaderColor,
        title: const Text('Rating Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: isLoad
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //shrinkWrap: true,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: themeData1().primaryColor,
                        width: 3,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.comment,
                                      color: themeData1().primaryColor),
                                  const SizedBox(width: 5),
                                  Heading2('Comment'),
                                ],
                              ),
                              widget.ratingDetails.message == null ||
                                      widget.ratingDetails.message!.isEmpty
                                  ? const Text(
                                      'No comment from provider',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Text(widget.ratingDetails.message!
                                      .capitalize()),
                            ],
                          ),
                          Column(
                            children: [
                              Heading2('Rate'),
                              Center(
                                child: RatingBar.builder(
                                  ignoreGestures: true,
                                  itemSize: 20,
                                  initialRating:
                                      widget.ratingDetails.rating.toDouble(),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: themeData1().secondaryHeaderColor,
                                  ),
                                  onRatingUpdate: (value) {
                                    //_value1Controller = value;
                                    //print(_valueController);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: themeData1().secondaryHeaderColor,
                        width: 3,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomHeadline(
                                  heading: 'Recipient',
                                  color: themeData1().secondaryHeaderColor),
                              Text(_userProvider.name.toString().titleCase()),
                            ],
                          ),
                          Column(
                            children: [
                              CustomHeadline(
                                heading: 'Author',
                                color: themeData1().secondaryHeaderColor,
                              ),
                              Text(_userRequestor.name.toString().titleCase()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Heading2(' Created On'),
                  Text(
                      ' Date: ${widget.ratingDetails.createdAt.day}-${widget.ratingDetails.createdAt.month}-${widget.ratingDetails.createdAt.year}\n\tTime: ${widget.ratingDetails.createdAt.hour}:${widget.ratingDetails.createdAt.minute}'),
                  const SizedBox(height: 15),
                  // Heading2(' Updated On'),
                  // Text(
                  //     ' Date: ${dateUpdatedOn.day}-${dateUpdatedOn.month}-${dateUpdatedOn.year}\n\tTime: ${dateUpdatedOn.hour}:${dateUpdatedOn.minute}'),
                  // SizedBox(height: 15),
                  Heading2(' Request Title'),
                  ElevatedButton(
                    onPressed: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          // buat checking for widget.isProvider and return widget accordingly
                          builder: (context) => RequestDetails(
                              requestId: requestDetails.id!, user: userUid)));
                    }),
                    child: Text(' ${requestDetails.title}'),
                  ),

                  const SizedBox(height: 15),
                  widget.isProvider
                      ? TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete Rating?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // _deleteRating(
                                        //     widget.requestId, widget.ratingFor);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                          // onPressed: () {
                          //   _deleteRating(widget.requestId, widget.ratingFor);
                          // },
                          child: const Text('Delete Rating'))
                      : const Text('')
                ],
              ),
      ),
    );
  }
}
