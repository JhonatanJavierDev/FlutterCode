// import 'dart:math';
// import 'package:flutter/material.dart';
part of '../pages.dart';

class DetailStoreScreen extends StatefulWidget {
  final int? id;

  const DetailStoreScreen({Key? key, this.id}) : super(key: key);
  @override
  _DetailStoreScreenState createState() => _DetailStoreScreenState();
}

class _DetailStoreScreenState extends State<DetailStoreScreen>
    with TickerProviderStateMixin {
  late AnimationController _colorAnimationController;
  late AnimationController _textAnimationController;
  Animation? _colorTween, _colorScroll, _searchColor, _shadowApp;
  TextEditingController search = new TextEditingController();
  int page = 1;
  String category = '';
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    var product = Provider.of<StoreProvider>(context, listen: false);
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_colorAnimationController);
    _colorScroll = ColorTween(begin: Colors.white, end: darkColor)
        .animate(_colorAnimationController);
    _searchColor = ColorTween(begin: Colors.white, end: Color(0xFFBDBDBD))
        .animate(_colorAnimationController);
    _shadowApp = ColorTween(
            begin: Colors.transparent, end: Colors.grey.withOpacity(0.18))
        .animate(_colorAnimationController);
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print(true);
        if (product.listStoreProducts.length % 8 == 0 &&
            !product.loadingStoreProduct) {
          setState(() {
            page++;
          });
          loadProductStore();
        }
      }
    });

    super.initState();
    // print(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDetail();
      loadProductStore();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 150);

      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - 350) / 50);
      return true;
    }
    return false;
  }

  loadDetail() async {
    await Provider.of<StoreProvider>(context, listen: false)
        .fetchDetailStore(context, id: widget.id);
  }

  loadProductStore() async {
    this.setState(() {});
    await Provider.of<StoreProvider>(context, listen: false)
        .storeProducts(search.text, widget.id, page, indexed.toString())
        .then((value) => this.setState(() {}));
  }

  int? indexed;
  void _detailModalBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        var category = Provider.of<StoreProvider>(context).store.categories;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 20, right: 15),
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
                              margin: EdgeInsets.only(top: 20, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: TextStyles(
                                      value: AppLocalizations.of(context)!
                                          .translate("select_prod_cat"),
                                      size: 16,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: category!.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider();
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        child: GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              if (indexed ==
                                                  category[index].id) {
                                                indexed = null;
                                              } else {
                                                indexed = category[index].id;
                                              }
                                              page = 1;
                                            });
                                            Navigator.pop(context);
                                            _scrollToTop();
                                            loadProductStore();
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextStyles(
                                                      value:
                                                          category[index].name,
                                                      size: 16,
                                                    ),
                                                    TextStyles(
                                                        value:
                                                            "${category[index].totalProduct} Products",
                                                        size: 14,
                                                        color:
                                                            Color(0xFF9E9E9E)),
                                                  ],
                                                ),
                                                indexed != category[index].id
                                                    ? Container()
                                                    : Icon(
                                                        MaterialCommunityIcons
                                                            .check_circle,
                                                        color: tittleColor,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
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

  void addText(String vendorID) async {
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
              receiverId: vendorID,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: Consumer<StoreProvider>(builder: (context, value, child) {
          return Container(
            height: double.infinity,
            child: Stack(
              children: <Widget>[
                Consumer<StoreProvider>(builder: (context, value, child) {
                  if (value.loadingStore) {
                    return Container(
                      height: 207,
                    );
                  } else {
                    return ImgStyle(
                      url: value.store.banner,
                      width: double.infinity,
                      height: 207,
                      radius: 0,
                    );
                  }
                }),
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
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Stack(
                    children: [
                      Consumer<StoreProvider>(builder: (context, value, child) {
                        if (value.loadingStore) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                                margin: EdgeInsets.only(top: 95, left: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextStyles(
                                            value: AppLocalizations.of(context)!
                                                .translate('store')!,
                                            size: 14,
                                            weight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(right: 8),
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(100),
                                                    ),
                                                  ),
                                                ),
                                                TextStyles(
                                                    value: '-',
                                                    size: 12,
                                                    color: Colors.white,
                                                    weight: FontWeight.normal)
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 20,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: 5,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
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
                                    )
                                  ],
                                )),
                          );
                        } else {
                          return Container(
                              margin: EdgeInsets.only(top: 95, left: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImgStyle(
                                    url: value.store.icon,
                                    width: 73,
                                    height: 73,
                                    radius: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextStyles(
                                          value: value.store.name,
                                          size: 14,
                                          weight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 8),
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: value.store.isClose!
                                                      ? Colors.red
                                                      : Color(0xFF31D07A),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                              ),
                                              TextStyles(
                                                  value: value.store.isClose!
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .translate("close")
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .translate("open"),
                                                  size: 12,
                                                  color: Colors.white,
                                                  weight: FontWeight.normal)
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RatingBarIndicator(
                                              rating: value.store.averageRating
                                                  .toDouble(),
                                              itemSize: 20,
                                              itemCount: 5,
                                              unratedColor: Colors.grey,
                                              itemBuilder: (context, index) {
                                                return Icon(
                                                  MaterialCommunityIcons.star,
                                                  size: 20,
                                                  color: Colors.orange,
                                                );
                                              },
                                            ),
                                            /*Text(
                                              "${value.store.averageRating}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),*/
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ));
                        }
                      }),
                      value.loadingStore
                          ? SizedBox()
                          : Visibility(
                              visible:
                                  value.store.id != Session.data.getInt('id'),
                              child: Positioned(
                                right: 10,
                                top: 90,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (Session.data.getBool('isLogin')!) {
                                      addText(Provider.of<StoreProvider>(
                                              context,
                                              listen: false)
                                          .store
                                          .id
                                          .toString());
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => LoginScreen()),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
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
                                              const EdgeInsets.only(left: 5),
                                          child: TextStyles(
                                            value: AppLocalizations.of(context)!
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
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 190, 0, 0),
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/images/account/icon-park-outline_transaction-order.png",
                                        width: 25,
                                      ),
                                      Container(width: 18),
                                      Consumer<StoreProvider>(
                                          builder: (context, value, child) {
                                        if (value.loadingStore) {
                                          return Container();
                                        } else {
                                          return Container(
                                            width: 260,
                                            child: value
                                                    .store.description!.isEmpty
                                                ? TextStyles(
                                                    value: "Not Set",
                                                    size: 12,
                                                  )
                                                : Html(
                                                    data:
                                                        value.store.description,
                                                  ),
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Line(
                              height: 5,
                              color: greyLine,
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
                                    Consumer<StoreProvider>(
                                        builder: (context, value, child) {
                                      if (value.loadingStore) {
                                        return Container();
                                      } else {
                                        return Container(
                                          width: 260,
                                          child: TextStyles(
                                            value: value.store.address!.isEmpty
                                                ? "Not Set"
                                                : value.store.address,
                                            size: 12,
                                            weight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Line(
                              height: 5,
                              color: greyLine,
                            ),
                            Consumer<StoreProvider>(
                                builder: (context, value, child) {
                              if (value.loadingStoreProduct && page == 1) {
                                return ShimmerGridListProduct(
                                  isManageProduct: false,
                                );
                              }
                              return Container(
                                color: Colors.white,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(14, 0, 14, 60),
                                  child: GridListProduct(
                                    isManageProduct: false,
                                    listProduct: value.listStoreProducts,
                                  ),
                                ),
                              );
                            }),
                            if (value.loadingStoreProduct && page != 1)
                              customLoading()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  child: AnimatedBuilder(
                    animation: _colorAnimationController,
                    builder: (context, child) => AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: _colorTween!.value,
                      elevation: 5,
                      shadowColor: _shadowApp!.value,
                      titleSpacing: 0.0,
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Icon(MaterialCommunityIcons.arrow_left,
                              color: _colorScroll!.value),
                        ),
                      ),
                      title: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: _searchColor!.value, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        height: 38,
                        child: TextField(
                          controller: search,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            this.setState(() {});
                            loadProductStore();
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 13, color: _searchColor!.value),
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              child: Icon(EvilIcons.search,
                                  color: _searchColor!.value),
                            ),
                            hintText: AppLocalizations.of(context)!
                                .translate("search_prod"),
                            hintStyle: TextStyle(
                                fontSize: 13, color: _searchColor!.value),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.fromLTRB(17, 5, 0, 5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              onPressed: () {
                                _detailModalBottomSheet(context);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    child: ImageIcon(
                                      AssetImage('assets/images/filter.png'),
                                      color: tittleColor,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: TextStyles(
                                      value: AppLocalizations.of(context)!
                                          .translate("category"),
                                      size: 14,
                                      color: tittleColor,
                                      weight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
