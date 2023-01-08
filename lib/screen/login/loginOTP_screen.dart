part of '../pages.dart';

class LoginOTPScreen extends StatefulWidget {
  @override
  _LoginOTPScreenState createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  bool otpInvalid = false;
  int? _forceResendingToken;
  TextEditingController phone = new TextEditingController();
  loginOTP(var _phone) async {
    await Provider.of<AuthProvider>(context, listen: false)
        .signInOTP(context, _phone)
        .then((value) {
      if (Session.data.getString('cookie') != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    signInOTP(String phoneNumber, AuthProvider loginProvider) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FocusScopeNode currentFocus = FocusScope.of(context);
      var countryCode =
          Provider.of<AuthProvider>(context, listen: false).countryCode!;

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (phoneNumber.startsWith('0') && countryCode == "+53") {
        phoneNumber = phoneNumber.substring(1);
      }

      var phone =
          Provider.of<AuthProvider>(context, listen: false).countryCode! +
              phoneNumber;
      var phoneUser = Provider.of<AuthProvider>(context, listen: false)
              .countryCode!
              .replaceAll("+", "") +
          phoneNumber;

      await auth
          .verifyPhoneNumber(
            phoneNumber: phone,
            timeout: Duration(minutes: 1),
            verificationCompleted: (credential) {
              print("completed $credential");
            },
            verificationFailed: (e) {
              print(e.message);
              snackBar(context, message: e.message!, color: Colors.red);
              setState(() {
                loginProvider.setStatusAuth(StatusAuth.Unauthenticated);
              });
            },
            forceResendingToken: _forceResendingToken,
            codeSent: (verificationId, [forceResendingToken]) async {
              _forceResendingToken = forceResendingToken;
              final code = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InputOTP(phone: phoneNumber)));
              if (code != null) {
                print(code);
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: code);
                await auth
                    .signInWithCredential(phoneAuthCredential)
                    .then((value) async {
                  if (value.user!.uid != '') {
                    /*If Success*/
                    print('Success');
                    loginOTP(phoneUser);
                  }
                }).catchError((error) {
                  print(error);
                  print('Failed');
                  snackBar(context,
                      message: AppLocalizations.of(context)!
                          .translate('otp_invalid')!,
                      color: Colors.red);
                  setState(() {
                    otpInvalid = true;
                    loginProvider.setStatusAuth(StatusAuth.Unauthenticated);
                  });
                });
              } else {
                setState(() {
                  otpInvalid = true;
                  loginProvider.setStatusAuth(StatusAuth.Unauthenticated);
                });
                snackBar(context,
                    message: AppLocalizations.of(context)!
                        .translate("login_otp_cancel")!);
              }
            },
            codeAutoRetrievalTimeout: (verificationId) {
              print('timeout');
            },
          )
          .then((value) => this.setState(() {}));
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.18),
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 18,
            ),
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.translate("title_login_otp")!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .translate("enter_active_phone_number")!,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  AppLocalizations.of(context)!.translate("phone_number")!,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: 8,
                      ),
                      width: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        border: Border.all(
                          width: 1,
                          color: accentColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: CountryCodePicker(
                        padding: const EdgeInsets.all(0),
                        alignLeft: true,
                        onChanged: (e) {
                          Provider.of<AuthProvider>(context, listen: false)
                              .countryCode = e.dialCode;
                          print(e);
                        },
                        initialSelection:
                            Provider.of<AuthProvider>(context, listen: false)
                                .countryCode,
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,

                        textStyle: TextStyle(
                          color: Colors.black,
                        ),
                        flagWidth: 30,

                        // favorite: ['+62', 'ID'],
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        // scrollPadding: EdgeInsets.only(bottom: widget.paddingScroll),
                        controller: phone,
                        style: TextStyle(color: Colors.black),

                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: accentColor,
                                width: 1,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: 20),
                            focusedBorder: borderSide,
                            border: borderSide,
                            hintStyle: TextStyle(color: Colors.black26),
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: AppLocalizations.of(context)!
                                .translate("enter_phone_number")),

                        validator: (value) {
                          print("value");
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .translate("empty");
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
              auth.status == StatusAuth.Authenticating
                  ? Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: customLoading(),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: MaterialButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        color: accentColor,
                        onPressed: auth.status == StatusAuth.Authenticating
                            ? null
                            : () async {
                                if (phone.text.isNotEmpty) {
                                  setState(() {
                                    otpInvalid = false;
                                  });
                                  this.setState(() {
                                    auth.setStatusAuth(
                                        StatusAuth.Authenticating);
                                  });
                                  await signInOTP(phone.text, auth);
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            AppLocalizations.of(context)!.translate("login")!,
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
