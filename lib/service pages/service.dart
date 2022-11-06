import 'package:flutter/material.dart';
//import 'package:testfyp/custom%20widgets/customCardService.dart';
import '../bin/client_service_request.dart';
import '../bin/common.dart';
import '../components/constants.dart';
import '../custom widgets/customCardRequest.dart';
import 'serviceRequestDetails.dart';

class ServicePage extends StatefulWidget {
  ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late Common _common;
  late bool isLoad;
  late dynamic listRequest;
  late dynamic listFiltered = [];
  late String _userCurrent;
  bool _isEmpty = false;
  //registered user (budi)
  final ammar = 'f53809c5-68e6-480c-902e-a5bc3821a003';
  final evergreen = '06a7a82f-b04f-4111-b0c9-a92d918d3207';
  final ujaiahmad = '291b79a7-c67c-4783-b004-239cb334804d';

  void initState() {
    _common = Common();
    isLoad = true;
    getinstance();

    super.initState();
  }

  getCurrentUser(String id) {
    if (id == '94dba464-863e-4551-affd-4258724ae351') {
      return ujaiahmad;
    } else if (id == 'cd54d0d0-23ef-437c-8397-c5d5d754691f') {
      return ammar; //ujai junior
    } else {
      return evergreen; //e6a7c29b-0b2d-4145-9211-a4e9b545102a
    }
  }

  void filterList() {
    print(listFiltered.length);
  }

  void getinstance() async {
    listRequest =
        await ClientServiceRequest(Common().channel).getResponse('state', '0');
    final user = supabase.auth.currentUser!.id;
    _userCurrent = getCurrentUser(user);
    for (var i = 0; i < listRequest.requests.length; i++) {
      if (listRequest.requests[i].requestor != _userCurrent) {
        listFiltered.add(listRequest.requests[i]);
      }
      //print(listFiltered);
    }
    setState(() {
      isLoad = false;
    });
  }

  bool isEmpty() {
    if (listRequest.length == 0) {
      _isEmpty == true;
      return _isEmpty;
    } else {
      _isEmpty == false;
      return _isEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Color.fromARGB(255, 127, 17, 224),
          title: Text('Service'),
        ),
        body: _isEmpty
            ? isLoad
                ? Center(child: CircularProgressIndicator())
                : Center(child: Text('No available service'))
            : ListView.builder(
                itemCount: listFiltered.length,
                itemBuilder: (context, index) {
                  return CustomCard_ServiceRequest(
                    //function: getinstance,
                    //id: listFiltered[index].id,
                    requestor: listFiltered[index].requestor,
                    //provider: listFiltered[index].provider,
                    title: listFiltered[index].details.title,
                    // description: listFiltered[index].details.description,
                    // locationName: listFiltered[index].location.name,
                    // latitude: listFiltered[index].location.coordinate.latitude,
                    // longitude:
                    //     listFiltered[index].location.coordinate.longitude,
                    // state: listFiltered[index].state,
                    rate: listFiltered[index].rate,
                    // applicants: listFiltered[index].applicants,
                    // created: listFiltered[index].createdAt,
                    // updated: listFiltered[index].updatedAt,
                    // completed: listFiltered[index].completedAt,
                    // media: listFiltered[index].mediaAttachments,
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 127, 17, 224),
          onPressed: () {
            filterList();
          },
          icon: Icon(Icons.search),
          label: Text('Find Service'),
        ));
  }
}
