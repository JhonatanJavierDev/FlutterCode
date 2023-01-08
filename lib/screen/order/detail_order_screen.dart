part of '../pages.dart';

class DetailOrderScreen extends StatefulWidget {
  final bool isSeller;
  final String? orderId;
  final OrderModel? order;
  DetailOrderScreen({this.isSeller = false, this.orderId, this.order});

  @override
  _DetailOrderScreenState createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  OrderModel? orderModel;
  String? _value;
  bool isBuyAgain = false;
  @override
  void initState() {
    printLog(json.encode(widget.order));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.orderId != null) {
        print("SAdasdas");
        loadOrder();
      } else {
        print("bungkam");
        orderModel = widget.order;
        _value = orderModel!.status;
        printLog(json.encode(orderModel));
        print(_value);
        setState(() {});
      }
    });
  }

  loadOrder() async {
    final order = Provider.of<OrderProvider>(context, listen: false);
    await order
        .fetchDetailOrder(widget.orderId)
        .then((value) => this.setState(() {
              orderModel = order.detailOrder;
              _value = orderModel!.status;
            }));
  }

  void addText(String? vendorID, {ProductModel? product}) async {
    // print(vendorID);
    // print(product);
    UIBlock.block(context);
    FocusScope.of(context).unfocus();
    Provider.of<DetailChatProvider>(context, listen: false)
        .sendMessage(message: null, receiverId: vendorID, type: 'init')
        .then((value) {
      if (value == true) {
        UIBlock.unblock(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatHomeScreen(
              receiverId: vendorID!,
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

  loadCartCount() async {
    await Provider.of<CartProvider>(context, listen: false)
        .loadCartCount()
        .then((value) {
      print(value);
      if (value == orderModel!.productItems!.length) {
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

  void addToCart() {
    UIBlock.block(context);
    ProductModel? product = new ProductModel();
    for (var item in orderModel!.productItems!) {
      loadDetailProduct(item.productId.toString()).then((value) async {
        product = value;
        product!.cartQuantity = item.quantity;
        await Provider.of<CartProvider>(context, listen: false)
            .calculatePriceTotal(context, product!)
            .then((value) => loadCartCount());
      });
    }
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
      color = Colors.white;
      statusText = AppLocalizations.of(context)!.translate("on_hld_order");
    } else if (status == 'processing') {
      color = Colors.white;
      statusText =
          AppLocalizations.of(context)!.translate("processing")!.toUpperCase();
    } else if (status == 'completed') {
      color = Colors.white;
      statusText =
          AppLocalizations.of(context)!.translate("complete")!.toUpperCase();
    } else if (status == 'cancelled') {
      color = Colors.white;
      statusText =
          AppLocalizations.of(context)!.translate("canceled")!.toUpperCase();
    } else if (status == 'refunded') {
      color = Colors.white;
      statusText =
          AppLocalizations.of(context)!.translate("refunded")!.toUpperCase();
    } else if (status == 'failed') {
      color = Colors.white;
      statusText =
          AppLocalizations.of(context)!.translate("failed")!.toUpperCase();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextStyles(
        value:
            "${AppLocalizations.of(context)!.translate("order")!.toUpperCase()} $statusText",
        weight: FontWeight.bold,
        size: 14,
        color: color,
      ),
    );
  }

  Widget build(BuildContext context) {
    final order = Provider.of<OrderProvider>(context, listen: false);
    String formatDate(DateTime date) =>
        new DateFormat('dd-MM-yyyy HH:mm').format(date);
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
            AppLocalizations.of(context)!.translate("detail_order")!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? customLoading()
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 70),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 15),
                                padding: EdgeInsets.all(15),
                                color: Color(0xFF1565C0),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        statusOrder(orderModel!.status),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: TextStyles(
                                            value: AppLocalizations.of(context)!
                                                .translate(
                                                    "thank_for_shopping"),
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    Image.asset(
                                        "assets/images/detail/order.png",
                                        width: 35)
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate("no_order")!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(orderModel!.id.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 5, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate("order_date")!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                        formatDate(DateTime.parse(
                                            orderModel!.dateCreated!)),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 19),
                                child: Line(
                                  color: Color(0xFFEEEEEE),
                                  height: 5,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Icon(
                                          MaterialCommunityIcons.map_marker),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextStyles(
                                            value: AppLocalizations.of(context)!
                                                .translate("shipping_addr"),
                                            size: 14,
                                            weight: FontWeight.bold,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 9, 0, 5),
                                            child: TextStyles(
                                              value:
                                                  '${orderModel!.billingInfo!.firstName} ${orderModel!.billingInfo!.lastName}',
                                              size: 12,
                                              color: Color(0xFF616161),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: TextStyles(
                                              value:
                                                  '${orderModel!.billingInfo!.phone}',
                                              size: 12,
                                              color: Color(0xFF616161),
                                            ),
                                          ),
                                          Container(
                                            width: 280,
                                            child: TextStyles(
                                              value:
                                                  '${orderModel!.billingInfo!.firstAddress}',
                                              size: 12,
                                              color: Color(0xFF616161),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 19),
                                child: Line(
                                  color: Color(0xFFEEEEEE),
                                  height: 5,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Icon(MaterialIcons.credit_card),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextStyles(
                                            value: AppLocalizations.of(context)!
                                                .translate("payment_method"),
                                            size: 14,
                                            weight: FontWeight.bold,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 9, 0, 5),
                                            child: TextStyles(
                                              value:
                                                  'Card Credit / Debit Online',
                                              size: 12,
                                              color: Color(0xFF212121),
                                            ),
                                          ),
                                          TextStyles(
                                            value:
                                                orderModel!.paymentMethodTitle,
                                            size: 12,
                                            color: Color(0xFF616161),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: TextStyles(
                                              value: AppLocalizations.of(
                                                      context)!
                                                  .translate('payment_desc')!,
                                              size: 12,
                                              color: Color(0xFF212121),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              orderModel!.paymentDescription ??
                                                  "-",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF616161),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 19),
                                child: Line(
                                  color: Color(0xFFEEEEEE),
                                  height: 5,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Icon(
                                            MaterialCommunityIcons.truck_fast),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextStyles(
                                            value: AppLocalizations.of(context)!
                                                .translate("shipping_method"),
                                            size: 14,
                                            weight: FontWeight.bold,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 9),
                                            child: TextStyles(
                                              value: orderModel!
                                                      .shippingServices!.isEmpty
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .translate(
                                                          'no_shipping_method')!
                                                  : '${orderModel!.shippingServices![0].serviceName} -',
                                              size: 12,
                                              color: Color(0xFF616161),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 19),
                                child: Line(
                                  color: Color(0xFFEEEEEE),
                                  height: 5,
                                ),
                              ),
                              Visibility(
                                visible: orderModel!.customerNote!.isNotEmpty,
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: ImageIcon(
                                                AssetImage(
                                                    "assets/images/detail/sticky_notes.png"),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextStyles(
                                                    value: AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "order_note")!,
                                                    size: 14,
                                                    weight: FontWeight.bold,
                                                  ),
                                                  Container(
                                                    width: 280,
                                                    margin:
                                                        EdgeInsets.only(top: 9),
                                                    child: TextStyles(
                                                      value: orderModel!
                                                          .customerNote,
                                                      size: 12,
                                                      color: Color(0xFF616161),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 19),
                                      child: Line(
                                        color: Color(0xFFEEEEEE),
                                        height: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: widget.isSeller,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
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
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: TextStyles(
                                          value: orderModel!
                                              .shippingInfo!.firstName,
                                          weight: FontWeight.bold,
                                          size: 14,
                                          color: Color(0xFF212121),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !widget.isSeller,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: orderModel!.orders!.length,
                                        itemBuilder: (context, i) {
                                          var listVendor =
                                              orderModel!.orders![i];
                                          return Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: Row(
                                                    children: [
                                                      ImageIcon(
                                                        AssetImage(
                                                            "assets/images/home/fluent_store-microsoft-16-filled.png"),
                                                        color:
                                                            Color(0xFF616161),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 12),
                                                        child: TextStyles(
                                                          value: listVendor
                                                              .vendor!.name,
                                                          weight:
                                                              FontWeight.bold,
                                                          size: 14,
                                                          color:
                                                              Color(0xFF212121),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      TextButton(
                                                        onPressed: () {
                                                          print(listVendor
                                                              .vendor!.id);
                                                          // print(product);
                                                          addText(listVendor
                                                              .vendor!.id);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    tittleColor,
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  8),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/detail/carbon_chat.png",
                                                                  width: 15,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                child:
                                                                    TextStyles(
                                                                  value: AppLocalizations.of(
                                                                          context)!
                                                                      .translate(
                                                                          "chat"),
                                                                  size: 12,
                                                                  color:
                                                                      tittleColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: listVendor
                                                      .lineItems!.length,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder: (context, j) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DetailProductScreen(
                                                                  id: listVendor
                                                                      .lineItems![
                                                                          j]
                                                                      .productId
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(15, 0,
                                                                    14, 10),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              15),
                                                                  child: listVendor.lineItems![j].image !=
                                                                              null &&
                                                                          listVendor.lineItems![j].image !=
                                                                              false
                                                                      ? ImgStyle(
                                                                          url: listVendor
                                                                              .lineItems![j]
                                                                              .image,
                                                                          width:
                                                                              70,
                                                                          height:
                                                                              70,
                                                                          radius:
                                                                              5,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .image,
                                                                          size:
                                                                              70,
                                                                        ),
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      TextStyles(
                                                                        value: listVendor
                                                                            .lineItems![j]
                                                                            .productName,
                                                                        size:
                                                                            14,
                                                                        weight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      Visibility(
                                                                        visible: listVendor
                                                                            .lineItems![j]
                                                                            .subName!
                                                                            .isNotEmpty,
                                                                        child:
                                                                            TextStyles(
                                                                          value:
                                                                              "${listVendor.lineItems![j].subName}",
                                                                          size:
                                                                              12,
                                                                          color:
                                                                              Color(0xFF616161),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                9),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 4),
                                                                              child: TextStyles(
                                                                                value: stringToCurrency(listVendor.lineItems![j].total.toDouble(), context),
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
                                                                            " ${listVendor.lineItems![j].quantity} Item",
                                                                        size:
                                                                            12,
                                                                        color: Color(
                                                                            0xFF616161),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        // Visibility(
                                                        //   visible: listVendor
                                                        //           .lineItems.length >
                                                        //       1,
                                                        //   child: Container(
                                                        //     margin:
                                                        //         EdgeInsets.symmetric(
                                                        //             horizontal: 15),
                                                        //     child: TextStyles(
                                                        //         value:
                                                        //             '+${listVendor.lineItems.length - 1} More Product',
                                                        //         size: 12),
                                                        //   ),
                                                        // ),
                                                        Divider(),
                                                      ],
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible: widget.isSeller,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          orderModel!.productItems!.length,
                                      physics: ScrollPhysics(),
                                      itemBuilder: (context, j) {
                                        var orderItem =
                                            orderModel!.productItems![j];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: null,
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    15, 0, 14, 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 15),
                                                      child: orderItem.image !=
                                                                  null &&
                                                              orderItem.image !=
                                                                  false
                                                          ? ImgStyle(
                                                              url: orderItem
                                                                  .image,
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextStyles(
                                                            value: orderItem
                                                                .productName,
                                                            size: 14,
                                                            weight:
                                                                FontWeight.bold,
                                                          ),
                                                          Visibility(
                                                            visible: orderItem
                                                                .subName!
                                                                .isNotEmpty,
                                                            child: TextStyles(
                                                              value:
                                                                  "${orderItem.subName}",
                                                              size: 12,
                                                              color: Color(
                                                                  0xFF616161),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        9),
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 4),
                                                                  child:
                                                                      TextStyles(
                                                                    value: formatCurrency(
                                                                        orderItem
                                                                            .total
                                                                            .toDouble(),
                                                                        context),
                                                                    size: 14,
                                                                    color: Color(
                                                                        0xFF1565C0),
                                                                    weight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          TextStyles(
                                                            value:
                                                                " ${orderItem.quantity} Item",
                                                            size: 12,
                                                            color: Color(
                                                                0xFF616161),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: orderModel!
                                                      .productItems!.length >
                                                  1,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                child: TextStyles(
                                                    value:
                                                        '+${orderModel!.productItems!.length - 1} More Product',
                                                    size: 12),
                                              ),
                                            ),
                                            Divider(),
                                          ],
                                        );
                                      },
                                    ),
                                  )),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 15, 14, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowTotalStyle(
                                      color: darkColor,
                                      size: 12,
                                      value: AppLocalizations.of(context)!
                                          .translate("subtotal_prod"),
                                      keys: stringToCurrency(
                                          (orderModel!.totalOrder! -
                                              double.parse(
                                                  orderModel!.shippingTotal!)),
                                          context),
                                    ),
                                    RowTotalStyle(
                                      color: darkColor,
                                      size: 12,
                                      value: AppLocalizations.of(context)!
                                          .translate("shipping"),
                                      keys: stringToCurrency(
                                          double.parse(
                                              orderModel!.shippingTotal!),
                                          context),
                                    ),
                                    Visibility(
                                      visible: !widget.isSeller,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate("aditional_fee")!,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          Container(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    orderModel!.fees!.length,
                                                itemBuilder: (context, i) {
                                                  return RowTotalStyle(
                                                    color: darkColor,
                                                    size: 12,
                                                    value: orderModel!
                                                        .fees![i].name,
                                                    keys: stringToCurrency(
                                                        double.parse(orderModel!
                                                            .fees![i].total!),
                                                        context),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RowTotalStyle(
                                      color: Color(0xFF212121),
                                      size: 14,
                                      value: AppLocalizations.of(context)!
                                          .translate("total_order"),
                                      keys: widget.isSeller
                                          ? stringToCurrency(
                                              double.parse(orderModel!.total!),
                                              context)
                                          : stringToCurrency(
                                              orderModel!.totalOrder! +
                                                  int.parse(
                                                      orderModel!.feeTotal!),
                                              context),
                                      weight: FontWeight.bold,
                                    ),
                                    Visibility(
                                      visible: widget.isSeller,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                            left: 14, right: 14),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Color(0xFFFAFAFA),
                                            border: Border.all(
                                                color: Color(0xFFC4C4C4))),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            onChanged: (dynamic value) {
                                              setState(() {
                                                _value = value;
                                              });
                                            },
                                            dropdownColor: Colors.white,
                                            icon: Container(
                                                child: Icon(
                                                    Ionicons.ios_arrow_down,
                                                    size: 18)),
                                            value: _value,
                                            items: <DropdownMenuItem<String>>[
                                              new DropdownMenuItem(
                                                child: new Text(
                                                  AppLocalizations.of(context)!
                                                      .translate('pending')!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                value: "pending",
                                              ),
                                              new DropdownMenuItem(
                                                child: new Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("on_hold")!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                value: "on-hold",
                                              ),
                                              new DropdownMenuItem(
                                                child: new Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("processing")!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                value: "processing",
                                              ),
                                              new DropdownMenuItem(
                                                child: new Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("canceled")!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                value: "cancelled",
                                              ),
                                              new DropdownMenuItem(
                                                child: new Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("complete")!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                value: "completed",
                                              ),
                                              new DropdownMenuItem(
                                                child: new Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("refunded")!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                value: "refunded",
                                              ),
                                              new DropdownMenuItem(
                                                child: new Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("failed")!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                value: "failed",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.grey.withOpacity(0.30),
                                offset: Offset(0, 0),
                              )
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(14, 8, 14, 8),
                          width: double.infinity,
                          child: widget.isSeller != true
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: MaterialButton(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        color: isBuyAgain == true
                                            ? Colors.grey[300]
                                            : accentColor,
                                        onPressed: () {
                                          if (isBuyAgain == false) {
                                            addToCart();
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("buy_again")!,
                                            style: TextStyle(
                                                color: isBuyAgain == true
                                                    ? Colors.black26
                                                    : primaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(width: 10),
                                    // Expanded(
                                    //   flex: 1,
                                    //   child: MaterialButton(
                                    //     elevation: 0,
                                    //     shape: RoundedRectangleBorder(
                                    //         side: BorderSide(
                                    //             color: tittleColor, width: 1),
                                    //         borderRadius:
                                    //             BorderRadius.all(Radius.circular(5))),
                                    //     color: Colors.white,
                                    //     onPressed: () {
                                    //       final gs =
                                    //           Provider.of<GeneralSettingsProvider>(
                                    //               context,
                                    //               listen: false);
                                    //       _launchWAURL(gs.wa.description);
                                    //     },
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           vertical: 14),
                                    //       child: Text(
                                    //         "Chat Seller",
                                    //         style: TextStyle(
                                    //           color: tittleColor,
                                    //           fontSize: 12,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                )
                              : order.isLoadingStatus
                                  ? Container(
                                      width: double.infinity,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 16),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: customLoading(),
                                    )
                                  : MaterialButton(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      color: accentColor,
                                      onPressed: () async {
                                        this.setState(() {});
                                        await Provider.of<OrderProvider>(
                                                context,
                                                listen: false)
                                            .updateStatusOrderVendor(context,
                                                status: _value,
                                                orderId: orderModel!.id);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate("submit")!,
                                          style: TextStyle(color: primaryColor),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  );
          },
        ));
  }
}
