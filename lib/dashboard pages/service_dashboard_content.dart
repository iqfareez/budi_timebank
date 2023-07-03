import 'package:flutter/material.dart';

import '../db_helpers/client_service_request.dart';

class ServiceDashboardContent extends StatefulWidget {
  const ServiceDashboardContent({super.key});

  @override
  State<ServiceDashboardContent> createState() =>
      _ServiceDashboardContentState();
}

class _ServiceDashboardContentState extends State<ServiceDashboardContent> {
  late int pending, accepted, ongoing, completed, total;

  bool isLoad = true;

  @override
  void initState() {
    super.initState();
    _getinstance();
  }

  _getinstance() async {
    var summaryValues = await ClientServiceRequest.getServicesSummary();
    pending = summaryValues[0];
    accepted = summaryValues[1];
    ongoing = summaryValues[2];
    completed = summaryValues[3];

    total = pending + accepted + ongoing + completed;

    setState(() => isLoad = false);
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
              const Text('Total Service: '),
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
