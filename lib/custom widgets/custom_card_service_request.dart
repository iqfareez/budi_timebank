import 'package:flutter/material.dart';

import '../db_helpers/client_user.dart';
import '../my_extensions/extension_datetime.dart';
import '../my_extensions/extension_string.dart';
import '../model/profile.dart';
import '../model/service_request.dart';
import 'theme.dart';

class CustomCardServiceRequest extends StatefulWidget {
  final String requestorId;
  final ServiceRequestStatus status;
  final String title; //details
  final String rate;
  final DateTime date;
  final Location location;
  final String category;

  const CustomCardServiceRequest({
    super.key,
    required this.requestorId,
    required this.title, //details /
    required this.rate,
    required this.status,
    required this.date,
    required this.location,
    required this.category,
  });

  @override
  State<CustomCardServiceRequest> createState() =>
      _CustomCardServiceRequestState();
}

class _CustomCardServiceRequestState extends State<CustomCardServiceRequest> {
  late Profile _userCurrent;
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    getRequestorName();
    super.initState();
  }

  changeColor(state) {
    switch (state) {
      case 'Available':
        return const Color.fromARGB(255, 163, 223, 66);
      case 'Pending':
        return const Color.fromARGB(255, 0, 146, 143);
      case 'Accepted':
        return const Color.fromARGB(255, 199, 202, 11);
      case 'Ongoing':
        return const Color.fromARGB(255, 213, 159, 15);
      case 'Completed (Rated)':
        return const Color.fromARGB(255, 89, 175, 89);
      case 'Completed (Unrated)':
        return themeData2().secondaryHeaderColor;
      default:
        return const Color.fromARGB(255, 127, 124, 139);
    }
  }

  getRequestorName() async {
    _userCurrent = await ClientUser.getUserProfileById(widget.requestorId);

    setState(() => isLoading = false);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 4,
                              fit: FlexFit.tight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.work_outline_rounded),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                            widget.title
                                                .toString()
                                                .capitalize(),
                                            //overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)
                                            //     Theme.of(context).textTheme.headline1,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(widget.category,
                                      style: const TextStyle(fontSize: 11)),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: changeColor(
                                          widget.status.name.titleCase()),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.status.name.titleCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        const Divider(),
                        Text(_userCurrent.name.toString().titleCase(),
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 10),
                        Text(widget.location.address,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(
                          '\$ ${widget.rate} Time/hour',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(widget.date.formatDate(),
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
