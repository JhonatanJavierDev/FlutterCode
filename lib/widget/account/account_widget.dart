part of '../widget.dart';

class AccountStyle extends StatelessWidget {
  const AccountStyle(
      {Key? key,
      this.notif,
      this.value,
      this.icon,
      this.intNotif,
      this.arrow,
      this.toggleSwitch,
      this.id,
      this.noIcon,
      this.iconMaterial,
      this.refresh})
      : super(key: key);

  final String? icon;
  final String? value;
  final bool? notif, arrow, toggleSwitch, noIcon;
  final String? intNotif;
  final IconData? iconMaterial;
  final int? id;
  final Future<dynamic> Function()? refresh;

  void _detailModalBottomSheet(context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15, left: 20, right: 15, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 100),
                                child: Line(
                                  color: Color(0xFFC4C4C4),
                                  height: 5,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(14, 25, 14, 20),
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("sure_log"),
                                weight: FontWeight.bold,
                                size: 14,
                                align: TextAlign.center,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Expanded(
                                      child: InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: TextStyles(
                                      value: AppLocalizations.of(context)!
                                          .translate("no"),
                                      size: 14,
                                      color: tittleColor,
                                      weight: FontWeight.bold,
                                      align: TextAlign.center,
                                    ),
                                  )),
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    color: accentColor,
                                    onPressed: () {
                                      auth.signOut(context).then((value) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        HomeScreen()),
                                            (Route<dynamic> route) => false);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate("yes")!,
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final generalSettings = Provider.of<HomeProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    void pushScreen() {
      switch (id) {
        // case 1:
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => UpdateAccountScreen(
        //         isEditing: true,
        //       ),
        //     ),
        //   ).then((value) => refresh());
        //   break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateAccountScreen(
                isEditing: true,
              ),
            ),
          ).then((value) => refresh!());
          break;

        case 31:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          ).then((value) => refresh!());
          break;
        case 4:
          _detailModalBottomSheet(context);
          break;
        case 9:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageProductScreen(),
            ),
          );
          break;
        case 5:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyOrderScreen(),
            ),
          );
          break;
        case 6:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WishListScreen(),
            ),
          );
          break;
        case 7:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatHomeScreen(),
            ),
          );
          break;
        case 8:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationScreen(),
            ),
          );
          break;
        case 10:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageOrderScreen(),
            ),
          );
          break;
        case 11:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageStoreScreen(),
            ),
          );
          break;
        case 111:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingPaymentScreen(),
            ),
          );
          break;
        case 112:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditStoreScreen(isEdit: true),
            ),
          );
          break;
        case 113:
          break;
        case 12:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LanguageScreen(),
            ),
          );
          break;
        case 14:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: generalSettings.about.description,
                title: AppLocalizations.of(context)!
                    .translate("about")!
                    .toUpperCase(),
              ),
            ),
          );
          break;
        case 15:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: homeProvider.policy,
                title: AppLocalizations.of(context)!
                    .translate("privacy_police")!
                    .toUpperCase(),
              ),
            ),
          );
          break;
        case 16:
          if (Platform.isIOS) {
            LaunchReview.launch(writeReview: false, iOSAppId: '1600401080');
          } else {
            LaunchReview.launch(
                androidAppId: generalSettings.packageInfo?.packageName);
          }
          break;
        case 17:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShippingServiceScreen(),
            ),
          );
          break;
        case 18:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: homeProvider.termCondition,
                title: AppLocalizations.of(context)!
                    .translate("term_cond")!
                    .toUpperCase(),
              ),
            ),
          );
          break;
        case 111:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditStoreScreen(),
            ),
          );
          break;
        default:
      }
    }

    return GestureDetector(
      onTap: () {
        pushScreen();
      },
      child: Container(
        color: Colors.white,
        height: 40,
        margin: EdgeInsets.only(bottom: 3),
        child: Row(
          children: [
            noIcon != true
                ? iconMaterial != null
                    ? Icon(iconMaterial, size: 23)
                    : Image.asset(
                        "$iconTag/$icon",
                        width: 23,
                      )
                : Container(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: TextStyles(
                  value: value,
                  size: 14,
                  color: darkColor,
                ),
              ),
            ),
            Spacer(),
            notif != true
                ? Container()
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextStyles(
                        value: intNotif, size: 10, color: Colors.white),
                  ),
            arrow != true
                ? toggleSwitch == true
                    ? Container(
                        child: Icon(
                            MaterialCommunityIcons.toggle_switch_off_outline,
                            size: 35),
                      )
                    : Container()
                : Container(
                    child: Icon(
                      MaterialIcons.keyboard_arrow_right,
                      color: mutedColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
