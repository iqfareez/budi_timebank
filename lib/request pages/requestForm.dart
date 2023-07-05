import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../components/constants.dart';
import '../custom widgets/custom_headline.dart';
import '../custom%20widgets/theme.dart';
import '../model/service_request.dart' as model;
import '../model/states_malaysia.dart' as model;
import '../shared/malaysia_states.dart';

//map API
//https://levelup.gitconnected.com/how-to-add-google-maps-in-a-flutter-app-and-get-the-current-location-of-the-user-dynamically-2172f0be53f6

class RequestForm extends StatefulWidget {
  const RequestForm({Key? key}) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  //store user input
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final _mediaController = TextEditingController();
  final _dateControllerDisplay = TextEditingController();
  final _dateController = TextEditingController();
  final _timeLimitController = TextEditingController();

  final DateTime _dateTime = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> mediaList = [];
  List<String> listCategories = <String>[
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

  DateTime? selectedDate;

  late String address;
  late String location1;
  late DateTime? newDate;
  late TimeOfDay? newTime;

  List<String> states = MalaysiaStates.allStates().map((e) => e.name!).toList();
  List<String>? citiesInSelectedState;

  // late String countryValue = '';
  String? stateValue;
  String? cityValue;

  late bool isLocationFetched;
  late bool isLoad;
  bool isDetectingLocation = false;

  @override
  void initState() {
    isLoad = false;
    isLocationFetched = false;
    _categoryController.text = listCategories[2];

    super.initState();
  }

  //get geo location
  //Flutter method to get current user latitude & longitude location
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Method to get full address from latitude & longitude co-ordinates (lat long to address)
  Future<void> getAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      final locationAddress = [
        place.name,
        place.street,
        place.subLocality,
        place.locality,
      ]
          .where((element) => element != null && element.isNotEmpty)
          .toSet()
          .toList();

      _locationController.text = locationAddress.join(', ');

      setState(() {
        // countryValue = place.country.toString();
        // cityValue = place.locality;
        stateValue = place.administrativeArea.toString();
        citiesInSelectedState = MalaysiaStates.getCitiesByState(stateValue!);
      });
      if (mounted) context.showSnackBar(message: 'Location details added');
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    // _stateController.dispose();
    // _cityController.dispose();
    // _locationController.dispose();
    _rateController.dispose();
    _mediaController.dispose();

    super.dispose();
  }

  _addmedia(String media) {
    setState(() {
      mediaList.insert(0, media);
    });
  }

  _deleteMedia(String media) {
    setState(() {
      mediaList.removeWhere((element) => element == media);
    });
  }

  _isMediaEmpty(dynamic media) {
    if (media.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Request Form'),
          // backgroundColor: Color.fromARGB(255, `1`27, 17, 224),
        ),
        body: isLoad
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                              child: CustomHeadline(heading: 'Title'),
                            ),
                            CustomHeadline(
                              heading: '*',
                              color: Colors.red,
                            )
                          ],
                        ),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Title'),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                _titleController.text == '') {
                              return 'Please enter title...';
                            }
                            return null;
                          },
                          // onFieldSubmitted: (value) {
                          //   reqList[0]['Title'] = value;
                          // },
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                              child: CustomHeadline(heading: 'Desription'),
                            ),
                            CustomHeadline(
                              heading: '*',
                              color: Colors.red,
                            )
                          ],
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter description of the job',
                            //prefixIcon: Icon(Icons.map)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description...';
                            }
                            return null;
                          },
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                              child: CustomHeadline(heading: 'Date & Time'),
                            ),
                            CustomHeadline(
                              heading: '*',
                              color: Colors.red,
                            )
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  theme: DatePickerTheme(
                                      doneStyle: TextStyle(
                                          color: themeData1().primaryColor)),
                                  showTitleActions: true,
                                  minTime: DateTime(
                                      _dateTime.year,
                                      _dateTime.month,
                                      _dateTime.day,
                                      _dateTime.hour,
                                      _dateTime.minute,
                                      _dateTime.second),
                                  maxTime:
                                      _dateTime.add(const Duration(days: 365)),
                                  onChanged: (date) {
                                //print('change $date');
                              }, onConfirm: (date) {
                                selectedDate = date;
                                _dateController.text = date.toString();
                                _dateControllerDisplay.text =
                                    'Date: ${date.day}-${date.month}-${date.year} Time: ${date.hour.toString().padLeft(2, '0')} : ${date.minute.toString().padLeft(2, '0')}';
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: const Text(
                              'Pick date & time',
                              //style: TextStyle(color: Colors.blue),
                            )),
                        const SizedBox(height: 8),
                        TextFormField(
                          enabled: false,
                          controller: _dateControllerDisplay,
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.red, // or any other color
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'Date & Time'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please pick a date & time...';
                            }
                            // else if (newDate!.hour == 0 || newDate!.minute == 0) {
                            //   return 'Pick a time';
                            // }
                            return null;
                          },
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                              child: CustomHeadline(heading: 'Category'),
                            ),
                            CustomHeadline(
                              heading: '*',
                              color: Colors.red,
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          //padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              )),
                          child: DropdownButton<String>(
                            underline: Container(
                              height: 0,
                            ),
                            iconEnabledColor: Theme.of(context).primaryColor,
                            value: _categoryController.text,
                            items: listCategories
                                .map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem<String>(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _categoryController.text = value.toString();
                                //print(_genderController.text);
                              });
                            },
                          ),
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                              child: CustomHeadline(heading: 'Location'),
                            ),
                            CustomHeadline(
                              heading: '*',
                              color: Colors.red,
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              'Enter address of the job or get current location'),
                        ),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              // helperText:
                              //     'Latitude and longitude of the location will be\nautomatically added',
                              hintText: 'Enter location address'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location...';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          value: stateValue,
                          decoration: InputDecoration(
                              // enabledBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //         color: Theme.of(context).primaryColor,
                              //         width: 2)),
                              border: const OutlineInputBorder(),
                              hintText: 'Select state'),
                          items: [
                            for (var state in states)
                              DropdownMenuItem(
                                value: state,
                                child: Text(state),
                              )
                          ],
                          onChanged: (value) {
                            setState(() {
                              stateValue = value.toString();

                              citiesInSelectedState =
                                  MalaysiaStates.getCitiesByState(stateValue!);
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          value: cityValue,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Select City'),
                          items: citiesInSelectedState == null
                              ? null
                              : [
                                  for (var city in citiesInSelectedState!)
                                    DropdownMenuItem(
                                      value: city,
                                      child: Text(city),
                                    )
                                ],
                          onChanged: (value) {
                            setState(() {
                              cityValue = value.toString();
                            });
                          },
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() => isDetectingLocation = true);

                                    Position position =
                                        await _getGeoLocationPosition();
                                    getAddressFromLatLong(position);
                                    setState(() {
                                      isLocationFetched = true;
                                      isDetectingLocation = false;
                                    });
                                  },
                                  child: isDetectingLocation
                                      ? const Text('Loading...')
                                      : const Text('Get my location')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: CustomHeadline(heading: 'Attachment'),
                        // ),
                        // Row(
                        //   // mainAxisAlignment: MainAxisAlignment.center,
                        //   // crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Expanded(
                        //       child: TextFormField(
                        //         controller: _mediaController,
                        //         decoration: InputDecoration(
                        //             helperText:
                        //                 'Enter any relevant documents \nrelated to the job',
                        //             border: OutlineInputBorder(),
                        //             hintText: 'Enter attachment'),
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.only(bottom: 40.0),
                        //       child: TextButton(
                        //           onPressed: () {
                        //             if (_mediaController.text.length == 0) {
                        //               context.showErrorSnackBar(
                        //                   message:
                        //                       'You have not entered any attachment..');
                        //             } else {
                        //               _addmedia(_mediaController.text);
                        //               _mediaController.clear();
                        //             }
                        //           },
                        //           child: Center(child: Icon(Icons.add))),
                        //     )
                        //   ],
                        // ),
                        // _isMediaEmpty(mediaList)
                        //     ? Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child:
                        //             Text('You have not entered any attachment'),
                        //       )
                        //     : SizedBox(
                        //         height: 60,
                        //         child: ListView.builder(
                        //           physics: const BouncingScrollPhysics(),
                        //           scrollDirection: Axis.horizontal,
                        //           shrinkWrap: true,
                        //           itemCount: mediaList.length,
                        //           itemBuilder: (context, index) {
                        //             return Card(
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Row(
                        //                   children: [
                        //                     Text(mediaList[index]
                        //                         .toString()
                        //                         .titleCase()),
                        //                     SizedBox(
                        //                       height: 5,
                        //                     ),
                        //                     IconButton(
                        //                         onPressed: () {
                        //                           _deleteMedia(mediaList[index]
                        //                               .toString());
                        //                         },
                        //                         icon: Icon(
                        //                           Icons.remove_circle_outline,
                        //                           color: Colors.red,
                        //                         ))
                        //                   ],
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //         )),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                              child: CustomHeadline(heading: 'Time Limit'),
                            ),
                            CustomHeadline(
                              heading: '*',
                              color: Colors.red,
                            )
                          ],
                        ),
                        TextFormField(
                          controller: _timeLimitController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              helperText: 'Time required to finish the request',
                              hintText: 'Enter time limit (hours)'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter time limit';
                            }
                            return null;
                          },
                          // onFieldSubmitted: (value) {
                          //   reqList[0]['Title'] = value;
                          // },
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                              child: CustomHeadline(heading: 'Rate'),
                            ),
                            CustomHeadline(
                              heading: '*',
                              color: Colors.red,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _rateController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter Rate',
                                    helperText:
                                        'Make sure you have enough \$ to pay'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter rate..';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // Expanded(
                            //   child: TextFormField(
                            //     controller: _titleController,
                            //     keyboardType: TextInputType.number,
                            //     decoration: InputDecoration(
                            //         border: OutlineInputBorder(),
                            //         hintText: 'Enter time limit (hours)'),
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return 'Please enter time limit';
                            //       }
                            //       return null;
                            //     },
                            //     // onFieldSubmitted: (value) {
                            //     //   reqList[0]['Title'] = value;
                            //     // },
                            //   ),
                            // ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('\$ Time/hour'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            onPressed: () async {
                              // final user = supabase.auth.currentUser!.id;
                              final user =
                                  FirebaseAuth.instance.currentUser!.uid;
                              // print(_stateController.text);
                              // print(_cityController.text);
                              //final _userCurrent = getCurrentUser(user);
                              //print(_userCurrent);
                              // print(stateValue == 'null');
                              //  else if (_cityController.text == 'null') {
                              //   context.showErrorSnackBar(
                              //       message: 'Pick a city..');
                              // }
                              if (_stateController.text == 'null') {
                                context.showErrorSnackBar(
                                    message: 'Pick a state..');
                              } else if (_formKey.currentState!.validate()) {
                                var rate = double.parse(
                                    _rateController.text); //convert to double
                                var time =
                                    double.parse(_timeLimitController.text);

                                // _submitJobForm(
                                //     _titleController.text,
                                //     _descriptionController.text,
                                //     _stateController.text,
                                //     _cityController.text,
                                //     _locationController.text,
                                //     rate,
                                //     mediaList,
                                //     user,
                                //     _categoryController.text,
                                //     time,
                                //     _dateController.text)

                                var requestorId =
                                    FirebaseAuth.instance.currentUser!.uid;

                                if (selectedDate == null) return;

                                var request = model.ServiceRequest(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  location: model.Location(
                                    address: _locationController.text,
                                    city: _cityController.text,
                                    state: _stateController.text,
                                  ),
                                  status: model.ServiceRequestStatus.pending,
                                  rate: rate,
                                  media: mediaList,
                                  requestorId: requestorId,
                                  applicants: [],
                                  category: _categoryController.text,
                                  timeLimit: time,
                                  date: selectedDate!,
                                  createdAt: DateTime.now(),
                                );

                                _submitJobForm(request);
                              }
                            },
                            child: const Text('Create Request')),
                      ],
                    ),

                    // SizedBox(
                    //   height: 20,
                    // ),
                  ),
                ),
              ));
  }

  Future<void> _submitJobForm(model.ServiceRequest serviceRequest) async {
    try {
      final CollectionReference serviceRequestCollection =
          FirebaseFirestore.instance.collection('serviceRequests');
      var docRef =
          await serviceRequestCollection.add(serviceRequest.toFirestoreMap());

      context.showSnackBar(message: 'Job Created ${docRef.id}');
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      context.showErrorSnackBar(message: '${e.message}');
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
  }
}
