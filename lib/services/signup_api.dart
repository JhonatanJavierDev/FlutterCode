import 'package:catalinadev/utils/globalURL.dart';

class SignUpAPI {
  signUpApi(String firstName, String? lastName, String? email, String? username,
      String? password) async {
    Map data = {
      "user_email": email,
      "user_login": email,
      "username": username,
      "user_pass": password,
      "email": email,
      "first_name": firstName,
      "last_name": lastName
    };
    var response = await baseAPI.postAsync(
      '$signUpUrl',
      data,
      isCustom: true,
    );
    return response;
  }
}
