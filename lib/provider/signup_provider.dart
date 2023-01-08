import 'package:flutter/material.dart';
import 'package:catalinadev/services/signup_api.dart';
import 'package:catalinadev/utils/shared.dart';
import 'package:catalinadev/utils/utility.dart';

enum StatusReg { Uninitialized, Registered, Registering, Unregistered }

class SignUpProvider with ChangeNotifier {
  StatusReg _status = StatusReg.Uninitialized;
  StatusReg get status => _status;

  Future<bool> signUp(context, bool agree,
      {required String firstname,
      String? lastname,
      String? email,
      String? username,
      String? password,
      String? rePassword}) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (firstname.isNotEmpty &&
        lastname!.isNotEmpty &&
        email!.isNotEmpty &&
        username!.isNotEmpty &&
        password!.isNotEmpty &&
        rePassword!.isNotEmpty) {
      if (password == rePassword) {
        if (agree) {
          try {
            _status = StatusReg.Registering;
            await SignUpAPI()
                .signUpApi(firstname, lastname, email, username, password)
                .then((data) {
              if (data['cookie'] != null) {
                _status = StatusReg.Registered;

                Navigator.pop(context);
                snackBar(context,
                    message: AppLocalizations.of(context)!
                        .translate("regis_sucess")!,
                    color: Colors.green);
              } else {
                _status = StatusReg.Unregistered;
                snackBar(context,
                    message:
                        data['message'] == "E-mail address is already in use."
                            ? AppLocalizations.of(context)!
                                .translate("email_already")!
                            : data['message'],
                    color: Colors.red);
              }
            });
            notifyListeners();
            return true;
          } catch (e) {
            _status = StatusReg.Unregistered;
            notifyListeners();
            return false;
          }
        } else {
          snackBar(context,
              message: AppLocalizations.of(context)!.translate("must_agree")!);
        }
      } else {
        snackBar(context,
            message: AppLocalizations.of(context)!.translate("pass_not_match")!,
            color: Colors.red);
      }
    } else {
      snackBar(context,
          message: "All form field should not be empty", color: Colors.red);
    }
    return true;
  }
}
