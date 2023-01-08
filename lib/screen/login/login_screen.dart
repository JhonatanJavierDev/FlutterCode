part of '../pages.dart';

class LoginScreen extends StatefulWidget {
  final bool fromHome;
  final bool isLogin;
  LoginScreen({this.fromHome = false, this.isLogin = true});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool notShowPassword = true;

  Future<bool> _willPopCallback() async {
    if (widget.isLogin == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      Navigator.pop(context);
    }
    return true;
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.18),
          titleSpacing: 0,
          leading: widget.fromHome
              ? null
              : IconButton(
                  onPressed: () {
                    if (widget.isLogin == false) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                      return;
                    }
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
            AppLocalizations.of(context)!.translate("login")!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: GestureDetector(
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.white,
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelTxt(
                          txt: AppLocalizations.of(context)!.translate("email"),
                        ),
                        GreyText(
                          hintText: AppLocalizations.of(context)!
                              .translate("entr_email"),
                          controllerTxt: username,
                        ),
                        LabelTxt(
                          txt: AppLocalizations.of(context)!.translate("pswrd"),
                        ),
                        GreyText(
                          password: true,
                          hintText: AppLocalizations.of(context)!
                              .translate("enter_pswrd"),
                          controllerTxt: password,
                          showPassword: notShowPassword,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => ForgotPasswordScreen(),
                        //       ),
                        //     );
                        //   },
                        //   child: Container(
                        //     width: double.infinity,
                        //     child: Text(
                        //       "Forgot Password ?",
                        //       style: TextStyle(
                        //           color: tittleColor,
                        //           fontWeight: FontWeight.bold),
                        //       textAlign: TextAlign.right,
                        //     ),
                        //   ),
                        // ),
                        auth.status == StatusAuth.Authenticating
                            ? Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 16),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: customLoading(),
                              )
                            : Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 16),
                                child: MaterialButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: accentColor,
                                  onPressed:
                                      auth.status == StatusAuth.Authenticating
                                          ? null
                                          : () async {
                                              this.setState(() {});
                                              await auth
                                                  .signIn(context,
                                                      username: username.text,
                                                      password: password.text)
                                                  .then((value) =>
                                                      this.setState(() {}));
                                            },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("login")!,
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 5,
                    color: Colors.grey[100],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          width: double.infinity,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!
                                    .translate("havent_account")!),
                                GestureDetector(
                                  child: Text(
                                    " ${AppLocalizations.of(context)!.translate("register")}",
                                    style: TextStyle(
                                        color: tittleColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  /*GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginOTPScreen(),
                        ),
                      );
                    },
                    //child: SignInMethod(
                    //img: 'assets/images/logoBrand/OTP.png',
                    //text: AppLocalizations.of(context)!.translate("sign_otp"),
                    //),
                  ),*/
                  //SignInMethod(
                  //   img: 'assets/images/logoBrand/GOOGLE.png',
                  //   text: "Sign in with Google",
                  //),
                  // SignInMethod(
                  //   img: 'assets/images/logoBrand/FACEBOOK.png',
                  //   text: "Sign in with Facebook",
                  // ),
                  // SignInMethod(
                  //   img: 'assets/images/logoBrand/APPLE.png',
                  //   text: "Sign in with Apple",
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
