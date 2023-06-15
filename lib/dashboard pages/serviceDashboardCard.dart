import 'package:flutter/material.dart';
import 'package:testfyp/bin/client_service_request.dart';
import 'package:testfyp/bin/common.dart';
import 'package:testfyp/components/constants.dart';

import 'dashboardLoadingText.dart';

class ServiceDashboardCard extends StatefulWidget {
  final isRequest;
  const ServiceDashboardCard({super.key, this.isRequest});

  @override
  State<ServiceDashboardCard> createState() => _ServiceDashboardCardState();
}

class _ServiceDashboardCardState extends State<ServiceDashboardCard> {
  late dynamic _summaryList;
  late int pending = 0;
  late int accepted = 0;
  late int ongoing = 0;
  late int completed = 0;

  late int pendingReq = 0;
  late int acceptedReq = 0;
  late int ongoingReq = 0;
  late int completedReq = 0;
  bool isLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getinstance();
  }

  _getinstance() async {
    final user = supabase.auth.currentUser!.id;

    _summaryList =
        await ClientServiceRequest(Common().channel).getSummary(user);

    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoad
              ? DashboardLoadingText(
                  isRequest: widget.isRequest,
                )
              : widget.isRequest
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Request: '),
                              Text(
                                  '${_summaryList.pending.asRequestor + _summaryList.accepted.asRequestor + _summaryList.ongoing.asRequestor + _summaryList.completed.asRequestor}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Pending: '),
                              Text('${_summaryList.pending.asRequestor}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Accepted: '),
                              Text('${_summaryList.accepted.asRequestor}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Ongoing: '),
                              Text('${_summaryList.ongoing.asRequestor}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Completed: '),
                              Text('${_summaryList.completed.asRequestor}')
                            ],
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Service: '),
                              Text(
                                  '${_summaryList.pending.asProvider + _summaryList.accepted.asProvider + _summaryList.ongoing.asProvider + _summaryList.completed.asProvider}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Pending: '),
                              Text('${_summaryList.pending.asProvider}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Accepted: '),
                              Text('${_summaryList.accepted.asProvider}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Ongoing: '),
                              Text('${_summaryList.ongoing.asProvider}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Completed: '),
                              Text('${_summaryList.completed.asProvider}')
                            ],
                          ),
                        ],
                      ),
                    ),
          //SizedBox(height: 15),
        ],
      ),
    );
  }
}
