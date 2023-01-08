import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';

class ListNotificationAPI {
  listNotification(String? type) async {
    var url = listNotificationURL;
    Map data = {"cookie": Session.data.getString('cookie'), "type": type};
    print(data);
    var response = await baseAPI.postAsync(
      '$url',
      data,
      isCustom: true,
    );
    print(response);
    return response;
  }

  sendTokenToDB(String? token) async {
    var url = pushNotificationURL;
    Map data = {"cookie": Session.data.getString('cookie'), "token": token};
    var response = await baseAPI.postAsync(url, data, isCustom: true);
    return response;
  }
}
