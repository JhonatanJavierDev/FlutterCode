import 'package:catalinadev/utils/globalURL.dart';

class AuthAPI {
  loginByDefault(String? username, String? password) async {
    Map data = {'username': username, 'password': password};
    var response = await baseAPI.postAsync(
      '$loginDefault',
      data,
      isCustom: true,
    );
    return response;
  }

  loginByOTP(phone) async {
    var response =
        await baseAPI.getAsync('$signInOTP?phone=$phone', isCustom: true);
    return response;
  }
}
