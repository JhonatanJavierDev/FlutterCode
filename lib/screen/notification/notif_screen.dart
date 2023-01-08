part of '../pages.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool? isSeller;
  String tipe = "buyer";

  @override
  void initState() {
    super.initState();
    getListNotif();
  }

  Widget statusOrder(String? status, {required ListNotification notif}) {
    var subtitle = 'Unknown';
    if (status == 'Su Orden está Pendiente' ||
        status == 'Nueva Orden: Pendiente') {
      subtitle = ' ${AppLocalizations.of(context)!.translate("pending_sub")}';
    } else if (status == 'Su Pedido está en Proceso' ||
        status == 'Nueva Orden: Procesando') {
      subtitle =
          ' ${AppLocalizations.of(context)!.translate("processing_sub")}';
    } else if (status == 'Su Pedido está Pendiente' ||
        status == 'Nueva Orden: Pendiente') {
      subtitle = ' ${AppLocalizations.of(context)!.translate("on-hold_sub")}';
    } else if (status == 'Su Pedido se ha Completado' ||
        status == 'Nueva Orden : Completado') {
      subtitle = ' ${AppLocalizations.of(context)!.translate("completed_sub")}';
    } else if (status == 'Su Orden se ha Cancelado' ||
        status == 'Nueva Orden : Cancelado') {
      subtitle = ' ${AppLocalizations.of(context)!.translate("canceled_sub")}';
    } else if (status == 'Su Pedido se ha Reembolsado' ||
        status == 'Nueva Orden : Reembolsado') {
      subtitle = ' ${AppLocalizations.of(context)!.translate("refund_sub")}';
    } else if (status == 'Su Orden ha Fallado' ||
        status == 'Nueva Orden : Fallida') {
      // subtitle =
      //     ' ${AppLocalizations.of(context).translate('status_order_failed')}';
      subtitle = ' ${AppLocalizations.of(context)!.translate("fail_get")}';
    }

    print(notif.status);
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: TextStyles(
            value: AppLocalizations.of(context)!.translate(notif.status!
                    .replaceAll(" : ", "_")
                    .replaceAll(" ", "_")
                    .toLowerCase()) ??
                "",
            size: 12,
            color: darkColor,
            weight: FontWeight.bold,
          ),
        ),
        Container(
          width: 210,
          child: RichText(
            text: TextSpan(
              text: '${AppLocalizations.of(context)!.translate("order")} ',
              style: TextStyle(color: Color(0xFF464646), fontSize: 12),
              children: <TextSpan>[
                TextSpan(
                  text: notif.orderId.toString(),
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: subtitle,
                  style: TextStyle(color: Color(0xFF464646), fontSize: 12),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            children: [
              Icon(
                MaterialCommunityIcons.clock_outline,
                size: 15,
                color: Color(0xFF464646),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextStyles(
                  value: notif.createdAt,
                  color: Color(0xFF464646),
                  size: 12,
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  void getListNotif() async {
    Provider.of<ListNotificationProvider>(context, listen: false)
        .getListNotification(type: tipe);
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
          AppLocalizations.of(context)!.translate("notif")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<ListNotificationProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: isSeller != true
                                        ? tittleColor
                                        : Colors.white,
                                    width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            color:
                                isSeller != true ? Colors.white : accentColor,
                            onPressed: () {
                              setState(() {
                                isSeller = true;
                                tipe = "seller";
                                getListNotif();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("as_seller")!,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSeller != true
                                        ? tittleColor
                                        : primaryColor),
                              ),
                            ),
                          ),
                        ),
                        Container(width: 10),
                        Expanded(
                          flex: 1,
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: isSeller != true
                                        ? Colors.white
                                        : tittleColor,
                                    width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            color:
                                isSeller != true ? tittleColor : Colors.white,
                            onPressed: () {
                              setState(() {
                                isSeller = false;
                                tipe = "buyer";
                                getListNotif();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("as_buyer")!,
                                style: TextStyle(
                                  color: isSeller != true
                                      ? Colors.white
                                      : tittleColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                value.loading
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: spinDancing,
                      )
                    : value.listNotif.length == 0
                        ? Container(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                      'assets/images/myOrder/no_data.png',
                                      width: 220),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: TextStyles(
                                      value: AppLocalizations.of(context)!
                                          .translate("no_notif")!,
                                      weight: FontWeight.bold,
                                      size: 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: value.listNotif.length,
                              itemBuilder: (BuildContext context, int index) {
                                var notif = value.listNotif[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (tipe == "buyer") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailOrderScreen(
                                            orderId: value
                                                .listNotif[index].orderId
                                                .toString(),
                                            isSeller: false,
                                          ),
                                        ),
                                      );
                                    } else if (tipe == "seller") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManageOrderScreen()));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                          color: Colors.grey.withOpacity(0.40),
                                        )
                                      ],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ImgStyle(
                                          url: notif.image,
                                          width: 70,
                                          height: 70,
                                          radius: 5,
                                        ),
                                        statusOrder(notif.status, notif: notif),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),
          );
        },
      ),
    );
  }
}
