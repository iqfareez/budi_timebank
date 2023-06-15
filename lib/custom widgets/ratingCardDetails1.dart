import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:testfyp/custom%20widgets/theme.dart';

class RatingCardDetails1 extends StatefulWidget {
  final bool isProvider;
  final dynamic userRating;
  // final Icon icon;
  const RatingCardDetails1(
      {super.key, required this.isProvider, required this.userRating});

  @override
  State<RatingCardDetails1> createState() => _RatingCardDetails1State();
}

class _RatingCardDetails1State extends State<RatingCardDetails1> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   //print('the count is woi: ' + widget.userRating.count.toString());
  //   //print('the count is length: ' + widget.userRating.count);
  //   super.initState();
  // }

  // bool isEmpty() {
  //   if (widget.userRating.count == 0) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.isProvider
            ? themeData1().primaryColor
            : themeData1().secondaryHeaderColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white),
                      child: widget.isProvider
                          ? Icon(
                              Icons.emoji_people_rounded,
                              color: themeData1().primaryColor,
                            )
                          : Icon(
                              Icons.handshake,
                              color: themeData1().secondaryHeaderColor,
                            )),
                ),
                widget.isProvider
                    ? const Text('Provider Rating',
                        style: TextStyle(color: Colors.white, fontSize: 12))
                    : const Text('Requestor Rating',
                        style: TextStyle(color: Colors.white, fontSize: 12))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Row(
                children: [
                  const Text('Count: ',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text(widget.userRating.count.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                  const Text(' | ',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  // Text('Average: ',
                  //     style: TextStyle(color: Colors.white)),
                  RatingBar.builder(
                    allowHalfRating: true,
                    ignoreGestures: true,
                    itemSize: 15,
                    initialRating:
                        double.parse(widget.userRating.avg.toString()),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: widget.isProvider
                          ? themeData1().secondaryHeaderColor
                          : themeData1().primaryColor,
                    ),
                    onRatingUpdate: (value) {
                      //_value1Controller = value;
                      //print(_valueController);
                    },
                  ),
                  // Text(widget.userRating.avg.toString(),
                  //     style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ));
  }
}
