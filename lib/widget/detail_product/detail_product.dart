part of '../widget.dart';

// ignore: must_be_immutable
class DetailProductScreen extends StatefulWidget {
  final bool? isFlashSale;
  final ProductModel? product;
  final String? id;
  final String? slug;
  bool? isFavorite;
  DetailProductScreen(
      {this.isFlashSale, this.product, this.id, this.isFavorite, this.slug});
  @override
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final controller = PageController();
  bool isReview = false;
  int pageIndex = 0;
  int qty = 1;
  int? variantIndex;
  int disableVariant = 1;
  int cartCount = 0;
  bool? favorite = false;
  String? productID;

  ProductModel? product = new ProductModel();

  TextEditingController reviewController = new TextEditingController();

  List<ProductReviewModel> reviewProduct = [];
  double rating = 0;

  @override
  void initState() {
    super.initState();
    loadCartCount();
    print(widget.id);
    if (widget.id != null || widget.slug != null) {
      // printLog(widget.id!, name: "ID Produk");
      loadDetailProduct();
    }
    if (widget.product != null) {
      product = widget.product;
      loadRelatedProducts();
    }
  }

  loadRelatedProducts() async {
    print("Load Related Product");
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchRelatedProducts(widget.product != null
            ? widget.product!.relatedProductsId
            : product!.relatedProductsId);
    loadReviewProduct();
  }

  loadDetailProduct() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    loadCartCount();
    if (widget.slug == null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchDetailProduct(widget.id!, context)
          .then((value) async {
        setState(() {
          product = value;
          product!.isSelected = false;
          favorite = product!.isWishList;
          printLog(json.encode(product));
        });
        loadRelatedProducts();

        if (Session.data.getBool('isLogin')!) {
          await productProvider.hitViewProducts(widget.id!).then(
              (value) async => await productProvider.fetchRecentProducts());
        }
      });
      printLog("slug : masuk sini");
    } else {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchProductDetailSlug(widget.slug)
          .then((value) {
        setState(() {
          product = value;
          product!.isSelected = false;
        });
        loadRelatedProducts();
      });
    }
  }

  loadCartCount() async {
    await Provider.of<CartProvider>(context, listen: false)
        .loadCartCount()
        .then((value) {
      setState(() {
        cartCount = value;
      });
    });
  }

  myFavorite() async {
    Provider.of<WishlistProvider>(context, listen: false)
        .removeWhistList(id: widget.id)
        .then((value) {
      setState(() {
        favorite = value;
      });
      Provider.of<WishlistProvider>(context, listen: false)
          .getProductWishlist()
          .then((value) {
        UIBlock.unblock(context);
      });
    });
  }

  void addText(String? vendorID, ProductModel? products) async {
    UIBlock.block(context);
    FocusScope.of(context).unfocus();
    Provider.of<DetailChatProvider>(context, listen: false)
        .sendMessage(message: null, receiverId: vendorID, type: 'init')
        .then((value) {
      UIBlock.unblock(context);
      if (value == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatHomeScreen(receiverId: vendorID!, product: products),
          ),
        );
      }
    });
  }

  loadReviewProduct() async {
    print("Load Review Product");
    await Provider.of<ProductProvider>(context, listen: false)
        .loadReviewProduct(
            widget.id != null
                ? widget.id.toString()
                : widget.product != null
                    ? widget.product!.id.toString()
                    : product != null
                        ? product!.id.toString()
                        : '',
            page: 1,
            perPage: 2)
        .then((value) {
      setState(() {
        reviewProduct =
            Provider.of<ProductProvider>(context, listen: false).listReview;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final featured = Provider.of<HomeProvider>(context, listen: false);
    final productPvdr = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.18),
        titleSpacing: 0,
        leadingWidth: 35,
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
        actions: [
          InkWell(
            onTap: () {
              shareLinks('product', product!.link);
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.share,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              UIBlock.block(context);
              myFavorite();
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                favorite == true
                    ? MaterialIcons.favorite
                    : MaterialIcons.favorite_border,
                color: Colors.black,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartSegment(
                            withBackBtn: true,
                          ))).then((value) => loadCartCount());
            },
            child: Container(
              width: 45,
              padding: EdgeInsets.only(right: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    MaterialIcons.shopping_cart,
                    color: Colors.black,
                    size: 25,
                  ),
                  Positioned(
                    right: -1,
                    top: 7,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: accentColor),
                      alignment: Alignment.center,
                      child: Text(
                        "$cartCount",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(right: 10),
          //   child: Icon(
          //     FlutterIcons.share_mdi,
          //     color: Colors.black,
          //   ),
          // ),
        ],
      ),
      body: productPvdr.loadDetail
          ? customLoading()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            AspectRatio(
                              child: PageView(
                                controller: controller,
                                children: [
                                  for (var i = 0;
                                      i < product!.images!.length;
                                      i++)
                                    CachedNetworkImage(
                                      imageUrl: product!.images![i].src!,
                                      placeholder: (context, url) =>
                                          customLoading(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                ],
                                onPageChanged: (index) {
                                  setState(() {
                                    pageIndex = index;
                                  });
                                },
                              ),
                              aspectRatio: 1 / 1,
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              bottom: 10,
                              child: Center(
                                child: SmoothPageIndicator(
                                  controller: controller,
                                  count: product!.images!.length,
                                  axisDirection: Axis.horizontal,
                                  effect: ColorTransitionEffect(
                                      activeStrokeWidth: 9,
                                      spacing: 8.0,
                                      radius: 4.0,
                                      dotWidth: 8.0,
                                      dotHeight: 8.0,
                                      strokeWidth: 1.5,
                                      dotColor: Colors.grey,
                                      activeDotColor: tittleColor),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Text(
                                  "${pageIndex + 1} /${product!.images!.length}"),
                            )
                          ],
                        ),
                        widget.isFlashSale != true
                            ? Container()
                            : Stack(
                                children: [
                                  Image.asset(
                                      'assets/images/detail/bg-flashsale.png'),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 6, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            "assets/images/home/Blink-Flash-Sale-88x350.gif",
                                            width: 104),
                                        TextStyles(
                                          value:
                                              '${AppLocalizations.of(context)!.translate("remaining_time")!} : ',
                                          size: 10,
                                          weight: FontWeight.bold,
                                          color: Color(0xFFED4B9E),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    bottom: 4,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: CountdownTimer(
                                        endTime: end,
                                        widgetBuilder:
                                            (_, CurrentRemainingTime? time) {
                                          if (time == null) {
                                            return Text(
                                                AppLocalizations.of(context)!
                                                    .translate("game_over")!);
                                          }
                                          return Row(
                                            children: [
                                              TimerStyle(
                                                timer: time.hours,
                                                color: Colors.white,
                                                width: 35,
                                                height: 35,
                                                backgroundColor: Colors.white,
                                                textColor: tittleColor,
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              TimerStyle(
                                                timer: time.min,
                                                color: Colors.white,
                                                width: 35,
                                                height: 35,
                                                backgroundColor: Colors.white,
                                                textColor: tittleColor,
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              TimerStyle(
                                                timer: time.sec,
                                                color: Colors.white,
                                                width: 35,
                                                height: 35,
                                                backgroundColor: Colors.white,
                                                textColor: tittleColor,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        Container(
                          margin: EdgeInsets.all(15),
                          child: Stack(
                            children: [
                              Visibility(
                                visible: product!.discProduct != 0,
                                child: Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    color: Color(0xFFED4B9E),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Text(
                                      "${AppLocalizations.of(context)!.translate("sale")} ${product!.discProduct!.toInt()}%",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              product!.isVariationDiscount!
                                  ? Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        color: Color(0xFFED4B9E),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        child: Center(
                                          child: Text(
                                            product!.discVariation!.first ==
                                                    product!.discVariation!.last
                                                ? "${AppLocalizations.of(context)!.translate("sale")} ${product!.discVariation!.first}%"
                                                : "${AppLocalizations.of(context)!.translate("sale")} ${product!.discVariation!.first}-${product!.discVariation!.last}%",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 225,
                                    child: TextStyles(
                                      value: product!.productName,
                                      size: 16,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        product!.type == 'simple' ||
                                                product!.type == 'grouped'
                                            ? Container(
                                                child: TextStyles(
                                                  value: product!.discProduct !=
                                                          0
                                                      ? product!
                                                          .formattedSalePrice
                                                      : product!.formattedPrice,
                                                  size: 15,
                                                  weight: FontWeight.bold,
                                                  color: tittleColor,
                                                  isPrice: true,
                                                ),
                                              )
                                            : buildPriceVariation(context),
                                        Visibility(
                                          visible: product!.discProduct != 0,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: TextStyles(
                                              value: product!.formattedPrice,
                                              size: 12,
                                              color: Colors.grey[400],
                                              lineThrough:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: RatingBarIndicator(
                                      rating: double.parse(product!.avgRating!),
                                      itemSize: 20,
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return Icon(
                                          MaterialCommunityIcons.star,
                                          size: 20,
                                          color: Colors.orange,
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: TextStyles(
                                            value:
                                                "${AppLocalizations.of(context)!.translate("available")} : ",
                                            size: 12,
                                          ),
                                        ),
                                        Container(
                                          child: TextStyles(
                                            value: product!.stockStatus ==
                                                    'instock'
                                                ? AppLocalizations.of(context)!
                                                    .translate("in_stock")
                                                : AppLocalizations.of(context)!
                                                    .translate("out_stock"),
                                            size: 12,
                                            weight: FontWeight.bold,
                                            color: product!.stockStatus ==
                                                    'instock'
                                                ? tittleColor
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: TextStyles(
                                            value:
                                                "${AppLocalizations.of(context)!.translate("variant")} :",
                                            size: 12,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          height: 38,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: typeVariantList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (index !=
                                                        disableVariant) {
                                                      variantIndex = index;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 3),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: variantIndex == index
                                                        ? accentColor
                                                        : disableVariant ==
                                                                index
                                                            ? Color(0xFFbdbdbd)
                                                            : Colors.white,
                                                    border: Border.all(
                                                      color: variantIndex ==
                                                              index
                                                          ? Colors.white
                                                          : disableVariant ==
                                                                  index
                                                              ? Color(
                                                                  0xFFbdbdbd)
                                                              : accentColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      typeVariantList[index],
                                                      style: TextStyle(
                                                        color: variantIndex ==
                                                                index
                                                            ? Colors.white
                                                            : disableVariant ==
                                                                    index
                                                                ? darkColor
                                                                : accentColor,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 5,
                          color: Colors.grey[200],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.all(15),
                          child: TextStyles(
                            value:
                                AppLocalizations.of(context)!.translate("desc"),
                            weight: FontWeight.bold,
                            size: 14,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
                          child: Html(style: {
                            "body": Style(
                                margin: EdgeInsets.all(0),
                                padding: EdgeInsets.all(0))
                          }, data: """${product!.productDescription}"""),
                        ),
                        Line(height: 5, color: Colors.grey[200]),
                        product!.vendor!.name!.isEmpty
                            ? Container()
                            : Column(
                                children: [
                                  Stack(
                                    children: [
                                      Visibility(
                                        visible:
                                            int.parse(product!.vendor!.id) !=
                                                Session.data.getInt('id'),
                                        child: Positioned(
                                          right: 0,
                                          top: 25,
                                          child: TextButton(
                                            onPressed: () {
                                              if (Session.data
                                                  .getBool('isLogin')!) {
                                                print(product);
                                                addText(product!.vendor!.id,
                                                    product);
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          LoginScreen()),
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: tittleColor,
                                                    width: 1),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Image.asset(
                                                      "assets/images/detail/carbon_chat.png",
                                                      width: 15,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: TextStyles(
                                                      value: AppLocalizations
                                                              .of(context)!
                                                          .translate("chat"),
                                                      size: 12,
                                                      color: tittleColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailStoreScreen(
                                                      id: int.parse(
                                                          product!.vendor!.id),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ImgStyle(
                                                url: product!.vendor!.icon,
                                                width: 60,
                                                height: 60,
                                                radius: 100,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailStoreScreen(
                                                      id: int.parse(
                                                          product!.vendor!.id),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 13, left: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      child: TextStyles(
                                                        value: product!
                                                            .vendor!.name,
                                                        size: 14,
                                                        weight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextStyles(
                                                      value: product!
                                                          .vendor!.address,
                                                      size: 12,
                                                      color: mutedColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Line(height: 5, color: Colors.grey[200]),
                                ],
                              ),
                        AdMobState(type: 'product'),
                        reviewSection(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Line(height: 5, color: Colors.grey[200]),
                        ),
                        Session.data.getBool('isLogin')!
                            ? inputReviewSection()
                            : Container(),
                        Session.data.getBool('isLogin')!
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Line(height: 5, color: Colors.grey[200]),
                              )
                            : Container(),
                        Consumer<ProductProvider>(
                            builder: (context, value, child) {
                          print(product!.relatedProductsId);
                          if (value.loadingRelated) {
                            return Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: SegmentTittle(
                                      segment: AppLocalizations.of(context)!
                                          .translate("relate_product"),
                                      isMore: false,
                                      products: widget.product != null
                                          ? widget.product!.relatedProductsId
                                          : product!.relatedProductsId,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 14),
                                    child: ShimmerStyleListScreen(
                                      isFlashSale: false,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: SegmentTittle(
                                      segment: AppLocalizations.of(context)!
                                          .translate("relate_product"),
                                      isMore: true,
                                      products: widget.product != null
                                          ? widget.product!.relatedProductsId
                                          : product!.relatedProductsId,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 14),
                                    child: StyleListScreen(
                                      isFlashSale: false,
                                      listProducts: value.listRelatedProduct,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: SegmentTittle(
                                  segment: AppLocalizations.of(context)!
                                      .translate("featured_product"),
                                  isMore: true,
                                  featured: true,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 14),
                                child: StyleListScreen(
                                  isFlashSale: false,
                                  listProducts: featured.listFeaturedProduct,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: product!.vendor!.id !=
                      Session.data.getInt('id').toString(),
                  child: Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
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
                      padding: EdgeInsets.fromLTRB(14, 8, 14, 8),
                      width: double.infinity,
                      child: product!.vendor!.isClose!
                          ? buildCloseStoreBtn()
                          : Row(
                              children: [
                                product!.vendor!.name!.isEmpty
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          if (Session.data
                                              .getBool('isLogin')!) {
                                            addText(
                                                product!.vendor!.id, product);
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      LoginScreen()),
                                            );
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: accentColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(15),
                                          margin: EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            'assets/images/account/chatwhite.png',
                                            width: 16,
                                          ),
                                        ),
                                      ),
                                Expanded(
                                  child: MaterialButton(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    color: product!.stockStatus == 'instock' &&
                                            product!.productStock! >= 0
                                        ? accentColor
                                        : Colors.grey,
                                    onPressed: () async {
                                      if (product!.type == 'simple') {
                                        if (product!.stockStatus == 'instock' &&
                                            product!.productStock! >= 0) {
                                          setState(() {
                                            product!.cartQuantity = qty;
                                          });
                                          await Provider.of<CartProvider>(
                                                  context,
                                                  listen: false)
                                              .calculatePriceTotal(
                                                  context, product!)
                                              .then((value) => loadCartCount());
                                        } else {
                                          snackBar(context,
                                              message: AppLocalizations.of(
                                                      context)!
                                                  .translate("stock_empty")!);
                                        }
                                      } else {
                                        print('variable');
                                        showMaterialModalBottomSheet(
                                          context: context,
                                          builder: (context) => BottomSheetCart(
                                            product: product,
                                            type: 'add',
                                            loadCount: loadCartCount,
                                          ),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate("add_cart")!,
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: product!.type == 'simple',
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 25,
                                                height: 25,
                                                child: MaterialButton(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  padding: EdgeInsets.all(0),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: qty == 1
                                                              ? greyText
                                                              : accentColor,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  3))),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    if (qty > 1) {
                                                      setState(() {
                                                        qty--;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Icon(
                                                      AntDesign.minus,
                                                      color: qty == 1
                                                          ? greyText
                                                          : tittleColor,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 28,
                                                child: Center(
                                                  child: TextStyles(
                                                      value: qty.toString(),
                                                      size: 14,
                                                      color: tittleColor),
                                                ),
                                              ),
                                              Container(
                                                width: 25,
                                                height: 25,
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
                                                              Radius.circular(
                                                                  3))),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    if (qty <
                                                        product!
                                                            .productStock!) {
                                                      setState(() {
                                                        qty++;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Icon(
                                                      AntDesign.plus,
                                                      color: tittleColor,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  buildPriceVariation(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        product!.variationRegPrices!.isNotEmpty
            ? Visibility(
                visible: product!.isVariationDiscount!,
                child: Text(
                  product!.variationRegPrices!.first ==
                          product!.variationRegPrices!.last
                      ? '${stringToCurrency(product!.variationRegPrices!.first!, context)}'
                      : '${stringToCurrency(product!.variationRegPrices!.first!, context)} - ${stringToCurrency(product!.variationRegPrices!.last!, context)}',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[400],
                  ),
                ),
              )
            : Container(),
        Container(
          child: TextStyles(
            value: product!.variationPrices!.isEmpty
                ? product!.formattedPrice
                : product!.variationPrices!.first ==
                        product!.variationPrices!.last
                    ? '${stringToCurrency(product!.variationPrices!.first!, context)}'
                    : '${stringToCurrency(product!.variationPrices!.first!, context)} - ${stringToCurrency(product!.variationPrices!.last!, context)}',
            size: 15,
            weight: FontWeight.bold,
            color: tittleColor,
            isPrice: true,
          ),
        ),
      ],
    );
  }

  Widget reviewSection() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextStyles(
                value: AppLocalizations.of(context)!.translate("review"),
                size: 14,
                weight: FontWeight.bold,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductReview(
                          productId: widget.id,
                        ),
                      ));
                },
                child: TextStyles(
                  value:
                      AppLocalizations.of(context)!.translate("see_all_review"),
                  size: 12,
                  color: tittleColor,
                  weight: FontWeight.bold,
                ),
              )
            ],
          ),
          reviewProduct.isEmpty
              ? Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 45),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/detail/_reviews_lp8w 1.png',
                          width: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextStyles(
                              value: AppLocalizations.of(context)!
                                  .translate("no_review"),
                              size: 14,
                              weight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviewProduct.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImgStyle(
                            url: reviewProduct[index].avatar,
                            width: 60,
                            height: 60,
                            radius: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextStyles(
                                      value: reviewProduct[index].reviewer,
                                      weight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    RatingBarIndicator(
                                      rating: reviewProduct[index]
                                          .rating!
                                          .toDouble(),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 15,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 255,
                                  child: Container(
                                    child: Html(
                                        style: {
                                          "body": Style(
                                              margin: EdgeInsets.all(0),
                                              padding: EdgeInsets.all(0))
                                        },
                                        data:
                                            """${reviewProduct[index].review}"""),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget inputReviewSection() {
    final product = Provider.of<ProductProvider>(context, listen: false);

    Widget buildBtnReview = Container(
      child: ListenableProvider.value(
        value: product,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          if (value.loadAddReview) {
            return InkWell(
              onTap: null,
              child: Container(
                width: 80,
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3), color: Colors.grey),
                alignment: Alignment.center,
                child: customLoading(),
              ),
            );
          }
          return InkWell(
            onTap: () async {
              if (rating != 0 && reviewController.text.isNotEmpty) {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                UIBlock.block(context);
                await Provider.of<ProductProvider>(context, listen: false)
                    .addReview(context,
                        productId: widget.id,
                        rating: rating,
                        review: reviewController.text)
                    .then((value) {
                  setState(() {
                    reviewController.clear();
                    rating = 0;
                  });
                  loadReviewProduct();
                  UIBlock.unblock(context);
                });
              } else {
                UIBlock.unblock(context);
                snackBar(context,
                    message: AppLocalizations.of(context)!
                        .translate("review_snack")!);
              }
            },
            child: Container(
              width: 80,
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: rating != 0 && reviewController.text.isNotEmpty
                      ? tittleColor
                      : Colors.grey),
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.translate("submit")!,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          );
        }),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("add_review")!,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: reviewController,
            maxLines: 4,
            style: TextStyle(
              fontSize: 10,
            ),
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              hintText: AppLocalizations.of(context)!.translate("type_review"),
              hintStyle: TextStyle(fontSize: 10.sp, color: greyText),
            ),
            textInputAction: TextInputAction.done,
          ),
          SizedBox(
            height: 10,
          ),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 25,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              print(value);
              setState(() {
                rating = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          buildBtnReview
        ],
      ),
    );
  }

  buildCloseStoreBtn() {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      color: Colors.red[900],
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          AppLocalizations.of(context)!.translate("close_detail")!,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
