import 'package:grpc/grpc.dart';

import '../generated/collection/rating.pbgrpc.dart';
// import 'common.dart';

//'provider' 'requestor'

class ClientRating {
  //final common = Common();
  late RatingClient stub;

  ClientRating(ClientChannel channel) {
    stub = RatingClient(channel,
        options: CallOptions(timeout: const Duration(seconds: 30)));
  }

  // void main() {
  //   ratingForRequestor('291b79a7-c67c-4783-b004-239cb334804d', 3, 'nice',
  //       '92a76fc8-b000-4023-8056-5d0a962b0872');

  // }

  Future<Create_Response> ratingForRequestor(
      String author, int value, String comment, String id) async {
    return await stub.createForRequestor(Create_Request(
        rating: Create_NewRatingData()
          ..author = author
          ..value = value
          ..comment = comment
          ..requestId = id));
  }

  Future<Create_Response> ratingForProvider(
      String author, int value, String comment, String id) async {
    return await stub.createForProvider(Create_Request(
        rating: Create_NewRatingData()
          ..author = author
          ..value = value
          ..comment = comment
          ..requestId = id));
  }

  // Future<Create_Response> ratingForProvider(
  //     String author, int value, String comment, String id) async {
  //   return await stub.createForProvider(Create_Request(
  //       rating: Create_NewRatingData()
  //         ..author = author
  //         ..value = value
  //         ..comment = comment
  //         ..requestId = id));
  // }

  Future<Get_Response> getResponseRating(String key, String value) async {
    return await stub.get(Get_Request()
      ..key = key
      ..value = value);
  }

  Future<GetForRequest_Response> getForRequest1(String id) async {
    return await stub.getForRequest(GetForRequest_Request()..requestId = id);
  }

  Future<Update_Response> updateRating(String id, String ratingFor) async {
    return await stub.update(Update_Request()
      ..requestId = id
      ..ratingFor = ratingFor);
  }

  Future<GetById_Response> getbyId(String id, String ratingFor) async {
    return await stub.getById(GetById_Request()
      ..requestId = id
      ..ratingFor = ratingFor);
  }

  Future<Delete_Response> deleteRating(String id, String ratingFor) async {
    return await stub.delete(Delete_Request()
      ..requestId = id
      ..ratingFor = ratingFor);
  }
}

// void main() {
//   var client = ClientRating(Common().channel);
//   client.main();
// }
