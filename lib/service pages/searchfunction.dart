import 'package:flutter/material.dart';

import '../custom widgets/custom_card_service_request.dart';
import '../request pages/requestDetails.dart';
import 'job_details.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<dynamic> listRequest;
  String user;
  CustomSearchDelegate(this.listRequest, this.user);

  isRequested(list) {
    if (list.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  changeState(state) {
    switch (state) {
      case 0:
        return 'Pending';
      case 1:
        return 'Accepted';
      case 2:
        return 'Ongoing';
      case 3:
        return 'Completed';
      case 4:
        return 'Aborted';
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<dynamic> matchQuery = [];
    for (int i = 0; i < listRequest.length; i++) {
      if (listRequest[i]['title']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())) {
        matchQuery.add(listRequest[i]);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => JobDetails(
                    requestId: matchQuery[index]['id'], user: user)));
          },
          child: CustomCardServiceRequest(
            category: matchQuery[index]['category'],
            location: matchQuery[index]['location']['state'],
            date: matchQuery[index]['date'],
            status: changeState(matchQuery[index]['state']),
            requestorId: matchQuery[index]['requestor'],
            title: matchQuery[index]['title'],
            rate: matchQuery[index]['rate'],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> matchQuery = [];
    for (int i = 0; i < listRequest.length; i++) {
      if (listRequest[i]['title']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())) {
        matchQuery.add(listRequest[i]);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => JobDetails(
                    requestId: matchQuery[index]['id'], user: user)));
          },
          child: CustomCardServiceRequest(
            category: matchQuery[index]['category'],
            location: matchQuery[index]['location']['state'],
            date: matchQuery[index]['date'],
            status: isRequested(matchQuery[index]['applicants'])
                ? 'Available'
                : changeState(matchQuery[index]['state']),
            requestorId: matchQuery[index]['requestor'],
            title: matchQuery[index]['title'],
            rate: matchQuery[index]['rate'],
          ),
        );
      },
    );
  }
}
