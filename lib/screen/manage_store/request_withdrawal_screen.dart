part of '../pages.dart';

class RequestWithdrawalScreen extends StatefulWidget {
  const RequestWithdrawalScreen();

  @override
  _RequestWithdrawalScreenState createState() =>
      _RequestWithdrawalScreenState();
}

class _RequestWithdrawalScreenState extends State<RequestWithdrawalScreen> {
  var listID = [];
  bool isAll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getList();
    });
  }

  getList() async {
    Provider.of<StoreProvider>(context, listen: false).getListWithdrawRequest();
  }

  addAllRequest(RequestWithdrawalList? list) {
    listID = [];
    if (isAll == false) {
      isAll = true;
      for (var item in list!.data!) {
        listID.add(item.orderId);
      }
    } else {
      isAll = false;
    }

    setState(() {});
  }

  addRequest({String? id}) {
    var request = listID.contains(id);
    if (request == false) {
      listID.add(id);
    } else {
      listID.remove(id);
    }
    setState(() {
      isAll = false;
    });
    print(request);
    print(listID);
  }

  submitWithdrawReq() async {
    Provider.of<StoreProvider>(context, listen: false)
        .submitWithdrawRequest(context, data: listID);
  }

  void _detailModalBottomSheet(context, Data result) {
    final gs = Provider.of<HomeProvider>(context, listen: false);

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
                              margin: EdgeInsets.only(top: 25),
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("invoice"),
                                size: 14,
                                color: mutedColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8, bottom: 15),
                              child: TextStyles(
                                value: result.createdAtFormatted,
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 18),
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("order_id"),
                                size: 14,
                                color: mutedColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8, bottom: 15),
                              child: TextStyles(
                                value: result.orderId,
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 18),
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("income"),
                                size: 14,
                                color: mutedColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8, bottom: 15),
                              child: TextStyles(
                                value: convertHtmlUnescape(
                                    "${gs.currency.description}${result.earnings}"),
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 18),
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("cost"),
                                size: 14,
                                color: mutedColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8, bottom: 15),
                              child: TextStyles(
                                value: convertHtmlUnescape(
                                    "${gs.currency.description}${result.adminCharges}"),
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 18),
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("payment"),
                                size: 14,
                                color: mutedColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8, bottom: 15),
                              child: TextStyles(
                                value: convertHtmlUnescape(
                                    "${gs.currency.description}${result.earningsFinal}"),
                                size: 16,
                                weight: FontWeight.bold,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
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
          AppLocalizations.of(context)!.translate("withdrawal_request")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, value, child) {
          return value.loading
              ? Center(child: spinDancing)
              : Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 26, 15, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          addAllRequest(
                                              value.requestWithdrawalList);
                                        },
                                        child: Icon(isAll
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: TextStyles(
                                          value: AppLocalizations.of(context)!
                                              .translate("all"),
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                              itemCount:
                                  value.requestWithdrawalList!.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                var result =
                                    value.requestWithdrawalList!.data![index];
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                addRequest(id: result.orderId);
                                              },
                                              child: Icon(
                                                listID.contains(result.orderId)
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: TextStyles(
                                                value: "#${result.orderId}",
                                                weight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: TextStyles(
                                            value: result.createdAtFormatted,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            _detailModalBottomSheet(
                                                context, result);
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
                                              value:
                                                  AppLocalizations.of(context)!
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
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            color: accentColor,
                            onPressed: () {
                              submitWithdrawReq();
                            },
                            child: TextStyles(
                              value: AppLocalizations.of(context)!
                                  .translate("submit")!
                                  .toUpperCase(),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
