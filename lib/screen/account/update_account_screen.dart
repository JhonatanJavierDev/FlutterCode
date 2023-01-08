part of '../pages.dart';

class UpdateAccountScreen extends StatefulWidget {
  final bool isEditing;
  UpdateAccountScreen({this.isEditing = false});
  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  bool _notShowPassword = true;
  bool _notShowRePassword = true;
  bool _notShowCurrPassword = true;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController currPassword = new TextEditingController();
  TextEditingController firstname = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController rePassword = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDetail();
    });
  }

  void validateAndSave() async {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    final form = _formKey.currentState!;
    if (form.validate()) {
      this.setState(() {});
      await profile
          .updateProfile(
        context,
        firstname: firstname.text,
        email: email.text,
        lastname: lastname.text,
        rePassword: rePassword.text,
        username: username.text,
        password: password.text,
        oldPass: currPassword.text,
      )
          .then((value) {
        if (password.text.isNotEmpty && rePassword.text.isNotEmpty) {
          if (password.text == rePassword.text) {
            Session.data.setString('password', password.text);
          }
        }
        loadDetail();
      });
      currPassword.clear();
      password.clear();
      rePassword.clear();
      print('Form is valid');
    } else {
      print('form is invalid');
    }
  }

  loadDetail() async {
    setState(() {});
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    await profile.fetchUserDetail(context).then((value) {
      setState(() {
        firstname.text = Session.data.getString('firstname')!;
        lastname.text = Session.data.getString('lastname')!;
        username.text = Session.data.getString('username')!;
        email.text = Session.data.getString('email')!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
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
          ' ${AppLocalizations.of(context)!.translate("update_profile")}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: ListenableProvider.value(
        value: profile,
        child: Consumer<ProfileProvider>(builder: (context, value, child) {
          if (value.loadDetail) {
            return Center(
              child: customLoading(),
            );
          }
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                  Line(
                    color: greyLine,
                    height: 1,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                          disable: false,
                        ),
                        LabelTxt(
                          txt: AppLocalizations.of(context)!
                              .translate("user_name"),
                        ),
                        GreyText(
                          hintText: AppLocalizations.of(context)!
                              .translate("entr_username"),
                          controllerTxt: username,
                          disable: false,
                        ),
                      ],
                    ),
                  ),
                  Line(
                    color: greyLine,
                    height: 1,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelTxt(
                          txt: AppLocalizations.of(context)!
                              .translate('curr_pass')!,
                        ),
                        GreyText(
                          password: true,
                          hintText: AppLocalizations.of(context)!
                              .translate("enter_pswrd"),
                          controllerTxt: currPassword,
                          showPassword: _notShowCurrPassword,
                          isRequired: false,
                        ),
                        LabelTxt(
                          txt: AppLocalizations.of(context)!.translate("pswrd"),
                        ),
                        GreyText(
                          password: true,
                          hintText: AppLocalizations.of(context)!
                              .translate("enter_pswrd"),
                          controllerTxt: password,
                          showPassword: _notShowPassword,
                          isRequired: false,
                        ),
                        LabelTxt(
                          txt: AppLocalizations.of(context)!
                              .translate("re_pswrd"),
                        ),
                        GreyText(
                          password: true,
                          hintText: AppLocalizations.of(context)!
                              .translate("enter_pswrd"),
                          controllerTxt: rePassword,
                          showPassword: _notShowRePassword,
                          isRequired: false,
                        ),
                      ],
                    ),
                  ),
                  profile.status == StatusUpdate.Updating
                      ? Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: customLoading(),
                        )
                      : Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            color: accentColor,
                            onPressed: () async {
                              validateAndSave();
                              // this.setState(() {});
                              // await profile
                              //     .updateProfile(context,
                              //         firstname: firstname.text,
                              //         email: email.text,
                              //         lastname: lastname.text,
                              //         rePassword: rePassword.text,
                              //         username: username.text,
                              //         password: password.text)
                              //     .then((value) {
                              //   loadDetail();
                              // });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("update")!,
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ),
                        ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: MaterialButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Colors.grey,
                      onPressed: () async {
                        _showAlertDeleteAccount();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          "Delete Account",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showAlertDeleteAccount() {
    SimpleDialog alert = SimpleDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              TextStyles(
                value: "Do you want to delete your account?",
                size: 16,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              TextStyles(
                value: "Warning! This action cannot be reversed.",
                size: 14,
                isLine: false,
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        height: 40,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: TextStyles(
                          value: AppLocalizations.of(context)!.translate("no")!,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(width: 8),
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: accentColor),
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        height: 40,
                        onPressed: () async {
                          Navigator.pop(context);
                          _showAlertDeleteConfirmation();
                        },
                        child: TextStyles(
                          value:
                              AppLocalizations.of(context)!.translate("yes")!,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showAlertDeleteConfirmation() {
    SimpleDialog alert = SimpleDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              TextStyles(
                value: "Final Confirmation :",
                size: 16,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              TextStyles(
                value: "Do you want to delete your account?",
                size: 14,
                weight: FontWeight.bold,
                isLine: false,
              ),
              TextStyles(
                value: "Warning! This action cannot be reversed.",
                size: 14,
                isLine: false,
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        height: 40,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: TextStyles(
                          value: AppLocalizations.of(context)!.translate("no")!,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(width: 8),
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: accentColor),
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        height: 40,
                        onPressed: () async {
                          Navigator.pop(context);
                          UIBlock.block(context);
                          context
                              .read<ProfileProvider>()
                              .deleteAccount()
                              .then((value) {
                            if (value!.statusCode == 200) {
                              UIBlock.unblock(context);
                              context.read<AuthProvider>().signOut(context);
                              snackBar(context,
                                  message: "Successfully delete your account");
                            } else if (value.statusCode == 500) {
                              UIBlock.unblock(context);
                              snackBar(context, message: value.message!);
                            } else {
                              UIBlock.unblock(context);
                              snackBar(context,
                                  message: AppLocalizations.of(context)!
                                      .translate("error_occurred")!);
                            }
                          });
                        },
                        child: TextStyles(
                          value:
                              AppLocalizations.of(context)!.translate("yes")!,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
