import 'package:flutter/material.dart';
import 'package:catalinadev/model/account/user_model.dart';
import 'package:catalinadev/model/basic_response.dart';
import 'package:catalinadev/services/profile_api.dart';
import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';
import 'package:catalinadev/utils/utility.dart';

enum StatusUpdate { Uninitialized, Updating, Updated, Failed }

class ProfileProvider with ChangeNotifier {
  StatusUpdate _status = StatusUpdate.Uninitialized;
  StatusUpdate get status => _status;

  bool loadDetail = false;
  bool loadDelete = false;

  Future<bool> fetchUserDetail(context) async {
    try {
      loadDetail = true;
      await ProfileAPI().detailProfileApi().then((data) {
        if (data['user'] != null) {
          UserModel user = UserModel.fromJson(data['user']);
          Session().saveUser(user, Session.data.getString('cookie')!,
              Session.data.getString('cookie_name')!);
          loadDetail = false;
        } else {
          snackBar(context, message: data['message'], color: Colors.red);
          loadDetail = false;
        }
      });
      notifyListeners();
      return true;
    } catch (e) {
      loadDetail = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(context,
      {String? firstname,
      String? lastname,
      String? email,
      String? username,
      required String password,
      String? rePassword,
      String? oldPass}) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (password.isNotEmpty) {
      if (password != rePassword) {
        return snackBar(context,
            message: "Your password doesn't match", color: Colors.red);
      }
    }

    try {
      _status = StatusUpdate.Updating;
      await ProfileAPI()
          .updateProfileApi(
              username, firstname, email, lastname, password, oldPass)
          .then((data) {
        print(data);
        if (data['cookie'] != null) {
          _status = StatusUpdate.Updated;
          Session.data.setString('cookie', data['cookie']);
          Session.data.setString("firstname", firstname!);
          Session.data.setString("lastname", lastname!);
          snackBar(context,
              message: "Success updating profile", color: Colors.green);
        } else {
          _status = StatusUpdate.Failed;
          snackBar(context, message: data['message'], color: Colors.red);
        }
      });
      notifyListeners();
      return true;
    } catch (e) {
      _status = StatusUpdate.Failed;
      notifyListeners();
      return false;
    }
  }

  Future<BasicResponse?> deleteAccount() async {
    BasicResponse? _result;
    try {
      loadDelete = true;
      Map data = {
        "cookie": Session.data.getString('cookie'),
      };
      print(data);
      var response = await baseAPI.postAsync(
        'delete-account',
        data,
        isCustom: true,
      );
      if (response != null) {
        printLog(response.toString(), name: 'Response Delete Account');
        loadDelete = false;
        if (response['status'] == "success") {
          _result = BasicResponse(200, response['message']);
        } else {
          _result = BasicResponse(500, response['message']);
        }
        notifyListeners();
      }
      return _result;
    } catch (e) {
      printLog(e.toString(), name: "Error");
      _result = BasicResponse(500, e.toString());
      notifyListeners();
      return _result;
    }
  }
}
