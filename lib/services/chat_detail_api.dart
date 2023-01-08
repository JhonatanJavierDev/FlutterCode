import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';

class ChatDetailAPI {
  detailChat({String? chatID = '', String? sellerId = ''}) async {
    var url = detailChatURL;
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "chat_id": chatID,
      "seller_id": sellerId
    };
    print(data);
    var response = await baseAPI.postAsync(url, data, isCustom: true);
    print(response);
    return response;
  }

  listChat() async {
    var url = listChatURL;
    Map data = {"cookie": Session.data.getString('cookie')};
    var response = await baseAPI.postAsync(url, data, isCustom: true);
    return response;
  }

  insertChat({
    String? message = '',
    String? receiverId = '',
    String? type = '',
    String postID = '',
    String? urlImage = '',
  }) async {
    var url = insertChatURL;
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "message": message != null ? message : null,
      "post_id": postID,
      "type": type,
      "receiver_id": receiverId,
      "image": urlImage,
    };
    print("data chat");
    print(data);
    var response = await baseAPI.postAsync(url, data, isCustom: true);

    return response;
  }
}
