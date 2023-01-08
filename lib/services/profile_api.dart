import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';

class ProfileAPI {
  detailProfileApi() async {
    Map data = {"cookie": Session.data.getString('cookie')};
    var response = await baseAPI.postAsync(
      '$detailProfileUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  updateProfileApi(
      username, firstname, email, lastname, password, oldPass) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "first_name": firstname,
      "last_name": lastname,
      "username": username,
      if (password.isNotEmpty) "user_pass": password,
      "old_pass": oldPass
    };
    print(data);
    var response = await baseAPI.postAsync(
      '$updateProfileUrl',
      data,
      isCustom: true,
    );
    return response;
  }
}
