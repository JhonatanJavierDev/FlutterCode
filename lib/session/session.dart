import 'package:catalinadev/model/account/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static late SharedPreferences data;
  // static FirebaseMessaging messaging;

  static Future init() async {
    data = await SharedPreferences.getInstance();
    if (!data.containsKey('isIntro')) {
      data.setBool('isLogin', false);
      data.setBool('isIntro', false);
    }
  }

  Future saveUser(UserModel user, String cookie, String cookieName) async {
    data.setBool('isLogin', true);
    data.setInt("id", user.id!);
    data.setString("username", user.username!);
    data.setString("avatar", user.avatar ?? '');
    data.setString("firstname", user.firstname!);
    data.setString("lastname", user.lastname!);
    data.setString("display_name", user.displayName!);
    data.setString("nickname", user.nickname!);
    data.setString("nice_name", user.niceName!);
    data.setString("description", user.description!);
    data.setString("email", user.email!);
    data.setString("cookie", cookie);
    data.setString("cookie_name", cookieName);
    data.setString("role", user.role!.isNotEmpty ? user.role!.first : "");

    for (int i = 0; i < user.role!.length; i++) {
      if (user.role![i] == "wcfm_vendor") {
        data.setString("role", user.role![i].toString());
      }
    }

    if (user.statusApprovalVendor != null) {
      data.setString("status_approval_vendor", user.statusApprovalVendor!);
    }
  }

  void removeUser() async {
    data.setBool('isLogin', false);
    data.remove("id");
    data.remove("username");
    data.remove("avatar");
    data.remove("firstname");
    data.remove("lastname");
    data.remove("display_name");
    data.remove("nickname");
    data.remove("nice_name");
    data.remove("description");
    data.remove("email");
    data.remove("cookie");
    data.remove("role");
    data.remove("status_approval_vendor");
    data.remove("password");
  }

  Future<String?> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }

  Future checkCookieSession() async {
    if (!data.containsKey('username') && !data.containsKey('password')) {
      print("Logout User & Pass Not Exists");
      removeUser();
    }
    if (data.containsKey('cookie')) {
      if (data.getString('cookie')!.isEmpty) {
        removeUser();
      }
    } else {
      removeUser();
    }
  }
}
