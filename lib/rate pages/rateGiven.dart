import 'package:flutter/material.dart';
import '../db_helpers/client_rating.dart';
import '../model/rating.dart';
import 'customCardRating.dart';

import 'ratingDetails.dart';

class RateGivenPage extends StatefulWidget {
  const RateGivenPage({super.key});

  @override
  State<RateGivenPage> createState() => _RateGivenPageState();
}

class _RateGivenPageState extends State<RateGivenPage> {
  late bool isLoad;
  late List<Rating> data;

  @override
  void initState() {
    isLoad = true;
    getinstance();
    super.initState();
  }

  void getinstance() async {
    var givenRating = await ClientRating.getAllGivenRating();
    setState(() {
      data = givenRating;
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Given Rating')),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? const Center(child: Text('No rate given to other people...'))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => RatingDetails(
                                  isProvider: true,
                                  ratingDetails: data[index],
                                ),
                              ),
                            )
                            .then((value) => setState(
                                  () {
                                    //_isEmpty = true;
                                    getinstance();
                                  },
                                ));
                      },
                      child: CustomCardRating(
                        isProvider: true,
                        ratingDetails: data[index],
                      ),
                    );
                  },
                ),
    );
  }
}
