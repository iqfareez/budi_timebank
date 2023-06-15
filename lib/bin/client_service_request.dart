import 'package:grpc/grpc.dart';
import 'package:testfyp/generated/misc.pb.dart';
import '../generated/collection/service-request.pbgrpc.dart';

class ClientServiceRequest {
  late ServiceRequestClient stub;

  ClientServiceRequest(ClientChannel channel) {
    stub = ServiceRequestClient(channel,
        options: CallOptions(timeout: const Duration(seconds: 30)));
  }

  Future<GetById_Response> getResponseById(String id) async {
    return await stub.getById(GetById_Request()..requestId = id);
  }

  Future<Get_Response> getResponse(String key, String value) async {
    return await stub.get(Get_Request()
      ..key = key
      ..value = value);
  }

  Future<Create_Response> createServiceRequest(
      String title,
      String description,
      String latitude,
      String longitude,
      String locName,
      double rate,
      List<String> media,
      String requestor,
      String category,
      double timeLimit,
      String date) async {
    return await stub.create(Create_Request(
        requestData: Create_NewServiceRequestData(
            location: ServiceRequestData_Location()
              ..address = locName
              ..state = latitude
              ..city = longitude)
          ..title = title
          ..description = description
          ..timeLimit = timeLimit
          ..date = date
          ..rate = rate
          ..mediaAttachments.addAll(media)
          ..category = category)
      ..requestor = requestor);
  }

  Future<StartService_Response> startService1(
      String reqId, String userId) async {
    return await stub.startService(StartService_Request()
      ..requestId = reqId
      ..userId = userId);
  }

  Future<Update_Response> updateService(String id, String body) async {
    return await stub.update(Update_Request()
      ..requestId = id
      ..body = body);
  }

  Future<GetAvailable_Response> getAvailable1(String by, String value) async {
    return await stub.getAvailable(GetAvailable_Request(
        filter: Filter()
          ..by = by
          ..value = value));
  }

  Future<Delete_Response> deleteService(String id) async {
    return await stub.delete(Delete_Request()..requestId = id);
  }

  Future<GetSummaryForUser_Response> getSummary(String id) async {
    return await stub
        .getSummaryForUser(GetSummaryForUser_Request()..userId = id);
  }

  Future<ApplyProvider_Response> applyProvider1(
      String id, String provider) async {
    return await stub.applyProvider(ApplyProvider_Request()
      ..requestId = id
      ..provider = provider);
  }

  Future<SelectProvider_Response> selectProvider1(
      String id, String provider, String caller) async {
    return await stub.selectProvider(SelectProvider_Request()
      ..requestId = id
      ..provider = provider
      ..caller = caller);
  }

  Future<CompleteService_Response> completeService1(
      String reqId, String userId) async {
    return await stub.completeService(CompleteService_Request()
      ..requestId = reqId
      ..userId = userId);
  }

  // Future<GetCommitment_Response> getCommitment1(String req_id) async {
  //   return await stub
  //       .getCommitment(GetCommitment_Request()..requestId = req_id);
  // }
}

// void main() {
//   final common = Common();
//   final channel = Common().channel;
//   var client = ClientServiceRequest(channel);
//   client.main();
// }
