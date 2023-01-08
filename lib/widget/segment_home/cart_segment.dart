part of '../widget.dart';

class CartSegment extends StatefulWidget {
  final bool withBackBtn;

  const CartSegment({Key? key, this.withBackBtn = false}) : super(key: key);

  @override
  _CartSegmentState createState() => _CartSegmentState();
}

// const spinkit = SpinKitRotatingCircle(
//   color: Color(0xFF1A237E),
//   size: 50.0,
// );

class _CartSegmentState extends State<CartSegment> {
  bool ada = true;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  loadCart() async {
    await Provider.of<CartProvider>(context, listen: false)
        .loadCartData()
        .then((value) => this.setState(() {}));
  }

  /*Remove Ordered Items*/
  Future removeOrderedItems() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.listCart.forEach((element) {
      element.products!
          .removeWhere((elementProduct) => elementProduct.isSelected!);
    });
    cart.listCart.removeWhere((element) => element.products!.isEmpty);
    cart.saveData();
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => OrderSuccess()));
  }

  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final order = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: widget.withBackBtn
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              )
            : null,
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.18),
        titleSpacing: 0,
        leadingWidth: 35,
        centerTitle: true,
        title: TextStyles(
          value: AppLocalizations.of(context)!.translate("my_cart"),
          size: 18,
          weight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: cart.listCart.isEmpty
          ? cartNotFound()
          : Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 60),
                  height: double.infinity,
                  // color: Colors.red,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextStyles(
                                value:
                                    '${AppLocalizations.of(context)!.translate("all_cart")} (${cart.totalSelected})',
                                size: 14,
                                weight: FontWeight.bold,
                                color: tittleColor,
                              ),
                            ],
                          ),
                        ),
                        Line(
                          height: 1,
                          color: greyLine,
                        ),
                        buildCardStore(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.grey.withOpacity(0.23),
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 9, left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextStyles(
                                  value:
                                      '${AppLocalizations.of(context)!.translate("prod")} (${cart.totalSelected})',
                                  size: 11,
                                  color: mutedColor,
                                ),
                                Container(height: 4),
                                TextStyles(
                                  value:
                                      'Total : ${stringToCurrency(cart.totalPriceCart, context)}',
                                  size: 14,
                                  color: tittleColor,
                                  weight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await order.checkOutOrder(context,
                                  removeOrderedItems: removeOrderedItems);
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 17,
                                  horizontal: 20,
                                ),
                                color: tittleColor,
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("checkout"),
                                  color: Colors.white,
                                  size: 14,
                                  weight: FontWeight.bold,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  SingleChildScrollView cartNotFound() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 100, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child:
                  Image.asset("assets/images/cart/cart_kosong.png", width: 250),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: TextStyles(
                value: AppLocalizations.of(context)!.translate("cart_empty"),
                size: 16,
                weight: FontWeight.bold,
              ),
            ),
            Container(
              child: MaterialButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: accentColor,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen()),
                      (Route<dynamic> route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate("go_shop")!,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Consumer<HomeProvider>(builder: (context, value, child) {
              if (value.loadingFeatured) {
                return Container();
              }
              if (value.listFeaturedProduct.isEmpty) {
                return Container();
              }
              return Column(
                children: [
                  SegmentTittle(
                    segment: AppLocalizations.of(context)!
                        .translate("featured_product"),
                    isMore: true,
                    featured: true,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 14),
                    child: StyleListScreen(
                      isFlashSale: false,
                      listProducts: value.listFeaturedProduct,
                    ),
                  ),
                ],
              );
            }),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 14),
            //   child: StyleListScreen(
            //     isFlashSale: false,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  buildCardStore() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: cart.listCart.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: cart.listCart[index].isVendorSelected,
                            onChanged: (val) {
                              setState(() {
                                cart.listCart[index].isVendorSelected =
                                    !cart.listCart[index].isVendorSelected!;
                              });
                              cart.selectedAll();
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: ImageIcon(
                              AssetImage(
                                  "assets/images/home/fluent_store-microsoft-16-filled.png"),
                              color: Color(0xFF616161),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailStoreScreen(
                                    id: int.parse(
                                        cart.listCart[index].vendor!.id),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "${cart.listCart[index].vendor!.name}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF616161),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Icon(
                                    MaterialIcons.keyboard_arrow_right,
                                    color: mutedColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cart.listCart[index].products!.length,
                itemBuilder: (BuildContext context, int i) {
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Checkbox(
                                value: cart.listCart[index].products![i]
                                        .isSelected ??
                                    true,
                                onChanged: (value) async {
                                  setState(() {
                                    cart.listCart[index].products![i]
                                            .isSelected =
                                        !cart.listCart[index].products![i]
                                            .isSelected!;
                                  });
                                  await cart
                                      .calculateTotal(index, i)
                                      .then((value) => this.setState(() {}));
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailProductScreen(
                                        id: cart.listCart[index].products![i].id
                                            .toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: ImgStyle(
                                  url: cart.listCart[index].products![i]
                                      .images![0].src,
                                  height: 70,
                                  width: 70,
                                  radius: 5,
                                ),
                              ),
                            ]),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailProductScreen(
                                            id: cart
                                                .listCart[index].products![i].id
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 200,
                                      child: MarqueeWidget(
                                        direction: Axis.horizontal,
                                        child: TextStyles(
                                          value: cart.listCart[index]
                                              .products![i].productName,
                                          size: 14,
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Visibility(
                                      visible: cart.listCart[index].products![i]
                                              .variantId !=
                                          null,
                                      child: Row(
                                        children: [
                                          Wrap(
                                            children: [
                                              for (var j = 0;
                                                  j <
                                                      cart
                                                          .listCart[index]
                                                          .products![i]
                                                          .attributes!
                                                          .length;
                                                  j++)
                                                Text(
                                                    j == 0
                                                        ? '${cart.listCart[index].products![i].attributes![j].selectedVariant}'
                                                        : ', ${cart.listCart[index].products![i].attributes![j].selectedVariant}',
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontStyle:
                                                            FontStyle.italic)),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Visibility(
                                          visible: cart.listCart[index]
                                                  .products![i].discProduct !=
                                              0,
                                          child: TextStyles(
                                            value:
                                                '${cart.listCart[index].products![i].formattedPrice} ',
                                            size: 10,
                                            lineThrough:
                                                TextDecoration.lineThrough,
                                            color: mutedColor,
                                          ),
                                        ),
                                        TextStyles(
                                          value: cart
                                                      .listCart[index]
                                                      .products![i]
                                                      .discProduct !=
                                                  0
                                              ? cart.listCart[index].products![i]
                                                  .formattedSalePrice
                                              : cart.listCart[index].products![i]
                                                  .formattedPrice,
                                          size: 12,
                                          color: tittleColor,
                                          weight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 13),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: MaterialButton(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              padding: EdgeInsets.all(0),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: cart
                                                                  .listCart[
                                                                      index]
                                                                  .products![i]
                                                                  .cartQuantity ==
                                                              1
                                                          ? greyText
                                                          : accentColor,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3))),
                                              color: Colors.white,
                                              onPressed: () async {
                                                if (cart
                                                        .listCart[index]
                                                        .products![i]
                                                        .cartQuantity! >
                                                    1) {
                                                  setState(() {
                                                    cart
                                                        .listCart[index]
                                                        .products![i]
                                                        .cartQuantity = cart
                                                            .listCart[index]
                                                            .products![i]
                                                            .cartQuantity! -
                                                        1;
                                                  });
                                                  await cart
                                                      .refreshQuantity(index, i)
                                                      .then((value) =>
                                                          this.setState(() {}));
                                                }
                                              },
                                              child: Container(
                                                child: Icon(
                                                  AntDesign.minus,
                                                  color: cart
                                                              .listCart[index]
                                                              .products![i]
                                                              .cartQuantity ==
                                                          1
                                                      ? greyText
                                                      : tittleColor,
                                                  size: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 28,
                                            child: Center(
                                              child: TextStyles(
                                                  value: cart.listCart[index]
                                                      .products![i].cartQuantity
                                                      .toString(),
                                                  size: 14,
                                                  color: tittleColor),
                                            ),
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: MaterialButton(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              padding: EdgeInsets.all(0),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: accentColor,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3))),
                                              color: Colors.white,
                                              onPressed: cart
                                                              .listCart[index]
                                                              .products![i]
                                                              .productStock !=
                                                          null &&
                                                      cart
                                                              .listCart[index]
                                                              .products![i]
                                                              .productStock! <=
                                                          cart
                                                              .listCart[index]
                                                              .products![i]
                                                              .cartQuantity!
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        cart
                                                            .listCart[index]
                                                            .products![i]
                                                            .cartQuantity = cart
                                                                .listCart[index]
                                                                .products![i]
                                                                .cartQuantity! +
                                                            1;
                                                      });
                                                      await cart
                                                          .refreshQuantity(
                                                              index, i)
                                                          .then((value) => this
                                                              .setState(() {}));
                                                    },
                                              child: Container(
                                                child: Icon(
                                                  AntDesign.plus,
                                                  color: tittleColor,
                                                  size: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          top: 5,
                          right: 10,
                          child: InkWell(
                            onTap: () {
                              cart.removeItem(index, i, context);
                              this.setState(() {});
                            },
                            child: Image.asset(
                              'assets/images/cart/delete.png',
                              width: 25,
                            ),
                          ))
                    ],
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Line(
                  height: 5,
                  color: greyLine,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
