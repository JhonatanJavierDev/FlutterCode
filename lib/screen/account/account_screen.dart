part of '../pages.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool loadingStore = true;

  Future<dynamic> refresh() async {
    this.setState(() {});
  }

  refreshVendor() {
    this.setState(() {
      snackBar(context,
          message:
              AppLocalizations.of(context)!.translate("regis_store_success")!,
          color: Colors.green[300]);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print(Session.data.getString('role'));
      print(Session.data.getString('status_approval_vendor'));

      if (Session.data.getBool('isLogin')!) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth
            .reLog(context,
                username: Session.data.getString('login_type') == 'otp'
                    ? Session.data.getString('user_otp')
                    : Session.data.getString('email'),
                password: Session.data.getString('password'))
            .then((value) => refresh());
      }
      setState(() {
        loadingStore = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.18),
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("account")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loadingStore
                ? Container(
                    child: customLoading(),
                    height: 50,
                  )
                : LayoutBuilder(
                    builder: (_, constraint) {
                      if (Session.data.getString('role') != 'wcfm_vendor' &&
                          Session.data.getString('cookie') != null) {
                        if (Session.data.getString('status_approval_vendor') ==
                            'requested') {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("set_store"),
                                  size: 14,
                                  weight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0xFF1565C0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "$iconTag/register_toko.png",
                                      width: 23,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate("store_in_moderation")!,
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("set_store"),
                                  size: 14,
                                  weight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: MaterialButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  color: Color(0xFF1565C0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditStoreScreen(),
                                      ),
                                    ).then((value) {
                                      if (value == 200) {
                                        refreshVendor();
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "$iconTag/register_toko.png",
                                            width: 23,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("regis_store")!,
                                            style:
                                                TextStyle(color: primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else if (Session.data.getString('role') ==
                              'wcfm_vendor' &&
                          Session.data.getString('cookie') != null) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("set_store"),
                                  size: 14,
                                  weight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                              AccountStyle(
                                value: AppLocalizations.of(context)!
                                    .translate("manage_prod"),
                                icon: "fluent_box-16-filled.png",
                                arrow: true,
                                id: 9,
                              ),
                              AccountStyle(
                                value: AppLocalizations.of(context)!
                                    .translate("manage_order"),
                                icon: "icon-park-outline_transaction-order.png",
                                arrow: true,
                                id: 10,
                              ),
                              AccountStyle(
                                value: AppLocalizations.of(context)!
                                    .translate("manage_store"),
                                icon: "ic_Manage store.png",
                                arrow: true,
                                intNotif: "50",
                                id: 11,
                              ),
                              AccountStyle(
                                value: AppLocalizations.of(context)!
                                    .translate("manage_shipping"),
                                icon: "ic_Manage-shipping.png",
                                arrow: true,
                                id: 17,
                              ),
                            ],
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
            Session.data.getString('role') != 'wcfm_vendor'
                ? SizedBox()
                : Line(
                    color: greyLine,
                    height: 5,
                  ),
            Session.data.getString('cookie') != null
                ? SizedBox()
                : Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: TextStyles(
                            value: AppLocalizations.of(context)!
                                .translate("my_acc"),
                            size: 14,
                            weight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        AccountStyle(
                          value:
                              AppLocalizations.of(context)!.translate("login"),
                          icon: "gridicons_user.png",
                          arrow: true,
                          id: 31,
                          refresh: refresh,
                        ),
                      ],
                    ),
                  ),
            Session.data.getString('cookie') != null
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: TextStyles(
                            value: AppLocalizations.of(context)!
                                .translate("my_acc"),
                            size: 14,
                            weight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        AccountStyle(
                          value:
                              "${Session.data.getString("firstname")} ${Session.data.getString("lastname") ?? ""}",
                          icon: "gridicons_user.png",
                          arrow: false,
                          id: 1,
                          refresh: refresh,
                        ),
                        AccountStyle(
                          value: "${Session.data.getString("email") ?? ""}",
                          iconMaterial: MaterialIcons.mail,
                          arrow: false,
                          id: 2,
                        ),
                        Container(
                          // margin: EdgeInsets.only(top: 15),
                          child: AccountStyle(
                            value: AppLocalizations.of(context)!
                                .translate("up_prof"),
                            icon: "ic_update_profile.png",
                            arrow: true,
                            id: 3,
                            refresh: refresh,
                          ),
                        ),
                        AccountStyle(
                          value: AppLocalizations.of(context)!
                              .translate("my_order"),
                          iconMaterial: MaterialCommunityIcons.package,
                          arrow: true,
                          id: 5,
                        ),
                        AccountStyle(
                          value: AppLocalizations.of(context)!
                              .translate("my_wish"),
                          iconMaterial: MaterialIcons.favorite,
                          arrow: true,
                          id: 6,
                        ),
                        AccountStyle(
                          value:
                              AppLocalizations.of(context)!.translate("chat"),
                          icon: "Chat-Dark.png",
                          arrow: true,
                          notif: false,
                          intNotif: "50",
                          id: 7,
                        ),
                        AccountStyle(
                          value:
                              AppLocalizations.of(context)!.translate("notif"),
                          iconMaterial: MaterialIcons.notifications,
                          arrow: true,
                          intNotif: "5",
                          id: 8,
                        ),
                        AccountStyle(
                          value:
                              AppLocalizations.of(context)!.translate("logout"),
                          iconMaterial: MaterialIcons.logout,
                          arrow: true,
                          id: 4,
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            Line(
              color: greyLine,
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: TextStyles(
                      value: AppLocalizations.of(context)!.translate("gen_set"),
                      size: 14,
                      weight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  AccountStyle(
                    value: AppLocalizations.of(context)!.translate("lang"),
                    icon: "fluent_globe-20-filled.png",
                    arrow: true,
                    id: 12,
                  ),
                  // AccountStyle(
                  //   value: "Dark Theme",
                  //   icon: "bi_moon-fill.png",
                  //   toggleSwitch: true,
                  //   id: 13,
                  // ),
                  AccountStyle(
                    value: AppLocalizations.of(context)!.translate("about"),
                    icon: "carbon_information-filled.png",
                    arrow: true,
                    id: 14,
                  ),
                  AccountStyle(
                    value: AppLocalizations.of(context)!.translate("term_cond"),
                    icon: "termCondition.png",
                    arrow: true,
                    id: 18,
                  ),
                  AccountStyle(
                    value: AppLocalizations.of(context)!
                        .translate("privacy_police"),
                    icon: "fluent_shield-checkmark-48-filled.png",
                    arrow: true,
                    id: 15,
                  ),
                  AccountStyle(
                    value: AppLocalizations.of(context)!.translate("rate_app"),
                    iconMaterial: AntDesign.star,
                    arrow: true,
                    id: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
