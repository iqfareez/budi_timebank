import 'package:flutter/material.dart';

import '../custom%20widgets/theme.dart';
import '../db_helpers/client_rating.dart';
import '../model/rating.dart';
import 'customCardRating.dart';
import 'ratingDetails.dart';

class RateReceivedPage extends StatefulWidget {
  const RateReceivedPage({super.key});

  @override
  State<RateReceivedPage> createState() => _RateReceivedPageState();
}

class _RateReceivedPageState extends State<RateReceivedPage> {
  late bool isLoad;
  late List<Rating> data;

  @override
  void initState() {
    isLoad = true;
    getinstance();
    super.initState();
  }

  void getinstance() async {
    var receivedRating = await ClientRating.getAllReceivedRating();
    setState(() {
      data = receivedRating;
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Received Rating'),
          backgroundColor: themeData1().secondaryHeaderColor),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? const Center(child: Text('No rating received...'))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => RatingDetails(
                                      isProvider: false,
                                      ratingDetails: data[index],
                                    )))
                            .then((value) => setState(
                                  () {
                                    //_isEmpty = true;
                                    getinstance();
                                  },
                                ));
                      },
                      child: CustomCardRating(
                        isProvider: false,
                        ratingDetails: data[index],
                      ),
                    );
                  },
                ),
    );
  }
}
