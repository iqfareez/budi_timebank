import 'package:flutter/material.dart';

import '../custom widgets/theme.dart';
import '../db_helpers/client_user.dart';

class TimeBalanceCard extends StatefulWidget {
  const TimeBalanceCard({super.key});

  @override
  State<TimeBalanceCard> createState() => _TimeBalanceCardState();
}

class _TimeBalanceCardState extends State<TimeBalanceCard> {
  late Future<double> pointsFuture;

  @override
  void initState() {
    super.initState();
    pointsFuture = getPoints();
  }

  Future<double> getPoints() => ClientUser.getTotalPoints();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          //elevation: 5,
          color: themeData1().primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white),
                      child: Icon(
                        Icons.wallet,
                        color: themeData1().primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Time Balance',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder<double>(
                    future: getPoints(),
                    builder: (context, snapshot) {
                      return RichText(
                        text: TextSpan(
                          text: 'Time/hour: ',
                          style: const TextStyle(color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                              text: snapshot.hasData
                                  ? snapshot.data?.toStringAsFixed(2)
                                  : '....',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ],
          )),
    );
  }
}
