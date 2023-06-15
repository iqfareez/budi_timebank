import 'package:grpc/grpc.dart';

import '../generated/auth.pbgrpc.dart';
import '../generated/user.pb.dart';

class ClientAuth {
  late AuthClient stub;

  ClientAuth(ClientChannel channel) {
    stub = AuthClient(channel,
        options: CallOptions(timeout: const Duration(seconds: 30)));
  }

  Future<SignUp_Response> signUpUser(
      String email, String password, NewUserProfile profile) async {
    return await stub.signUp(SignUp_Request()
      ..email = email
      ..password = password
      ..profile = profile);
  }

  // Future<SignIn_Response> signInUser(String email, String password) async {
  //   return await stub.signIn(SignIn_Request(
  //       payload: SignIn_Payload()
  //         ..email = email
  //         ..password = password));
  // }
}
