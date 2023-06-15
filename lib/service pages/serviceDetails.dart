import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../bin/client_rating.dart';
import '../components/constants.dart';
import '../extension_string.dart';
import '../bin/client_service_request.dart';
import '../bin/common.dart';
import '../custom widgets/heading2.dart';

class ServiceDetails extends StatefulWidget {
  //final function;
  final user;
  final id;
  final requestor;
  final provider;
  final title; //details
  final description;
  final locationName; //location
  final latitude;
  final longitude;
  final state;
  final rate;
  final applicants;
  final created;
  final updated;
  final completed;
  final media;

  const ServiceDetails(
      {super.key, //required this.function,
      required this.user,
      required this.id,
      required this.requestor,
      this.provider,
      required this.title, //details /
      required this.description,
      required this.locationName, //location
      required this.latitude,
      required this.longitude,
      required this.state,
      required this.applicants,
      required this.created,
      required this.updated,
      required this.rate,
      this.completed,
      this.media});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  //controller
  double _valueController = 0;

  final _commentController = TextEditingController();

  applyJob(String reqid, String provider) {
    ClientServiceRequest(Common().channel).applyProvider1(reqid, provider);
  }

  isNull(dynamic stuff) {
    if (stuff == '' || stuff.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  isComplete(dynamic state) {
    if (state == 'COMPLETED') {
      return true;
    } else {
      return false;
    }
  }

  // void _deleteRequest(String id) async {
  //   ClientServiceRequest(Common().channel).deleteService(id);
  // }

  void _rateRequestor(
      String author, int value, String comment, String id) async {
    ClientRating(Common().channel)
        .ratingForRequestor(author, value, comment, id);
  }

  //final rateServiceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 127, 17, 224),
        title: const Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Heading2('Id'),
            Text(widget.id),
            Heading2('Title'),
            Text(widget.title.toString().capitalize()),
            Heading2('Description'),
            Text(widget.description.toString().capitalize()),
            Heading2('Applicants'),
            isNull(widget.applicants)
                ? const Text('No Applicants')
                : Text(widget.applicants.toString()),
            Heading2('Media'),
            isNull(widget.media)
                ? const Text('No Attachment')
                : Text(widget.media.toString()),
            Heading2('Location'),
            Text(widget.locationName.toString().titleCase()),
            Text('Latitude: ' + widget.latitude),
            Text('Longitude: ' + widget.longitude),
            Heading2('Requestor'),
            Text(widget.requestor.toString().titleCase()),
            Heading2('State'),
            Text(widget.state.toString().capitalize()),
            Heading2('Created On'),
            Text(widget.created),
            Heading2('Updated On'),
            Text(widget.updated),
            Heading2('Completed On'),
            isNull(widget.completed)
                ? const Text('Not Completed')
                : Text(widget.completed),
            Heading2('Provider'),
            isNull(widget.provider)
                ? const Text('No provider yet')
                : Text(widget.provider.toString().titleCase()),
            // Heading2('Category'),
            // Text('Programming, Python, uhh'),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  // print(widget.id);
                  // print(widget.user);
                  applyJob(widget.id, widget.user);
                  context.showSnackBar(message: 'Job requested!!');
                  Navigator.of(context).pop();
                },
                child: const Text('Request Job')),
            isComplete(widget.state.toString())
                ? Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            'Rate The requestor',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: RatingBar.builder(
                              initialRating: 0,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                              onRatingUpdate: (value) {
                                _valueController = value;
                                //print(_valueController);
                              },
                            ),
                          ),
                          TextFormField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                                hintText: 'Enter comment'),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                //_valueController.toInt();
                                // int intvalue =
                                //     int.parse(_valueController.toString());
                                //print(_valueController.toString());

                                _rateRequestor(
                                    widget.user,
                                    _valueController.toInt(),
                                    _commentController.text,
                                    widget.id);
                                context.showSnackBar(
                                    message: 'Provider rated!!');
                                //print(user);
                                //applyJob(id, user);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Rate Provider')),
                        ],
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Text('Complete the job to rate the provider')),
                  )
          ],
        ),
      ),
    );
  }
}
