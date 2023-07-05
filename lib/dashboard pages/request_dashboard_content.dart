import 'package:flutter/material.dart';

import '../db_helpers/client_service_request.dart';

class RequestDashboardContent extends StatefulWidget {
  const RequestDashboardContent({super.key});

  @override
  State<RequestDashboardContent> createState() =>
      _RequestDashboardContentState();
}

class _RequestDashboardContentState extends State<RequestDashboardContent> {
  late int pending, accepted, ongoing, completed, total;

  bool isLoad = true;

  @override
  void initState() {
    super.initState();
    _getinstance();
  }

  _getinstance() async {
    var summaryValues = await ClientServiceRequest.getRequestorSummary();
    pending = summaryValues.$1;
    accepted = summaryValues.$2;
    ongoing = summaryValues.$3;
    completed = summaryValues.$4;

    total = pending + accepted + ongoing + completed;

    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Request: '),
              Text(isLoad ? '...' : total.toString())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending: '),
              Text(isLoad ? '...' : pending.toString())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Accepted: '),
              Text(isLoad ? '...' : accepted.toString())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ongoing: '),
              Text(isLoad ? '...' : ongoing.toString())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Completed: '),
              Text(isLoad ? '...' : completed.toString())
            ],
          ),
        ],
      ),
    );
  }
}
