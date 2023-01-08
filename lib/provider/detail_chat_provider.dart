import 'package:flutter/foundation.dart';
import 'package:catalinadev/model/chat/detail_chat_model.dart';
import 'package:catalinadev/services/chat_detail_api.dart';
import 'package:catalinadev/utils/utility.dart';

class DetailChatProvider with ChangeNotifier {
  bool isLoading = false;
  bool loadingChat = true;
  List<ListChat> listChat = [];

  Future<List<ChatDetail>> getDetailChat(
      {String? chatID, String? sellerID}) async {
    List<ChatDetail> result = [];
    loadingChat = true;
    notifyListeners();
    try {
      await ChatDetailAPI().detailChat(chatID: chatID, sellerId: sellerID).then(
        (data) {
          for (var item in data) {
            result.add(ChatDetail.fromJson(item));
          }
          loadingChat = false;
          notifyListeners();
        },
      );
    } catch (e) {
      print(e);
      notifyListeners();
      return result;
    }
    notifyListeners();
    return result;
  }

  Future<List<ListChat>> getlistChat() async {
    bool result;
    isLoading = true;
    notifyListeners();
    try {
      await ChatDetailAPI().listChat().then((data) {
        listChat = [];

        for (var item in data) {
          listChat.add(ListChat.fromJson(item));
        }
        isLoading = false;
        isLoading = false;
        result = true;
        if (listChat.length == 0) {
          result = false;
        }
        printLog(result.toString());

        notifyListeners();
      });
    } catch (e) {
      result = false;
      print(e);
      notifyListeners();
    }
    return listChat;
  }

  Future<bool?> sendMessage(
      {String? message,
      String? receiverId,
      String? type,
      postID,
      String? urlImage}) async {
    bool? result;

    notifyListeners();
    try {
      await ChatDetailAPI()
          .insertChat(
        message: message,
        receiverId: receiverId,
        type: type,
        postID: postID.toString(),
        urlImage: urlImage,
      )
          .then((data) {
        print(data);
        result = true;
        notifyListeners();
      });
    } catch (e) {
      result = false;
      notifyListeners();
    }
    return result;
  }
}
