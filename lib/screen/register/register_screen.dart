part of '../pages.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _checked = false;
  bool _notShowPassword = true;
  bool _notShowRePassword = true;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController firstname = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController rePassword = new TextEditingController();

  void validateAndSave() async {
    final register = Provider.of<SignUpProvider>(context, listen: false);
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (_checked != true) {
        snackBar(context,
            message: AppLocalizations.of(context)!.translate("must_agree")!,
            color: Colors.redAccent);
      } else {
        await register
            .signUp(context, _checked,
                firstname: firstname.text,
                email: email.text,
                lastname: lastname.text,
                rePassword: rePassword.text,
                username: username.text,
                password: password.text)
            .then((value) => this.setState(() {}));
      }
      print('Form is valid');
    } else {
      print('form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    final register = Provider.of<SignUpProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
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
          AppLocalizations.of(context)!.translate("register")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelTxt(
                          txt: AppLocalizations.of(context)!
                              .translate("first_name"),
                        ),
                        GreyText(
                          hintText: AppLocalizations.of(context)!
                              .translate("entr_firstname"),
                          controllerTxt: firstname,
                        ),
                        LabelTxt(
                          txt: AppLocalizations.of(context)!
                              .translate("last_name"),
                        ),
                        GreyText(
                          hintText: AppLocalizations.of(context)!
                              .translate("entr_lastname"),
                          controllerTxt: lastname,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.grey[100],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelTxt(
                          txt: AppLocalizations.of(context)!.translate("email"),
                        ),
                        GreyText(
                          hintText: AppLocalizations.of(context)!
                              .translate("entr_email"),
                          controllerTxt: email,
                        ),
                        LabelTxt(
                          txt: AppLocalizations.of(context)!
                              .translate("user_name"),
                        ),
                        GreyText(
                          hintText: AppLocalizations.of(context)!
                              .translate("entr_username"),
                          controllerTxt: username,
                        ),
                        LabelTxt(
                          txt: AppLocalizations.of(context)!.translate("pswrd"),
                        ),
                        GreyText(
                          hintText: AppLocalizations.of(context)!
                              .translate("enter_pswrd"),
                          showPassword: _notShowPassword,
                          controllerTxt: password,
                          passwordRegister: true,
                          password: true,
                        ),
                        LabelTxt(
                          txt: AppLocalizations.of(context)!
                              .translate("re_pswrd"),
                        ),
                        GreyText(
                          hintText: AppLocalizations.of(context)!
                              .translate("enter_pswrd"),
                          showPassword: _notShowRePassword,
                          controllerTxt: rePassword,
                          passwordRegister: true,
                          password: true,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 8, bottom: 8),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _checked = !_checked;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Icon(
                                      _checked
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: accentColor),
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate("i_agree")!,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TermCondition(type: "policy"),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: TextStyles(
                                        value:
                                            " ${AppLocalizations.of(context)!.translate("privacy_police")}",
                                        size: 11,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: TextStyles(
                                      value:
                                          " ${AppLocalizations.of(context)!.translate("and")}",
                                      size: 11,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TermCondition(type: "term"),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: TextStyles(
                                        value:
                                            " ${AppLocalizations.of(context)!.translate("term_cond")}",
                                        size: 11,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                        register.status == StatusReg.Registering
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
                                  onPressed: () async {
                                    this.setState(() {});
                                    validateAndSave();
                                    // await register
                                    //     .signUp(context, _checked,
                                    //         firstname: firstname.text,
                                    //         email: email.text,
                                    //         lastname: lastname.text,
                                    //         rePassword: rePassword.text,
                                    //         username: username.text,
                                    //         password: password.text)
                                    //     .then((value) => this.setState(() {}));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("register")!,
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!
                            .translate("have_account")!),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            " ${AppLocalizations.of(context)!.translate("login")}",
                            style: TextStyle(
                                color: tittleColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
