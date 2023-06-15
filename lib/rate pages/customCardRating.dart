import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:testfyp/bin/client_user.dart';
import 'package:testfyp/bin/common.dart';
import 'package:testfyp/extension_string.dart';

import '../custom widgets/theme.dart';

class CustomCardRating extends StatefulWidget {
  final requestor;
  final value;
  final provider;
  final title; //details
  final rate;
  final ratingFor;

  const CustomCardRating({
    super.key,
    required this.requestor,
    required this.value,
    required this.provider,
    required this.title, //details /
    required this.rate,
    required this.ratingFor,
  });

  @override
  State<CustomCardRating> createState() => _CustomCardRatingState();
}

// ignore: camel_case_types
class _CustomCardRatingState extends State<CustomCardRating> {
  late dynamic _userRequestor;
  late dynamic _userProvider;
  bool isLoading = false;
  bool forProvider = false;
  @override
  void initState() {
    isLoading = true;
    getRequestorName();
    // TODO: implement initState

    super.initState();
  }

  getRequestorName() async {
    _userRequestor =
        await ClientUser(Common().channel).getUserById(widget.requestor);

    _userProvider =
        await ClientUser(Common().channel).getUserById(widget.provider);

    setState(() {
      isLoading = false;
    });
  }

  isProvider() {
    if (widget.ratingFor == 'provider') {
      return true;
    } else {
      return false;
    }
  }
  //get function => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: isLoading
          ? const Card()
          : Card(
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.title.toString().isEmpty
                              ? const Text('No comment from the requestor',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                              : Text(widget.title.toString().capitalize(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)
                                  //     Theme.of(context).textTheme.headline1,
                                  ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Author: ${_userRequestor.user.name.toString().titleCase()}",
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isProvider()
                                        ? themeData1().secondaryHeaderColor
                                        : themeData1().primaryColor,
                                    width: 2),
                                //color: Color.fromARGB(255, 219, 216, 233),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: isProvider()
                                    ? Text(
                                        'Provider\n${_userProvider.user.name.toString().titleCase()}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    : Text(
                                        'Requestor\n${_userProvider.user.name.toString().titleCase()}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12),
                                      ))),
                      )),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: 20,
                        initialRating: double.parse(widget.value.toString()),
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
                  ),
                  // Flexible(
                  //   flex: 1,
                  //   child: IconButton(
                  //       onPressed: (() {}),
                  //       icon: Icon(Icons.favorite_border_outlined)),
                  // )
                ],
              ),
            ),
    );
  }
}
