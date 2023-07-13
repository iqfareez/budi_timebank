import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../components/constants.dart';
import '../custom widgets/heading2.dart';
import '../custom%20widgets/theme.dart';
import '../db_helpers/client_rating.dart';
import '../db_helpers/client_service_request.dart';
import '../db_helpers/client_user.dart';
import '../extension_string.dart';
import '../model/profile.dart';
import '../model/service_request.dart';
import '../other%20profile/viewProfile.dart';
import '../rate pages/rate_given_page.dart';
import 'applicants_selection.dart';
import 'updatePage.dart';

class RequestDetails extends StatefulWidget {
  final String requestId;
  final String user;
  const RequestDetails(
      {super.key, required this.requestId, required this.user});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  late DateTime dateJob;
  late DateTime dateCreatedOn;
  DateTime? dateUpdatedOn;
  late ServiceRequest requestDetails;

  late dynamic ratedUser;
  late Profile _userRequestor;
  Profile? _userProvidor;
  final List<Profile> _listApplicants = [];

  bool isLoad = true;

  bool isRated = false;
  final TextEditingController _commentController = TextEditingController();
  int _starRatingValue = 0;

  double? paymentTransferred;

  final mapController = MapController(
    initMapWithUserPosition: const UserTrackingOption.withoutUserPosition(),
    areaLimit: const BoundingBox.world(),
  );

  isPending() => requestDetails.status == ServiceRequestStatus.pending;
  isAccepted() => requestDetails.status == ServiceRequestStatus.accepted;
  isOngoing() => requestDetails.status == ServiceRequestStatus.ongoing;
  isCompletedVerified() =>
      requestDetails.status == ServiceRequestStatus.completedVerified;
  // pending completion verification
  isCompleted() => requestDetails.status == ServiceRequestStatus.completed;

  isRequested() {
    for (int i = 0; i < requestDetails.applicants.length; i++) {
      if (requestDetails.applicants[i] == widget.user) {
        return true;
      }
    }
    return false;
  }

  isRequestor() => requestDetails.requestorId == widget.user;

  @override
  void initState() {
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

    requestDetails =
        await ClientServiceRequest.getMyServiceRequestById(widget.requestId);

    _userRequestor =
        await ClientUser.getUserProfileById(requestDetails.requestorId);

    if (requestDetails.providerId != null) {
      _userProvidor =
          await ClientUser.getUserProfileById(requestDetails.providerId!);
    }

    // isNull(requestDetails.provider)
    //     ? _userProvidor = 'No Providor'
    //     : _userProvidor = await ClientUser(Common().channel)
    //         .getUserById(requestDetails.provider);
    // TODO: Check this

    dateCreatedOn = requestDetails.createdAt;
    dateUpdatedOn = requestDetails.updatedAt;
    dateJob = requestDetails.date;

    if (requestDetails.status == ServiceRequestStatus.completedVerified) {
      paymentTransferred =
          await ClientServiceRequest.getServiceIncome(widget.requestId);
      // remove negative value (just in  case)
      paymentTransferred = paymentTransferred?.abs();
    }

    if (requestDetails.status == ServiceRequestStatus.completedVerified) {
      var rating = await ClientRating.getRatingByJobId(jobId: widget.requestId);
      if (rating != null) {
        isRated = true;
        _starRatingValue = rating.rating;
      }
    }

    for (int i = 0; i < requestDetails.applicants.length; i++) {
      var name =
          await ClientUser.getUserProfileById(requestDetails.applicants[i]);
      _listApplicants.add(name);
    }

    // print(_listApplicants);
    setState(() {
      isLoad = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    mapController.changeLocation(GeoPoint(
        latitude: requestDetails.location.coordinate.latitude,
        longitude: requestDetails.location.coordinate.longitude));
    mapController.setZoom(zoomLevel: 15.4);
  }

  Future<void> _verifyTaskComplete(String jobId) async {
    await ClientServiceRequest.verifyServiceCompleted(jobId);
  }

  void _deleteRequest(String id) async {
    await ClientServiceRequest.deleteServiceRequest(id);
    context.showSnackBar(message: 'Service Request deleted');
  }

  //final rateServiceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Request Details'),
      ),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (kDebugMode)
                    Text(
                      requestDetails.id.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),

                  Center(child: Heading2('Title')),
                  Center(
                      child:
                          Text(requestDetails.title.toString().capitalize())),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Heading2('Status'),
                              Text(
                                requestDetails.status.name.capitalize(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Heading2('Rate'),
                              Text(
                                '${requestDetails.rate} Time/hour',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          //does not have any applicants
                          if (_userProvidor == null &&
                              requestDetails.applicants.isEmpty) ...[
                            Heading2('Applicants'),
                            const Text('No Applicants'),
                            const SizedBox(height: 5)
                          ],
                          if (requestDetails.applicants.isNotEmpty &&
                              _userProvidor == null)
                            ApplicantsSelectionList(
                              applicants: _listApplicants,
                              onSelectProvider: (int index) async {
                                await ClientServiceRequest.applyProvider(
                                    widget.requestId,
                                    requestDetails.applicants[index]);
                                if (mounted) Navigator.pop(context);
                                setState(() {
                                  _getAllinstance();
                                });
                              },
                              onClickProfile: (int index) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ViewProfile(
                                      id: requestDetails.applicants[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          Heading2('Provider'),
                          _userProvidor == null
                              ? const Text('No provider selected')
                              : Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(3, 3, 3, 6),
                                  child: TextButton(
                                    style: themeData2().textButtonTheme.style,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ViewProfile(
                                          id: requestDetails.requestorId,
                                        ),
                                      ));
                                    },
                                    // TODO: Chnage to requestor name
                                    child: Text(_userProvidor!.name
                                        .toString()
                                        .titleCase()),
                                  ),
                                ),
                          //CustomDivider(color: themeData2().primaryColor),
                          //SizedBox(height: 8),
                          if (isCompletedVerified())
                            Column(
                              children: [
                                Heading2('The request is completed'),
                                Text(
                                    'Completed On: ${requestDetails.completedAt?.day}-${requestDetails.completedAt?.month}-${requestDetails.completedAt?.year}'),
                                Text(
                                    'Time: ${requestDetails.completedAt?.hour}:${requestDetails.completedAt?.minute}:${requestDetails.completedAt?.second}'), //completed on 2
                              ],
                            ),
                          if (isCompletedVerified() && isRated)
                            Column(
                              children: [
                                const Text('You have rated the provider.'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Payment: '),
                                    Text(
                                      '${paymentTransferred?.toStringAsFixed(2)} Time/hour',
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                TextButton(
                                    style: themeData2().textButtonTheme.style,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const RateGivenPage(),
                                      ));
                                    },
                                    child: const Text('Go to rating page'))
                              ],
                            ),
                          if (isCompletedVerified() && !isRated)
                            Column(children: [
                              const Text(
                                'Rate the provider',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: RatingBar.builder(
                                  initialRating: 0,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                  onRatingUpdate: (value) {
                                    _starRatingValue = value.toInt();
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: _commentController,
                                decoration: const InputDecoration(
                                    hintText: 'Enter comment'),
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                  style: themeData2().elevatedButtonTheme.style,
                                  onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Submit Review?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                ClientRating.rateProvider(
                                                    rating: _starRatingValue,
                                                    message:
                                                        _commentController.text,
                                                    jobId: widget.requestId,
                                                    providerId: _userProvidor!
                                                        .userUid!);

                                                Navigator.pop(context);
                                                setState(() {
                                                  _getAllinstance();
                                                });
                                              },
                                              child: const Text('Submit'),
                                            ),
                                          ],
                                        ),
                                      ),
                                  child: const Text('Rate Provider'))
                            ]),
                          if (isOngoing() && !isCompleted())
                            Column(
                              children: [
                                const Text(
                                  'The request has started',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          if (isCompleted())
                            Column(
                              children: [
                                const Text(
                                  'The provider has marked the request as completed.',
                                  textAlign: TextAlign.center,
                                ),
                                const Divider(),
                                ElevatedButton(
                                    style:
                                        themeData2().elevatedButtonTheme.style,
                                    onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title:
                                                const Text('Complete Request?'),
                                            content: const Text(
                                                'Once the request completion is verified, transaction of Time/hour will be made.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await _verifyTaskComplete(
                                                      requestDetails.id!);
                                                  Navigator.pop(context);
                                                  _getAllinstance();
                                                },
                                                child: const Text('Complete'),
                                              ),
                                            ],
                                          ),
                                        ),
                                    child: const Text('Verify Completion')),
                              ],
                            ),
                          if (_userProvidor != null && isAccepted())
                            Column(
                              children: [
                                const Text(
                                  'Start the request to record the request to the database',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                    style:
                                        themeData2().elevatedButtonTheme.style,
                                    onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Start Request'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await ClientServiceRequest
                                                      .startService(
                                                          requestDetails.id!);
                                                  Navigator.pop(context);
                                                  _getAllinstance();
                                                },
                                                child: const Text('Start'),
                                              ),
                                            ],
                                          ),
                                        ),
                                    child: const Text('Start Request')),
                              ],
                            ),

                          if (_userProvidor == null)
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete Request?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteRequest(widget.requestId);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                              child: const Text('Delete request'),
                            ),
                        ],
                      ),
                    ),
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
                  Text(requestDetails.category),
                  const Divider(),
                  Heading2('Description'),
                  Text(requestDetails.description.toString().capitalize()),
                  const Divider(),
                  Heading2('Location'),
                  Text('Address: ${requestDetails.location.address}'),
                  Text('City: ${requestDetails.location.city}'),
                  Text('State: ${requestDetails.location.state}'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: OSMFlutter(
                      controller: mapController,
                      initZoom: 16,
                      minZoomLevel: 8,
                      maxZoomLevel: 16,
                      stepZoom: 1.0,
                      markerOption: MarkerOption(
                          defaultMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 56,
                        ),
                      )),
                    ),
                  ),
                  const Divider(),
                  Heading2('Media'),
                  requestDetails.media.isEmpty
                      ? const Text('No Attachment')
                      : SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: requestDetails.media.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(
                                      '${index + 1}) ${requestDetails.media[index].toString()}'),
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
                      if (dateUpdatedOn != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Heading2('Updated On'),
                            Text(
                                'Date: ${dateUpdatedOn!.day}-${dateUpdatedOn!.month}-${dateUpdatedOn!.year}\nTime: ${dateUpdatedOn!.hour}:${dateUpdatedOn!.minute}'),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
      // FIXME: reanable edit request
      // floatingActionButton: !isLoad && isPending()
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           Navigator.of(context)
      //               .push(MaterialPageRoute(
      //                 builder: (context) => UpdatePage(id: requestDetails.id!),
      //               ))
      //               .then((value) => setState(
      //                     () {
      //                       _getAllinstance();
      //                     },
      //                   ));
      //         },
      //         tooltip: 'Edit Request',
      //         child: const Icon(Icons.edit),
      //       )
      //     : null,
    );
  }
}
