import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:catalinadev/model/account/user_model.dart';
import 'package:catalinadev/screen/pages.dart';
import 'package:catalinadev/services/auth_api.dart';
import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/utility.dart';

enum StatusAuth {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class AuthProvider with ChangeNotifier {
  StatusAuth _status = StatusAuth.Uninitialized;
  StatusAuth get status => _status;

  String? countryCode = '+62';

  Future<bool> signIn(context,
      {required String username, String? password}) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (username.isNotEmpty && password!.isNotEmpty) {
      try {
        _status = StatusAuth.Authenticating;
        await AuthAPI().loginByDefault(username, password).then((data) {
          print("log in");
          if (data['cookie'] != null) {
            _status = StatusAuth.Authenticated;
            print(json.encode(data['user']));
            UserModel user = UserModel.fromJson(data['user']);
            printLog(json.encode(user));
            Session.data.setString('password', password);
            Session().saveUser(user, data['cookie'], data['cookie_name']);
            printLog(data['cookie'], name: 'Cookie');
            Session.data.setString("login_type", 'username');

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()),
                (Route<dynamic> route) => false);
          } else {
            _status = StatusAuth.Unauthenticated;
            snackBar(context, message: data['message'], color: Colors.red);
          }
        });
        notifyListeners();
        return true;
      } catch (e) {
        _status = StatusAuth.Unauthenticated;
        notifyListeners();
        return false;
      }
    } else {
      snackBar(context, message: 'Username and password should not empty');
    }
    return false;
  }

  Future<bool> signOut(context, {bool isFromDrawer = false}) async {
    // var auth = FirebaseAuth.instance;
    // final AccessToken accessToken = await FacebookAuth.instance.accessToken;

    Session().removeUser();
    // if (auth.currentUser != null) {
    //   await GoogleSignIn().signOut();
    // }
    // if (accessToken != null) {
    //   await FacebookAuth.instance.logOut();
    // }
    // home.isReload = true;

    if (!isFromDrawer)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

    return true;
  }

  Future<bool> reLog(context, {String? username, String? password}) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    try {
      _status = StatusAuth.Authenticating;
      await AuthAPI().loginByDefault(username, password).then((data) {
        print("reLogging");
        if (data['cookie'] != null) {
          _status = StatusAuth.Authenticated;
          print(json.encode(data['user']));
          UserModel user = UserModel.fromJson(data['user']);
          printLog(json.encode(user));
          Session.data.setString('password', password!);
          Session().saveUser(user, data['cookie'], data['cookie_name']);
          printLog(data['cookie'], name: 'Cookie');
        } else {
          _status = StatusAuth.Unauthenticated;
          /*snackBar(context, message: data['message'], color: Colors.red);*/
        }
      });
      notifyListeners();
      return true;
    } catch (e) {
      _status = StatusAuth.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInOTP(context, phone) async {
    try {
      _status = StatusAuth.Authenticating;
      await AuthAPI().loginByOTP(phone).then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);
          Session.data.setBool('isLogin', true);
          Session.data.setString("cookie", responseJson['cookie']);
          Session.data.setString("login_type", 'otp');

          if (responseJson['user'] != null &&
              responseJson['user'] != "User OTP") {
            Session.data.setString("firstname", responseJson['user']);
          } else {
            Session.data.setString("firstname", responseJson['user_login']);
          }
          Session.data.setString('password', responseJson['user_pass']);
          Session.data.setString('user_otp', responseJson['user_login']);

          Session.data.setInt("id", responseJson['wp_user_id']);
          _status = StatusAuth.Authenticated;

          notifyListeners();
          return true;
        } else {
          _status = StatusAuth.Unauthenticated;
          notifyListeners();
          return false;
        }
      });
      return true;
    } catch (e) {
      _status = StatusAuth.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  setStatusAuth(value) {
    _status = value;
    notifyListeners();
  }
}
