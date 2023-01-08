import 'package:flutter/foundation.dart';
import 'package:catalinadev/model/notification/list_notification_model.dart';
import 'package:catalinadev/services/list_notification_api.dart';

class ListNotificationProvider with ChangeNotifier {
  bool loading = true;
  bool loadingAll = true;
  bool loadingSub = false;
  List<ListNotification> listNotif = [];

  Future<bool> getListNotification({type}) async {
    try {
      loading = true;
      listNotif = [];
      notifyListeners();
      await ListNotificationAPI().listNotification(type).then((data) {
        for (Map item in data) {
          listNotif
              .add(ListNotification.fromJson(item as Map<String, dynamic>));
        }
        loading = false;
        notifyListeners();
        return true;
      });
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      loading = false;
      return false;
    }
  }

  Future<bool> sendNotification({token}) async {
    try {
      await ListNotificationAPI().sendTokenToDB(token).then((data) {
        notifyListeners();
        return true;
      });
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }
}
