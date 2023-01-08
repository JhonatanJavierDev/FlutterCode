part of '../pages.dart';

class WithdrawalHistoryScreen extends StatefulWidget {
  const WithdrawalHistoryScreen();

  @override
  _WithdrawalHistoryScreenState createState() =>
      _WithdrawalHistoryScreenState();
}

class _WithdrawalHistoryScreenState extends State<WithdrawalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getList();
      // Add Your Code here.
    });
  }

  getList() async {
    print("disini");
    Provider.of<StoreProvider>(context, listen: false)
        .getListHistoryWithdrawal();
  }

  void _detailModalBottomSheet(context, WidrawalHistoryListModel result) {
    final gs = Provider.of<HomeProvider>(context, listen: false);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Container(
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
                                  margin: EdgeInsets.symmetric(horizontal: 120),
                                  child: Line(
                                    color: Color(0xFFC4C4C4),
                                    height: 5,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 24),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("date"),
                                  size: 14,
                                  color: mutedColor,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8, bottom: 24),
                                child: TextStyles(
                                  value: result.paidDateFormatted,
                                  size: 16,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 18),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: TextStyles(
                                              value:
                                                  AppLocalizations.of(context)!
                                                      .translate("invoice"),
                                              size: 14,
                                              color: mutedColor,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 8, bottom: 15),
                                            child: TextStyles(
                                              value: result.requestId,
                                              size: 16,
                                              weight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: TextStyles(
                                              value:
                                                  AppLocalizations.of(context)!
                                                      .translate("order_id"),
                                              size: 14,
                                              color: mutedColor,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 8, bottom: 18),
                                            child: TextStyles(
                                              value: result.orderId,
                                              size: 16,
                                              weight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("nominal"),
                                  size: 14,
                                  color: mutedColor,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8, bottom: 24),
                                child: TextStyles(
                                  value: convertHtmlUnescape(
                                      "${gs.currency.description}${result.withdrawAmount}"),
                                  size: 16,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("cost"),
                                  size: 14,
                                  color: mutedColor,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8, bottom: 24),
                                child: TextStyles(
                                  value: convertHtmlUnescape(
                                      "${gs.currency.description}${result.withdrawCharges}"),
                                  size: 16,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("payment"),
                                  size: 14,
                                  color: mutedColor,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                margin: EdgeInsets.only(top: 8, bottom: 18),
                                child: Text(
                                  "Via ${result.paymentMethod} (${result.billingDetails})",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("mode"),
                                  size: 14,
                                  color: mutedColor,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8, bottom: 24),
                                child: TextStyles(
                                  value: result.withdrawalMode,
                                  size: 16,
                                ),
                              ),
                              Container(
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("note"),
                                  size: 14,
                                  color: mutedColor,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8, bottom: 24),
                                child: TextStyles(
                                  value: result.withdrawNote,
                                  size: 16,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: MaterialButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  color: accentColor,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("close")!,
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
          AppLocalizations.of(context)!.translate("withdrawal_history")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<StoreProvider>(builder: (context, value, child) {
        return value.loading
            ? Container(child: spinDancing)
            : Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 26, 15, 0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("Invoice_id"),
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("date"),
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: TextStyles(
                              value: AppLocalizations.of(context)!
                                  .translate("action"),
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Divider(),
                    ),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.withdrawalList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var result = value.withdrawalList[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: TextStyles(
                                      value: result.requestId,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: TextStyles(
                                      value: result.paidDateFormatted,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      _detailModalBottomSheet(context, result);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1565C0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 7),
                                      child: TextStyles(
                                        value: AppLocalizations.of(context)!
                                            .translate("detail"),
                                        weight: FontWeight.bold,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
