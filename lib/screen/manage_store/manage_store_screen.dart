part of '../pages.dart';

class ManageStoreScreen extends StatefulWidget {
  @override
  _ManageStoreScreenState createState() => _ManageStoreScreenState();
}

class _ManageStoreScreenState extends State<ManageStoreScreen> {
  final formatRupiah = new NumberFormat.simpleCurrency(decimalDigits: 0);
  final formated = new NumberFormat("#,##0.00", "en_US");
  late HomeProvider gs;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStoreData();
    });
  }

  getStoreData() async {
    Provider.of<StoreProvider>(context, listen: false)
        .fetchDetailManageStore(context);
  }

  refreshPage(dynamic value) {
    var store = Provider.of<StoreProvider>(context, listen: false).manageStore!;
    print(json.encode(store.bankAccount));
  }

  closeToko() async {
    var store = Provider.of<StoreProvider>(context, listen: false).manageStore!;
    Provider.of<StoreProvider>(context, listen: false)
        .openCloseFunc(context, status: store.isClose! ? false : true);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 5.5;
    final double itemWidth = size.width / 2;
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
          AppLocalizations.of(context)!.translate("manage_store")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<StoreProvider>(
          builder: (context, value, child) {
            if (value.loadingStore) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 73,
                            height: 73,
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                child: Container(
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 8),
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                        ),
                                      ),
                                      TextStyles(
                                        value: 'STORE',
                                        size: 14,
                                        weight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 20,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 5,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Icon(
                                            FontAwesome.star,
                                            size: 15,
                                            color: Colors.orange,
                                          );
                                        },
                                      ),
                                    ),
                                    Text(
                                      "0",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(MaterialCommunityIcons.map_marker),
                                Container(width: 18),
                                Container(
                                  width: 120,
                                  child: Container(
                                    width: 40,
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Line(
                            color: Colors.white,
                            height: 3,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio:
                                          (itemWidth / itemHeight),
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0),
                              itemCount: 4,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8,
                                        color: Colors.black.withOpacity(0.10),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          width: 80,
                                          height: 80,
                                          color: Colors.white),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ImgStyle(
                          url: value.manageStore!.banner,
                          width: double.infinity,
                          height: 207,
                          radius: 0,
                        ),
                        Container(
                          height: 207,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xCC000000),
                                const Color(0xCC121212),
                                const Color(0xCC121212),
                                const Color(0xCC121212),
                                const Color(0xCC000000),
                                const Color(0xCC000000),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
                                child: ImgStyle(
                                  url: value.manageStore!.icon,
                                  width: 80,
                                  height: 80,
                                  radius: 100,
                                ),
                              ),
                              TextStyles(
                                value: value.manageStore!.name,
                                size: 14,
                                weight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 6, 0, 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 20,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 5,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Icon(
                                            FontAwesome.star,
                                            size: 15,
                                            color: Colors.orange,
                                          );
                                        },
                                      ),
                                    ),
                                    Text(
                                      " ${value.manageStore!.ratingCount}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 8),
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: value.manageStore!.isClose!
                                          ? Colors.redAccent
                                          : Color(0xFF31D07A),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                  TextStyles(
                                      value: value.manageStore!.isClose!
                                          ? AppLocalizations.of(context)!
                                              .translate("close")
                                          : AppLocalizations.of(context)!
                                              .translate("open"),
                                      size: 12,
                                      color: Colors.white,
                                      weight: FontWeight.normal)
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 15, bottom: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/account/icon-park-outline_transaction-order.png",
                              width: 23,
                            ),
                            Container(width: 18),
                            Container(
                              // color: Colors.red,
                              width: 260,
                              child: value.manageStore!.description!
                                      .contains("<p>")
                                  ? Html(
                                      style: {
                                          "body": Style(
                                              margin: EdgeInsets.all(0),
                                              padding: EdgeInsets.all(0))
                                        },
                                      data:
                                          """${value.manageStore!.description}""")
                                  : Text(
                                      value.manageStore!.description!,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(MaterialCommunityIcons.map_marker),
                            Container(width: 18),
                            Container(
                              width: 260,
                              child: Text(
                                value.manageStore!.address!,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Line(
                      height: 5,
                      color: greyLine,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.95,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0),
                        itemCount: 4,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return totalSales(
                              index,
                              value.manageStore!.sales!.amountSales,
                              value.manageStore!.sales!.adminCharge,
                              value.manageStore!.sales!.productSales,
                              value.manageStore!.sales!.approvedSales);
                        },
                      ),
                    ),
                    Line(
                      height: 5,
                      color: greyLine,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingPaymentScreen(
                                    bank: value.manageStore!.bankAccount,
                                  ),
                                ),
                              ).then(refreshPage);
                            },
                            child: Container(
                              color: Colors.white,
                              height: 40,
                              margin: EdgeInsets.only(bottom: 3),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "$iconTag/Frame 16.png",
                                    width: 23,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: TextStyles(
                                        value: AppLocalizations.of(context)!
                                            .translate("setting_pay"),
                                        size: 14,
                                        color: darkColor),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Icon(
                                      MaterialIcons.keyboard_arrow_right,
                                      color: mutedColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 4),
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6)
                              ],
                            ),
                            child: ListTileTheme(
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                leading: Image.asset(
                                    "assets/images/store/uil_money-withdrawal.png",
                                    width: 25),
                                title: Align(
                                  alignment: Alignment(-1.13, 0),
                                  child: TextStyles(
                                    value: AppLocalizations.of(context)!
                                        .translate("withdraw"),
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubCategoriesScreen(),
                                        ),
                                      );
                                    },
                                    dense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 6.0, right: 6.0, bottom: 5),
                                    title: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WithdrawalHistoryScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.fromLTRB(
                                                      35, 15, 0, 15),
                                                  child: TextStyles(
                                                    value: AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "withdrawal_history"),
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RequestWithdrawalScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.fromLTRB(
                                                      35, 15, 0, 15),
                                                  child: TextStyles(
                                                    value: AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "withdrawal_req"),
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          AccountStyle(
                            value: AppLocalizations.of(context)!
                                .translate("update_data_store"),
                            icon: "si-glyph_book-4.png",
                            arrow: true,
                            id: 112,
                          ),
                          Container(
                            color: Colors.white,
                            height: 40,
                            margin: EdgeInsets.only(bottom: 3),
                            child: Row(
                              children: [
                                Image.asset(
                                  "$iconTag/mdi_power.png",
                                  width: 23,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: TextStyles(
                                      value: AppLocalizations.of(context)!
                                          .translate("open_close"),
                                      size: 14,
                                      color: darkColor),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    closeToko();
                                  },
                                  child: Container(
                                    child: Icon(
                                        value.manageStore!.isClose!
                                            ? MaterialCommunityIcons
                                                .toggle_switch_off_outline
                                            : Icons.toggle_on_rounded,
                                        size: 35),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Container totalSales(
      int index, amountSales, adminCharge, productSales, approvedSales) {
    Color? color;
    String? subTitle, assets;
    var sales;
    gs = Provider.of<HomeProvider>(context, listen: false);
    switch (index + 1) {
      case 1:
        color = Color(0xFFB71C1C);
        subTitle = AppLocalizations.of(context)!.translate("gross_sales");
        sales = convertHtmlUnescape(
            "${gs.currency.description}${formated.format(amountSales)}");
        assets = 'assets/images/store/mdi_currency-usd.png';
        break;
      case 2:
        color = tittleColor;
        subTitle = AppLocalizations.of(context)!.translate("admin_commision");
        sales = convertHtmlUnescape(
            "${gs.currency.description}${formated.format(adminCharge)}");
        assets = 'assets/images/store/mdi_cash.png';
        break;
      case 3:
        color = Color(0xFFF57F17);
        subTitle = AppLocalizations.of(context)!.translate("product_sold");
        sales =
            '$productSales ${AppLocalizations.of(context)!.translate("items")}';
        assets = 'assets/images/store/mdi_archive-check-outline.png';
        break;
      case 4:
        color = Color(0xFF004D40);
        subTitle = AppLocalizations.of(context)!.translate("product_rech");
        sales =
            '$approvedSales ${AppLocalizations.of(context)!.translate("orders")}';
        assets = 'assets/images/store/Frame 15.png';
        break;
      default:
    }

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.fromLTRB(12, 12, 0, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(
                  assets!,
                  width: 22,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 5),
                    child: TextStyles(
                      value: sales,
                      color: color,
                      size: 16,
                      weight: FontWeight.bold,
                    ),
                  ),
                  Container(
                      width: 120,
                      child: Text(subTitle!, style: TextStyle(fontSize: 12)))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
