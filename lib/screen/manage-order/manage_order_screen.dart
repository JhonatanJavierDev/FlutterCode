part of '../pages.dart';

class ManageOrderScreen extends StatefulWidget {
  @override
  _ManageOrderScreenState createState() => _ManageOrderScreenState();
}

class _ManageOrderScreenState extends State<ManageOrderScreen> {
  bool ada = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  loadOrder() async {
    this.setState(() {});
    final order = Provider.of<OrderProvider>(context, listen: false);
    await order
        .fetchOrdersVendor(page: page)
        .then((value) => this.setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
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
          AppLocalizations.of(context)!.translate("manage_order")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: order.listOrderVendor.isEmpty && !order.isLoading
          ? Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/myOrder/no_data.png'),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextStyles(
                        value: AppLocalizations.of(context)!
                            .translate('no_orders')!,
                        weight: FontWeight.bold,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5, color: Colors.grey.withOpacity(0.23))
                      ]),
                  height: 40,
                  margin: EdgeInsets.fromLTRB(14, 15, 14, 5),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        child: Icon(
                          EvilIcons.search,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      hintText: AppLocalizations.of(context)!
                          .translate("search_order"),
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9E9E9E),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.fromLTRB(17, 5, 0, 5),
                    ),
                  ),
                ),
                order.isLoading ? buildShimmerCardOrder() : buildCardOrder()
              ],
            ),
    );
  }

  buildCardOrder() {
    final order = Provider.of<OrderProvider>(context, listen: false);

    return Flexible(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: order.listOrderVendor.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: greyLine,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Icon(Icons.person),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextStyles(
                          value: order
                              .listOrderVendor[index].shippingInfo!.firstName,
                          weight: FontWeight.bold,
                          size: 14,
                          color: Color(0xFF212121),
                        ),
                      ),
                      Spacer(),
                      statusOrder(order.listOrderVendor[index].status)
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, j) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailOrderScreen(
                                  order: order.listOrderVendor[index],
                                  isSeller: true,
                                ),
                              ),
                            );
                            if (result == '200') loadOrder();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 14, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: order.listOrderVendor[index]
                                                  .productItems![j].image !=
                                              null &&
                                          order.listOrderVendor[index]
                                                  .productItems![j].image !=
                                              false
                                      ? ImgStyle(
                                          url: order.listOrderVendor[index]
                                              .productItems![j].image,
                                          width: 70,
                                          height: 70,
                                          radius: 5,
                                        )
                                      : Icon(
                                          Icons.image,
                                          size: 70,
                                        ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextStyles(
                                        value: order.listOrderVendor[index]
                                            .productItems![j].productName,
                                        size: 14,
                                        weight: FontWeight.bold,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 9),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4),
                                              child: TextStyles(
                                                value: formatCurrency(
                                                    order.listOrderVendor[index]
                                                        .productItems![j].total
                                                        .toDouble(),
                                                    context),
                                                size: 14,
                                                color: Color(0xFF1565C0),
                                                weight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextStyles(
                                        value:
                                            " ${order.listOrderVendor[index].productItems![j].quantity} Item",
                                        size: 12,
                                        color: Color(0xFF616161),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: order
                                  .listOrderVendor[index].productItems!.length >
                              1,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: TextStyles(
                                value:
                                    '+${order.listOrderVendor[index].productItems!.length - 1} ${AppLocalizations.of(context)!.translate("more_product")}',
                                size: 12),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
                /*Divider(),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              height: 30,
                              width: myOrderDummy[index] == "DONE" ? 150 : 100,
                              child: MaterialButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.all(0),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                color: accentColor,
                                onPressed: () {},
                                child: Container(
                                    child: TextStyles(
                                  value: myOrderDummy[index] == "DONE"
                                      ? "Confirmation Received"
                                      : "Buy Again",
                                  color: Colors.white,
                                  size: 12,
                                )),
                              ),
                            ),*/
              ],
            ),
          );
        },
      ),
    );
  }

  buildShimmerCardOrder() {
    return Flexible(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.black.withOpacity(0.08),
                  )
                ],
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: greyLine,
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Container(
                                width: 100,
                                color: Colors.white,
                                height: 14,
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 14, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              onTap: null,
                              child: ImgStyle(
                                url:
                                    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
                                width: 70,
                                height: 70,
                                radius: 5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  color: Colors.white,
                                  height: 14,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 9),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        color: Colors.white,
                                        height: 14,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  color: Colors.white,
                                  height: 12,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80,
                            color: Colors.white,
                            height: 12,
                          ),
                          Container(
                            width: 120,
                            color: Colors.white,
                            height: 12,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget statusOrder(String? status) {
    Color? color;
    var statusText = '';

    if (status == 'pending') {
      color = Color(0xFFBC5100);
      statusText = AppLocalizations.of(context)!
          .translate("waiting_payment")!
          .toUpperCase();
    } else if (status == 'on-hold') {
      color = Color(0xFFBC5100);
      statusText = AppLocalizations.of(context)!
          .translate("on_hold_manage")!
          .toUpperCase();
    } else if (status == 'processing') {
      color = Color(0xFF1B5E20);
      statusText =
          AppLocalizations.of(context)!.translate("processing")!.toUpperCase();
    } else if (status == 'completed') {
      color = Color(0xFF1565C0);
      statusText =
          AppLocalizations.of(context)!.translate("completed")!.toUpperCase();
    } else if (status == 'cancelled') {
      color = Color(0xFFB71C1C);
      statusText =
          AppLocalizations.of(context)!.translate("canceled")!.toUpperCase();
    } else if (status == 'refunded') {
      color = Color(0xFFBC5100);
      statusText =
          AppLocalizations.of(context)!.translate("refunded")!.toUpperCase();
    } else if (status == 'failed') {
      color = Color(0xFFB71C1C);
      statusText =
          AppLocalizations.of(context)!.translate("failed")!.toUpperCase();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextStyles(
        value: statusText,
        weight: FontWeight.bold,
        size: 12,
        color: color,
      ),
    );
  }
}
