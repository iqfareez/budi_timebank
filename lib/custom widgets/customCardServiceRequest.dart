import 'package:flutter/material.dart';
import 'package:testfyp/bin/client_user.dart';
import 'package:testfyp/bin/common.dart';
import 'package:testfyp/custom%20widgets/theme.dart';
import 'package:testfyp/extension_string.dart';

class CustomCardServiceRequest extends StatefulWidget {
  final requestor;
  final state;
  final title; //details
  final rate;
  final date;
  final location;
  final category;

  const CustomCardServiceRequest({
    super.key,
    required this.requestor,
    required this.title, //details /
    required this.rate,
    required this.state,
    required this.date,
    required this.location,
    required this.category,
  });

  @override
  State<CustomCardServiceRequest> createState() =>
      _CustomCardServiceRequestState();
}

// ignore: camel_case_types
class _CustomCardServiceRequestState extends State<CustomCardServiceRequest> {
  late dynamic _userCurrent;
  bool isLoading = false;

  late dynamic dateJob;

  @override
  void initState() {
    isLoading = true;
    getRequestorName();
    // TODO: implement initState
    dateJob = DateTime.parse(widget.date);
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
    _userCurrent =
        await ClientUser(Common().channel).getUserById(widget.requestor);
    // print('The current user (widget)' + widget.requestor);

    //print('The current user' + _userCurrent.toString());
    //print(_userCurrent.user.name);
    // _userCurrent = await supabase
    //     .from('profiles')
    //     .select()
    //     .eq('user_id', widget.requestor)
    //     .single() as Map;
    setState(() {
      isLoading = false;
    });
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
                                      color: changeColor(widget.state),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.state.toString(),
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
                        //SizedBox(height: 10),
                        Text(_userCurrent.user.name.toString().titleCase(),
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 10),
                        Text('${widget.location}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(
                          '${widget.rate} \$Time/hour',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('${dateJob.day}-${dateJob.month}-${dateJob.year}',
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
