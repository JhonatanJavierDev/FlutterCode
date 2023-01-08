part of '../pages.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  bool ada = true;
  bool loading = true;
  TextEditingController search = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMyOrder();
    });
  }

  loadMyOrder() async {
    final order = Provider.of<OrderProvider>(context, listen: false);
    await order
        .fetchOrders(search: search.text)
        .then((value) => this.setState(() {
              loading = false;
              if (value!.length == 0) {
                ada = false;
              }
              print(value.length.toString());
            }));
  }

  loadCartCount({OrderModel? model}) async {
    await Provider.of<CartProvider>(context, listen: false)
        .loadCartCount()
        .then((value) {
      print(value);
      if (value == model!.productItems!.length) {
        UIBlock.unblock(context);
        // setState(() {
        //   isBuyAgain = true;
        // });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartSegment(
              withBackBtn: true,
            ),
          ),
        );
      }
    });
  }

  Future<ProductModel?> loadDetailProduct(String id) async {
    ProductModel? result;
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchDetailProduct(id, context)
        .then((value) {
      result = value;
    });
    return result;
  }

  void addToCart({required OrderModel model}) {
    UIBlock.block(context);
    printLog(json.encode(model.productItems));
    ProductModel? product = new ProductModel();
    for (var item in model.productItems!) {
      loadDetailProduct(item.productId.toString()).then((value) async {
        product = value;
        product!.cartQuantity = item.quantity;
        await Provider.of<CartProvider>(context, listen: false)
            .calculatePriceTotal(context, product!)
            .then((value) => loadCartCount(model: model));
        printLog(json.encode(product));
      });
    }
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
          AppLocalizations.of(context)!.translate("my_order")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: loading
          ? customLoading()
          : ada == false
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
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.23))
                          ]),
                      height: 40,
                      margin: EdgeInsets.fromLTRB(14, 15, 14, 5),
                      child: TextField(
                        controller: search,
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          setState(() {});
                          loadMyOrder();
                        },
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
        itemCount: order.listOrder.length,
        itemBuilder: (BuildContext context, int index) {
          String formatDate(DateTime date) =>
              new DateFormat('dd-MM-yyyy HH:mm').format(date);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate("no_order")!,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(order.listOrder[index].id.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400))
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate("order_date")!,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                          formatDate(DateTime.parse(
                              order.listOrder[index].dateCreated!)),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400))
                    ],
                  ),
                ),
                Divider(),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: order.listOrder[index].orders!.length,
                    itemBuilder: (context, i) {
                      var listVendor = order.listOrder[index].orders![i];
                      return Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Row(
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                        "assets/images/home/fluent_store-microsoft-16-filled.png"),
                                    color: Color(0xFF616161),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: TextStyles(
                                      value: listVendor.vendor!.name,
                                      weight: FontWeight.bold,
                                      size: 14,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  Spacer(),
                                  statusOrder(order.listOrder[index].status)
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
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailOrderScreen(
                                              order: order.listOrder[index],
                                              isSeller: false,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(15, 0, 14, 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: listVendor.lineItems![j]
                                                              .image !=
                                                          null &&
                                                      listVendor.lineItems![j]
                                                              .image !=
                                                          false
                                                  ? ImgStyle(
                                                      url: listVendor
                                                          .lineItems![j].image,
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
                                                    value: listVendor
                                                        .lineItems![j]
                                                        .productName,
                                                    size: 14,
                                                    weight: FontWeight.bold,
                                                  ),
                                                  Visibility(
                                                    visible: listVendor
                                                        .lineItems![j]
                                                        .subName!
                                                        .isNotEmpty,
                                                    child: TextStyles(
                                                      value:
                                                          "${listVendor.lineItems![j].subName}",
                                                      size: 12,
                                                      color: Color(0xFF616161),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 9),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 4),
                                                          child: TextStyles(
                                                            value: stringToCurrency(
                                                                listVendor
                                                                    .lineItems![
                                                                        j]
                                                                    .total
                                                                    .toDouble(),
                                                                context),
                                                            size: 14,
                                                            color: Color(
                                                                0xFF1565C0),
                                                            weight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  TextStyles(
                                                    value:
                                                        " ${listVendor.lineItems![j].quantity} Item",
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
                                      visible: listVendor.lineItems!.length > 1,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: TextStyles(
                                            value:
                                                '+${listVendor.lineItems!.length - 1} ${AppLocalizations.of(context)!.translate("more_product")}',
                                            size: 12),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      );
                    }),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          TextStyles(
                              value: AppLocalizations.of(context)!
                                  .translate("total_order")!,
                              size: 12),
                          TextStyles(
                            value:
                                ' ${stringToCurrency(order.listOrder[index].totalOrder! + double.parse(order.listOrder[index].feeTotal!), context)}',
                            size: 12,
                            weight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
                order.listOrder[index].status == "completed"
                    ? Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 0, 15),
                        height: 30,
                        width: order.listOrder[index].status == "completed"
                            ? 100
                            : 150,
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.all(0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          color: accentColor,
                          onPressed: () {
                            print(order.listOrder[index].status);

                            if (order.listOrder[index].status == "completed") {
                              addToCart(model: order.listOrder[index]);
                            }
                          },
                          child: Container(
                            child: TextStyles(
                              value:
                                  order.listOrder[index].status == "completed"
                                      ? AppLocalizations.of(context)!
                                          .translate("buy_again")
                                      : "Confirmation Received",
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
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
                          ImageIcon(
                            AssetImage(
                                "assets/images/home/fluent_store-microsoft-16-filled.png"),
                            color: Color(0xFF616161),
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
    String? statusText = '';

    if (status == 'pending') {
      color = Color(0xFFBC5100);
      statusText = AppLocalizations.of(context)!
          .translate("waiting_payment")!
          .toUpperCase();
    } else if (status == 'on-hold') {
      color = Color(0xFFBC5100);
      statusText = AppLocalizations.of(context)!.translate("on_hld_order");
    } else if (status == 'processing') {
      color = Color(0xFF1B5E20);
      statusText =
          AppLocalizations.of(context)!.translate("processing")!.toUpperCase();
    } else if (status == 'completed') {
      color = Color(0xFF1565C0);
      statusText =
          AppLocalizations.of(context)!.translate("complete")!.toUpperCase();
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
