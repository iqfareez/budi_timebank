import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../custom widgets/theme.dart';
import '../db_helpers/client_user.dart';
import '../extension_string.dart';
import '../model/profile.dart';
import '../model/rating.dart';

class CustomCardRating extends StatefulWidget {
  final bool isProvider;
  final Rating ratingDetails;

  const CustomCardRating({
    super.key,
    required this.isProvider,
    required this.ratingDetails,
  });

  @override
  State<CustomCardRating> createState() => _CustomCardRatingState();
}

class _CustomCardRatingState extends State<CustomCardRating> {
  late Profile _userRequestor;
  late Profile _userProvider;
  bool isLoading = true;

  void getInstance() async {
    setState(() => isLoading = true);

    // get requestor profile
    _userRequestor =
        await ClientUser.getUserProfileById(widget.ratingDetails.authorId);

    // get provider profile
    _userProvider =
        await ClientUser.getUserProfileById(widget.ratingDetails.rateeId);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getInstance();
  }

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
                          widget.ratingDetails.message == null ||
                                  widget.ratingDetails.message!.isEmpty
                              ? const Text('No comment from the requestor',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                              : Text(widget.ratingDetails.message!.capitalize(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)
                                  //     Theme.of(context).textTheme.headline1,
                                  ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Author: ${_userRequestor.name.titleCase()}",
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
                                    color: widget.isProvider
                                        ? themeData1().secondaryHeaderColor
                                        : themeData1().primaryColor,
                                    width: 2),
                                //color: Color.fromARGB(255, 219, 216, 233),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.isProvider
                                    ? Text(
                                        'Provider\n${_userProvider.name.titleCase()}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    : Text(
                                        'Requestor\n${_userRequestor.name.titleCase()}',
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
                        initialRating: widget.ratingDetails.rating.toDouble(),
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
                ],
              ),
            ),
    );
  }
}
