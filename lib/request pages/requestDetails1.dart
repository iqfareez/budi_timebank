import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grpc/grpc.dart';
import '../components/constants.dart';
import '../custom%20widgets/customHeadline.dart';
import '../custom%20widgets/theme.dart';
import '../extension_string.dart';
import '../other%20profile/viewProfile.dart';
import '../rate%20pages/rateGiven.dart';
import 'updatePage.dart';
import '../bin/client_rating.dart';
import '../bin/client_service_request.dart';
import '../bin/client_user.dart';
import '../bin/common.dart';
import '../custom widgets/heading2.dart';

class RequestDetails1 extends StatefulWidget {
  final String requestId;
  final bool isRequest;
  final String user;
  const RequestDetails1(
      {super.key,
      required this.requestId,
      required this.isRequest,
      required this.user});

  @override
  State<RequestDetails1> createState() => _RequestDetails1State();
}

class _RequestDetails1State extends State<RequestDetails1> {
  final double _valueController = 0;
  double _value1Controller = 0;

  final _commentController = TextEditingController();
  final _comment1Controller = TextEditingController();

  late dynamic dateJob;
  late dynamic dateCreatedOn;
  late dynamic dateUpdatedOn;
  late dynamic dateCompletedOn;
  late dynamic requestDetails;

  late dynamic ratedUser;
  late dynamic _userRequestor;
  late dynamic _userProvidor;
  final dynamic _listApplicants = [];

  late bool isLoad = false;

  isNull(dynamic stuff) {
    if (stuff == '' || stuff.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  isComplete() {
    if (requestDetails.request.state.toString() == 'COMPLETED') {
      return true;
    } else {
      return false;
    }
  }

  isAccepted() {
    if (requestDetails.request.state.toString() == 'ACCEPTED') {
      return true;
    } else {
      return false;
    }
  }

  isOngoing() {
    if (requestDetails.request.state.toString() == 'ONGOING') {
      return true;
    } else {
      return false;
    }
  }

  isPending() {
    if (requestDetails.request.state.toString() == 'PENDING') {
      return true;
    } else {
      return false;
    }
  }

  // isRequested() {
  //   for (int i = 0; i < requestDetails.request.applicants.length; i++) {
  //     if (requestDetails.request.applicants[i] == user) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  isRated() {
    if (ratedUser.ratings.length == 1) {
      // setState(() {

      // });
      return true;
    } else if (ratedUser.ratings.length == 2) {
      return false;
    } else {
      return true;
    }
  }

  isProviderRated() {
    if (ratedUser.ratings.length == 1 &&
        ratedUser.ratings[0].recipient == requestDetails.request.provider) {
      return true;
    } else if (ratedUser.ratings.length == 2 &&
        (ratedUser.ratings[0].recipient == requestDetails.request.provider ||
            ratedUser.ratings[1].recipient ==
                requestDetails.request.provider)) {
      return true;
    } else {
      return false;
    }
  }

  isRequestorRated() {
    if (ratedUser.ratings.length == 1 &&
        ratedUser.ratings[0].recipient == requestDetails.request.requestor) {
      return true;
    } else if (ratedUser.ratings.length == 2 &&
        (ratedUser.ratings[0].recipient == requestDetails.request.requestor ||
            ratedUser.ratings[1].recipient ==
                requestDetails.request.requestor)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    isLoad = true;
    // hasRequestorRated = false;
    // hasRateRequestor = false;

    _getAllinstance();
    // _getRatingResponse();
    // _getApplicants();
    //_getRatingId();
    super.initState();
  }

  void _getAllinstance() async {
    setState(() {
      isLoad = true;
    });
    requestDetails = await ClientServiceRequest(Common().channel)
        .getResponseById(widget.requestId);
    //print(requestDetails);
    _userRequestor = await ClientUser(Common().channel)
        .getUserById(requestDetails.request.requestor);

    isNull(requestDetails.request.provider)
        ? _userProvidor = 'No Providor'
        : _userProvidor = await ClientUser(Common().channel)
            .getUserById(requestDetails.request.provider);
    //print(_userProvidor);
    dateCreatedOn = DateTime.parse(requestDetails.request.createdAt);
    dateUpdatedOn = DateTime.parse(requestDetails.request.updatedAt);
    dateJob = DateTime.parse(requestDetails.request.date);

    isComplete()
        ? dateCompletedOn = DateTime.parse(requestDetails.request.date)
        : dateCompletedOn = '';
    //print(widget.id);
    ratedUser = await ClientRating(Common().channel)
        .getResponseRating('request_id', requestDetails.request.id);

    // print(ratedUser);
    // print(widget.requestor);
    for (int i = 0; i < requestDetails.request.applicants.length; i++) {
      //print(widget.applicants[i]);
      var name = await ClientUser(Common().channel)
          .getUserById(requestDetails.request.applicants[i]);
      _listApplicants.add(name);
    }
    // print(_listApplicants);
    setState(() {
      isLoad = false;
    });
  }

  void applyJob(String reqid, String provider) async {
    try {
      await ClientServiceRequest(Common().channel)
          .applyProvider1(reqid, provider);
      context.showSnackBar(message: 'Job requested!!');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on GrpcError catch (e) {
      context.showErrorSnackBar(message: '${e.message}');
      //print(e);
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
  }

  void _completeJob(String id, String user) async {
    try {
      await ClientServiceRequest(Common().channel).completeService1(id, user);
      context.showSnackBar(message: 'Job Completed');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on GrpcError catch (e) {
      context.showErrorSnackBar(message: 'Caught error: ${e.message}');
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
  }

  // void _rateRequestor(
  //     String author, int value, String comment, String id) async {
  //   try {
  //     await ClientRating(Common().channel)
  //         .ratingForRequestor(author, value, comment, id);
  //     setState(() {});
  //     context.showSnackBar(message: 'Requestor rated!!');
  //     Navigator.of(context).pop();
  //   } on GrpcError catch (e) {
  //     context.showErrorSnackBar(message: 'Caught error: ${e.message}');
  //   } catch (e) {
  //     context.showErrorSnackBar(message: e.toString());
  //   }
  // }

  void _rateProvider(
      String author, int value, String comment, String id) async {
    // widget.counter++;
    try {
      // if(_comment1Controller.text == ''){
      //   context.showErrorSnackBar(message: '');
      // }
      await ClientRating(Common().channel)
          .ratingForProvider(author, value, comment, id);
      context.showSnackBar(message: 'Provider rated!!');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on GrpcError catch (e) {
      context.showErrorSnackBar(message: 'Caught error: ${e.message}');
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
    // setState(() {
    //   //widget.hasProviderRated = true;
    //   //hasRequestorRated = true;
    //   //print(hasRequestorRated);
    // });
  }

  void _deleteRequest(String id) async {
    try {
      await ClientServiceRequest(Common().channel).deleteService(id);
      context.showSnackBar(message: 'Job Deleted');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on GrpcError catch (e) {
      context.showErrorSnackBar(message: 'Caught error: ${e.message}');
      print(e);
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
  }

  void _selectProvider(String id, String provider, String caller) async {
    try {
      await ClientServiceRequest(Common().channel)
          .selectProvider1(id, provider, caller);
      context.showSnackBar(message: 'Applicant Selected');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on GrpcError catch (e) {
      context.showErrorSnackBar(message: 'Caught error: ${e.message}');
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
  }

  //final rateServiceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isRequest
          ? AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: const Text('Request Details'),
            )
          : AppBar(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              title: const Text('Request Details'),
            ),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Heading2('Job Id'),
                  // Text(widget.id),
                  Center(child: Heading2('Title')),
                  Center(
                      child: Text(requestDetails.request.title
                          .toString()
                          .capitalize())),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            // side: BorderSide(
                            //   color: themeData1().secondaryHeaderColor,
                            //   width: 3,
                            // ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Heading2('Requestor'),
                                Text(
                                  _userRequestor.user.name
                                      .toString()
                                      .titleCase(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: const RoundedRectangleBorder(
                          // side: BorderSide(
                          //   color: themeData1().secondaryHeaderColor,
                          //   width: 3,
                          // ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Heading2('State'),
                              Text(
                                requestDetails.request.state
                                    .toString()
                                    .capitalize(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: const RoundedRectangleBorder(
                          // side: BorderSide(
                          //   color: themeData1().secondaryHeaderColor,
                          //   width: 3,
                          // ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Heading2('Rate'),
                              Text(
                                '${requestDetails.request.rate} Time/hour',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  widget.isRequest
                      ? Card(
                          shape: const RoundedRectangleBorder(
                            // side: BorderSide(
                            //   color: themeData1().secondaryHeaderColor,
                            //   width: 3,
                            // ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                isNull(requestDetails.request
                                        .applicants) //does not have any  applicants
                                    ? Column(
                                        children: [
                                          Heading2('Applicants'),
                                          const Text('No Applicants'),
                                          const SizedBox(height: 5)
                                        ],
                                      )
                                    : isNull(requestDetails.request
                                            .provider) // have applicants
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Heading2('Applicants'),
                                                const Text(
                                                    'Select your applicants: '),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: requestDetails
                                                      .request
                                                      .applicants
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: ElevatedButton(
                                                              style: themeData2()
                                                                  .elevatedButtonTheme
                                                                  .style,
                                                              onPressed: () =>
                                                                  showDialog<
                                                                      String>(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        AlertDialog(
                                                                      title: Text(
                                                                          'Select ${_listApplicants[index].user.name.toString().titleCase()}?'),
                                                                      content: Text(
                                                                          '${_listApplicants[index].user.name.toString().titleCase()} will be your provider.'),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'Cancel'),
                                                                          child:
                                                                              const Text('Cancel'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            _selectProvider(
                                                                                requestDetails.request.id.toString(),
                                                                                requestDetails.request.applicants[index].toString(),
                                                                                widget.user.toString());
                                                                          },
                                                                          child:
                                                                              const Text('Yes'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                              // onPressed: () {
                                                              //   // print(widget.id);
                                                              //   // print(
                                                              //   //     widget.applicants[
                                                              //   //         index]);
                                                              //   // print(widget.user);

                                                              child: Text(
                                                                '${index + 1}) ${_listApplicants[index].user.name.toString().titleCase()}',
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        IconButton(
                                                          onPressed: (() {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        ViewProfile(
                                                                          id: _listApplicants[index]
                                                                              .user
                                                                              .userId
                                                                              .toString(),
                                                                        )));
                                                          }),
                                                          icon: FaIcon(
                                                            FontAwesomeIcons
                                                                .solidCircleQuestion,
                                                            color: themeData2()
                                                                .secondaryHeaderColor,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        : Column(
                                            //when requestor select provider
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: Heading2(
                                                      'Provider Selected')),
                                              isNull(requestDetails
                                                      .request.provider)
                                                  ? const Text(
                                                      'No provider selected')
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(3, 3, 3, 6),
                                                      child: TextButton(
                                                        style: themeData2()
                                                            .textButtonTheme
                                                            .style,
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ViewProfile(
                                                              id: _userProvidor
                                                                  .user.userId
                                                                  .toString(),
                                                            ),
                                                          ));
                                                        },
                                                        child: Text(
                                                            _userProvidor
                                                                .user.name
                                                                .toString()
                                                                .titleCase()),
                                                      ),
                                                    )
                                            ],
                                          ),
                                //CustomDivider(color: themeData2().primaryColor),
                                //SizedBox(height: 8),
                                isPending() //when has no applicants
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ElevatedButton(
                                                style: themeData2()
                                                    .elevatedButtonTheme
                                                    .style,
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            UpdatePage(
                                                                id: requestDetails
                                                                    .request
                                                                    .id),
                                                      ))
                                                      .then((value) => setState(
                                                            () {
                                                              _getAllinstance();
                                                            },
                                                          ));
                                                },
                                                child: const Text(
                                                    'Update Request Details')),
                                          ],
                                        ),
                                      )
                                    : isComplete() //when request is complete
                                        ? isRated() //still for request
                                            ? isProviderRated()
                                                ? Column(
                                                    children: [
                                                      const Text(
                                                          'You have rated the provider.'),
                                                      Text(
                                                          'Completed On: ${dateCompletedOn.day}-${dateCompletedOn.month}-${dateCompletedOn.year}'),
                                                      Text(
                                                          'Time: ${dateCompletedOn.hour}:${dateCompletedOn.minute}:${dateCompletedOn.second}'),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                              'Payment: '),
                                                          Text(
                                                            '${requestDetails.request.actualPayment.toStringAsFixed(2)} Time/hour',
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                      TextButton(
                                                          style: themeData2()
                                                              .textButtonTheme
                                                              .style,
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const RateGivenPage(),
                                                            ));
                                                          },
                                                          child: const Text(
                                                              'Go to rating page'))
                                                    ],
                                                  )
                                                : Column(children: [
                                                    const Text(
                                                      'Rate the provider',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Center(
                                                      child: RatingBar.builder(
                                                        initialRating: 0,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                        ),
                                                        onRatingUpdate:
                                                            (value) {
                                                          _value1Controller =
                                                              value;
                                                          //print(_valueController);
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    TextFormField(
                                                      controller:
                                                          _comment1Controller,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  'Enter comment'),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    ElevatedButton(
                                                        style: themeData2()
                                                            .elevatedButtonTheme
                                                            .style,
                                                        onPressed: () =>
                                                            showDialog<String>(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                title: const Text(
                                                                    'Submit Review?'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'Cancel'),
                                                                    child: const Text(
                                                                        'Cancel'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      _rateProvider(
                                                                          widget
                                                                              .user,
                                                                          _value1Controller
                                                                              .toInt(),
                                                                          _comment1Controller
                                                                              .text,
                                                                          requestDetails
                                                                              .request
                                                                              .id);
                                                                    },
                                                                    child: const Text(
                                                                        'Submit'),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                        // onPressed: () {
                                                        //   //print(ratedUser);
                                                        //   // print(user);
                                                        //   // print(
                                                        //   //     _value1Controller.toInt());
                                                        //   // print(_comment1Controller.text);
                                                        //   // print(id);

                                                        child: const Text(
                                                            'Rate Provider'))
                                                  ])
                                            : Column(
                                                children: [
                                                  Heading2(
                                                      'The request is completed'),

                                                  Text(
                                                      'Completed On: ${dateCompletedOn.day}-${dateCompletedOn.month}-${dateCompletedOn.year}'),
                                                  Text(
                                                      'Time: ${dateCompletedOn.hour}:${dateCompletedOn.minute}:${dateCompletedOn.second}'), //completed on 2
                                                  TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                              foregroundColor:
                                                                  Colors.red),
                                                      onPressed: () =>
                                                          showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                              title: const Text(
                                                                  'Delete Request?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    _deleteRequest(
                                                                        requestDetails
                                                                            .request
                                                                            .id);
                                                                  },
                                                                  child: const Text(
                                                                      'Delete'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                      child: const Text(
                                                          'Delete Job'))
                                                ],
                                              )
                                        : isOngoing()
                                            ? Column(
                                                children: [
                                                  const Text(
                                                    'The request has started, make sure to tap \n"Complete Request" when the provider has finished the request.',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const Divider(),
                                                  ElevatedButton(
                                                      style: themeData2()
                                                          .elevatedButtonTheme
                                                          .style,
                                                      onPressed: () =>
                                                          showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                              title: const Text(
                                                                  'Complete Request?'),
                                                              content: const Text(
                                                                  'Once the request is complete, transaction of Time/hour will be made.'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    _completeJob(
                                                                        requestDetails
                                                                            .request
                                                                            .id,
                                                                        widget
                                                                            .user);
                                                                  },
                                                                  child: const Text(
                                                                      'Complete'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                      // onPressed: () {
                                                      //   _completeJob(
                                                      //       requestDetails
                                                      //           .request.id,
                                                      //       widget.user);
                                                      // },
                                                      child: const Text(
                                                          'Complete Request')),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  const Text(
                                                    'Start the request to record the request in the blockchain',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  ElevatedButton(
                                                      style: themeData2()
                                                          .elevatedButtonTheme
                                                          .style,
                                                      onPressed:
                                                          () => showDialog<
                                                                  String>(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                  title: const Text(
                                                                      'Start Request'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                      child: const Text(
                                                                          'Cancel'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        try {
                                                                          ClientServiceRequest(Common().channel).startService1(
                                                                              requestDetails.request.id,
                                                                              widget.user);
                                                                          context.showSnackBar(
                                                                              message: 'Request Started!!');
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        } on GrpcError catch (e) {
                                                                          context.showErrorSnackBar(
                                                                              message: e.toString());
                                                                        } catch (e) {
                                                                          context.showErrorSnackBar(
                                                                              message: e.toString());
                                                                        }
                                                                      },
                                                                      child: const Text(
                                                                          'Start'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                      // onPressed: () {

                                                      //   // _completerequest(
                                                      //   //     widget.id, widget.user);
                                                      // },
                                                      child: const Text(
                                                          'Start Request')),
                                                ],
                                              ),
                                isNull(requestDetails.request.provider)
                                    ? TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor: Colors.red),
                                        onPressed: () => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'Delete Request?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _deleteRequest(
                                                          requestDetails
                                                              .request.id);
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        child: const Text('Delete request'))
                                    : const Text('')
                                // : isComplete()
                                //     ? Padding(
                                //         padding: const EdgeInsets.all(8.0),
                                //         child: TextButton(
                                //             style: themeData2()
                                //                 .textButtonTheme
                                //                 .style,
                                //             onPressed: () {
                                //               Navigator.of(context)
                                //                   .push(MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     RateGivenPage(),
                                //               ));
                                //             },
                                //             child:
                                //                 Text('Go to rating page')),
                                //       )
                                //     : Text('')
                                // TextButton(
                                //     style: themeData2()
                                //         .textButtonTheme
                                //         .style,
                                //     onPressed: () {
                                //       _deleteRequest(
                                //           requestDetails.request.id);
                                //       context.showSnackBar(
                                //           message: 'request Deleted');
                                //       Navigator.of(context).pop();
                                //       //Navigator.of(context).popUntil((route) => route.i);
                                //       //Navigator.of(context).pushNamed('/navigation');
                                //     },
                                //     child: Text('Abort requests')),
                              ],
                            ),
                          ),
                        )
                      : isComplete() //isRequestcomplete?
                          ? Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Heading2('Completed On'),
                                    Text(
                                        'Date: ${dateCompletedOn.day}-${dateCompletedOn.month}-${dateCompletedOn.year}\n'),
                                    Text(
                                        'Time: ${dateCompletedOn.hour}:${dateCompletedOn.minute}:${dateCompletedOn.second}\n'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Payment received: '),
                                        Text(
                                          '${requestDetails.request.actualPayment.toStringAsFixed(2)} Time/hour',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : isAccepted()
                              ? const Card(
                                  shape: RoundedRectangleBorder(
                                    // side: BorderSide(
                                    //   color: themeData1().secondaryHeaderColor,
                                    //   width: 3,
                                    // ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        CustomHeadline(
                                            heading:
                                                'You have been accepted as the provider'),
                                        Text(
                                            'Contact your requestor to start the request when you are ready')
                                      ],
                                    ),
                                  ),
                                )
                              : isOngoing()
                                  ? const Card(
                                      shape: RoundedRectangleBorder(
                                        // side: BorderSide(
                                        //   color: themeData1().secondaryHeaderColor,
                                        //   width: 3,
                                        // ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                            child: CustomHeadline(
                                                heading:
                                                    'You are currently doing this request')),
                                      ),
                                    )
                                  : Card(
                                      shape: const RoundedRectangleBorder(
                                        // side: BorderSide(
                                        //   //color: themeData1().secondaryHeaderColor,
                                        //   width: 3,
                                        // ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      //sini oi the service
                                      elevation: 5,
                                      child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child:
                                              isNull(requestDetails
                                                      .request.applicants)
                                                  ? Column(
                                                      children: [
                                                        Heading2(
                                                            'Want to help?'),
                                                        ElevatedButton(
                                                            style: themeData2()
                                                                .elevatedButtonTheme
                                                                .style,
                                                            onPressed:
                                                                () =>
                                                                    showDialog<
                                                                        String>(
                                                                      context:
                                                                          context,
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          AlertDialog(
                                                                        title: const Text(
                                                                            'Apply request?'),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(context, 'Cancel'),
                                                                            child:
                                                                                const Text('Cancel'),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              applyJob(requestDetails.request.id, widget.user);
                                                                            },
                                                                            child:
                                                                                const Text('Apply'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                            // onPressed: () {

                                                            //   // print(widget.id);
                                                            //   // print(widget.user);

                                                            // },
                                                            child: const Text(
                                                                'Apply Request')),
                                                      ],
                                                    )
                                                  : const Center(
                                                      child: Text(
                                                          'You have applied the request.\nContact the Requestor to accept you as Provider'),
                                                    )),
                                    ),
                  const SizedBox(height: 15),
                  Container(
                      alignment: Alignment.center,
                      child: Heading2('Other Information')),
                  const Divider(),
                  Heading2('Date of the request'),
                  Text(
                      'Date: ${dateJob.day}-${dateJob.month}-${dateJob.year}\nTime: ${dateJob.hour.toString().padLeft(2, '0')}:${dateJob.minute.toString().padLeft(2, '0')}'),
                  //const SizedBox(height: 15),
                  const Divider(),
                  Heading2('Category'),
                  Text(requestDetails.request.category),
                  const Divider(),
                  Heading2('Description'),
                  Text(requestDetails.request.description
                      .toString()
                      .capitalize()),
                  const Divider(),
                  Heading2('Location'),
                  Text(
                      'Address: ${requestDetails.request.location.address.toString()}'),
                  Text('State: ${requestDetails.request.location.state}'),
                  Text('City: ${requestDetails.request.location.city}'),
                  const Divider(),
                  Heading2('Media'),
                  isNull(requestDetails.request.mediaAttachments)
                      ? const Text('No Attachment')
                      : SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                requestDetails.request.mediaAttachments.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(
                                      '${index + 1}) ${requestDetails.request.mediaAttachments[index].toString()}'),
                                ],
                              );
                            },
                          ),
                        ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading2('Created On'),
                          Text(
                              'Date: ${dateCreatedOn.day}-${dateCreatedOn.month}-${dateCreatedOn.year}\nTime: ${dateCreatedOn.hour}:${dateCreatedOn.minute}'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading2('Updated On'),
                          Text(
                              'Date: ${dateUpdatedOn.day}-${dateUpdatedOn.month}-${dateUpdatedOn.year}\nTime: ${dateUpdatedOn.hour}:${dateUpdatedOn.minute}'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
