part of '../widget.dart';

class HomeSegment extends StatefulWidget {
  final List<GeneralSettingsModel>? intro;
  HomeSegment({this.intro});
  @override
  _HomeSegmentState createState() => _HomeSegmentState();
}

CountdownTimerController? controller;
int? end = 0;

class _HomeSegmentState extends State<HomeSegment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late HomeProvider intro;

  int? endTime;
  int? clickIndex = 0;
  String? selectedCategory;
  static late FirebaseMessaging messaging;

  @override
  void initState() {
    intro = Provider.of<HomeProvider>(context, listen: false);
    print(intro.logo.image);
    if (Session.data.getString('cookie') != null) {
      messaging = FirebaseMessaging.instance;
      messaging.getToken().then((value) {
        Provider.of<ListNotificationProvider>(context, listen: false)
            .sendNotification(token: value);
      });
    }

    final products = Provider.of<ProductProvider>(context, listen: false);
    super.initState();
    getListFlashSale();
    if (products.listNewProduct.isEmpty) {
      loadNewProduct(true);
    }
  }

  void onEnd() {}

  loadNewProduct(bool loading) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchNewProducts(clickIndex == 0 ? '' : selectedCategory);
  }

  getListFlashSale() async {
    Provider.of<HomeProvider>(context, listen: false)
        .fetchFlashSale()
        .then((value) {
      if (value != null && mounted) {
        setState(() {
          var selesai = DateFormat('yyyy-MM-dd HH:mm:ss').parse(value.end!);
          endTime = selesai.microsecondsSinceEpoch;
          controller =
              CountdownTimerController(endTime: endTime!, onEnd: onEnd);
          end = endTime;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final products = Provider.of<ProductProvider>(context, listen: false);

    return UpgradeAlert(
      upgrader: Upgrader(
        showIgnore: false,
        canDismissDialog: false,
        showReleaseNotes: false,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.18),
          titleSpacing: 0,
          leadingWidth: 35,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            child: Container(
              margin: EdgeInsets.only(left: 12),
              child: Image.asset(
                'assets/images/home/menu-alt-left.png',
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                if (Session.data.getBool('isLogin')!) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatHomeScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/images/account/dashicons_format-chat.png',
                  width: 25,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (Session.data.getBool('isLogin')!) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WishListScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/images/home/mdi_heart.png',
                  width: 25,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (Session.data.getBool('isLogin')!) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/images/home/mdi_bell.png',
                  width: 25,
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(right: 8, top: 10),
                      child: CachedNetworkImage(
                        imageUrl: intro.logo.image!,
                        fit: BoxFit.fitWidth,
                        width: 100,
                        placeholder: (context, url) => customLoading(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/home/gg_shopping-bag.png',
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: TextStyles(
                        value: AppLocalizations.of(context)!.translate("shop"),
                        size: 16,
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllStoreScreen(),
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/home/fluent_news-24-regular.png',
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: TextStyles(
                        value: AppLocalizations.of(context)!.translate("blog"),
                        size: 16,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Provider.of<BlogProvider>(context, listen: false)
                      .getBanner(context)
                      .then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogScreen(),
                      ),
                    );
                  });
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    ImageIcon(AssetImage("assets/images/account/chatwhite.png"),
                        size: 20, color: Colors.black),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: TextStyles(
                        value: AppLocalizations.of(context)!
                            .translate("live_chat"),
                        size: 16,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (Session.data.getBool('isLogin')!) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatHomeScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  }
                },
              ),
              Divider(),
              // ListTile(
              //   title: Row(
              //     children: [
              //       Image.asset(
              //         'assets/images/home/akar-icons_whatsapp-fill.png',
              //         width: 20,
              //       ),
              //       Container(
              //         margin: EdgeInsets.only(left: 20),
              //         child: TextStyles(
              //           value: 'Whatsapp Contact',
              //           size: 16,
              //         ),
              //       ),
              //     ],
              //   ),
              //   onTap: () {},
              // ),
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Session.data.getBool('isLogin')!
                          ? AntDesign.logout
                          : AntDesign.login,
                      size: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: TextStyles(
                        value: Session.data.getBool('isLogin')!
                            ? AppLocalizations.of(context)!.translate("logout")
                            : AppLocalizations.of(context)!.translate("login"),
                        size: 16,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (Session.data.getBool('isLogin')!) {
                    auth.signOut(context, isFromDrawer: true).then((value) {
                      this.setState(() {});
                      Navigator.pop(context);
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  }
                },
              ),
              Divider(),
              ExpansionTile(
                title: TextStyles(
                  value:
                      AppLocalizations.of(context)!.translate("by_categories"),
                  size: 16,
                ),
                childrenPadding: EdgeInsets.zero,
                children: [
                  Consumer<CategoryProvider>(builder: (context, value, child) {
                    if (value.loading) {
                      return Container();
                    } else {
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, i) {
                          return Divider();
                        },
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.productCategories.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (value.productCategories[index].subCategories!
                              .isNotEmpty) {
                            return ExpansionTile(
                              title: InkWell(
                                child: Text(
                                  value.productCategories[index].name!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: greyText),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubCategoriesScreen(
                                        nonSub: true,
                                        title:
                                            value.productCategories[index].name,
                                        id: value.productCategories[index].id
                                            .toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              children: [
                                ListView.separated(
                                  padding: EdgeInsets.zero,
                                  separatorBuilder: (context, i) {
                                    return Divider();
                                  },
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: value.productCategories[index]
                                      .subCategories!.length,
                                  itemBuilder: (BuildContext context, int j) {
                                    return ListTile(
                                      contentPadding:
                                          EdgeInsets.only(left: 25, right: 15),
                                      title: Text(
                                        value.productCategories[index]
                                            .subCategories![j].name!,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: greyText),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SubCategoriesScreen(
                                              nonSub: true,
                                              title: value
                                                  .productCategories[index]
                                                  .subCategories![j]
                                                  .name,
                                              id: value.productCategories[index]
                                                  .subCategories![j].id
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      trailing: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                )
                              ],
                            );
                          }
                          return ListTile(
                            title: Text(
                              value.productCategories[index].name!,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: greyText),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubCategoriesScreen(
                                    nonSub: true,
                                    title: value.productCategories[index].name,
                                    id: value.productCategories[index].id
                                        .toString(),
                                  ),
                                ),
                              );
                            },
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                            ),
                          );
                        },
                      );
                    }
                  }),
                ],
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.only(right: 8),
                        child: CachedNetworkImage(
                          imageUrl: intro.logo.image!,
                          placeholder: (context, url) => customLoading(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate("welcome")!,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: tittleColor),
                          ),
                          Visibility(
                              visible: !Session.data.getBool('isLogin')!,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("pls_login")!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: tittleColor,
                                  ),
                                ),
                              )),
                          Visibility(
                            visible: Session.data.getBool('isLogin')!,
                            child: Text(
                              "${AppLocalizations.of(context)!.translate('say_hi')!} ${Session.data.getString('firstname')} ${Session.data.getString('lastname') ?? ""}",
                              style:
                                  TextStyle(fontSize: 16, color: tittleColor),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2, color: Colors.grey.withOpacity(0.23))
                      ]),
                  height: 40,
                  margin: EdgeInsets.fromLTRB(14, 0, 14, 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          EvilIcons.search,
                          size: 30,
                          color: Colors.grey[400],
                        ),
                        TextStyles(
                          value: AppLocalizations.of(context)!
                              .translate("search_prod"),
                          color: Colors.grey[400],
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Banner Slider
              MVBannerSlider(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                child: Column(
                  children: [
                    Consumer<HomeProvider>(builder: (context, value, child) {
                      if (value.loadingCategories) {
                        return Container();
                      } else {
                        return Column(
                          children: [
                            SegmentTittle(
                              segment: AppLocalizations.of(context)!
                                  .translate("categories"),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: value.categories.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 1, crossAxisCount: 4),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 9),
                                          child: value.categories[index]
                                                      .categories ==
                                                  null
                                              ? InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CategoriesScreen(
                                                          withBackBtn: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    value.categories[index]
                                                        .image!,
                                                    width: 35,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SubCategoriesScreen(
                                                          nonSub: true,
                                                          title: value
                                                              .categories[index]
                                                              .titleCategories,
                                                          id: value
                                                              .categories[index]
                                                              .categories
                                                              .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl: value
                                                        .categories[index]
                                                        .image!,
                                                    fit: BoxFit.cover,
                                                    width: 35,
                                                    placeholder:
                                                        (context, url) =>
                                                            customLoading(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                        ),
                                        TextStyles(
                                          value: value.categories[index]
                                                      .titleCategories ==
                                                  "View More"
                                              ? AppLocalizations.of(context)!
                                                  .translate("view_more")
                                              : value.categories[index]
                                                  .titleCategories,
                                          size: 12,
                                          align: TextAlign.center,
                                          weight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }
                    }),
                    AdMobState(type: 'home'),
                    Consumer<HomeProvider>(
                      builder: (context, value, child) {
                        return endTime == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 14),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: tittleColor.withOpacity(0.40),
                                        width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9))),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                              "assets/images/home/Blink-Flash-Sale-88x350.gif",
                                              width: 130),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FlashSaleScreen(
                                                    featured: false,
                                                    flash: value.listFlashSale,
                                                    id: value
                                                        .productFlash!.products,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "More",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: tittleColor,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: CountdownTimer(
                                        endTime: endTime,
                                        widgetBuilder:
                                            (_, CurrentRemainingTime? time) {
                                          if (time == null) {
                                            setState(() {
                                              endTime = null;
                                            });
                                          }
                                          return Row(
                                            children: [
                                              TimerStyle(
                                                timer: time!.hours,
                                                color: tittleColor,
                                                width: 31.5,
                                                height: 31.5,
                                                textColor: tittleColor,
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: tittleColor,
                                                  ),
                                                ),
                                              ),
                                              TimerStyle(
                                                timer: time.min,
                                                color: tittleColor,
                                                width: 31.5,
                                                height: 31.5,
                                                textColor: tittleColor,
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: tittleColor,
                                                  ),
                                                ),
                                              ),
                                              TimerStyle(
                                                timer: time.sec,
                                                color: tittleColor,
                                                width: 31.5,
                                                height: 31.5,
                                                textColor: tittleColor,
                                              ),
                                            ],
                                          );
                                          // return Text(
                                          //     'hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                                        },
                                      ),
                                    ),
                                    StyleListScreen(
                                      isFlashSale: true,
                                      listProducts: value.listFlashSale,
                                    ),
                                  ],
                                ),
                              );
                      },
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
                    Consumer<HomeProvider>(builder: (context, value, child) {
                      if (value.loadingBestStore) {
                        return ShimmerStoreList();
                      } else {
                        return StoreList();
                      }
                    }),
                    Consumer<HomeProvider>(builder: (context, value, child) {
                      if (value.loadingMiniBanner) {
                        return Container();
                      } else {
                        return ImageGridStyle(
                          banners: value.firstBanners,
                        );
                      }
                    }),
                    Consumer<HomeProvider>(builder: (context, value, child) {
                      if (value.loadingBest) {
                        return ShimmerStyleListScreen(
                          isFlashSale: false,
                        );
                      }
                      if (value.listBestProduct.isEmpty) {
                        return Container();
                      }
                      return Column(
                        children: [
                          SegmentTittle(
                            segment: value.productBest.title,
                            isMore: true,
                            rating: true,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            child: StyleListScreen(
                              isFlashSale: false,
                              listProducts: value.listBestProduct,
                            ),
                          ),
                        ],
                      );
                    }),
                    Consumer<HomeProvider>(builder: (context, value, child) {
                      if (value.loadingMiniBanner) {
                        return Container();
                      } else {
                        return ImageGridStyle(
                          banners: value.secondBanners,
                        );
                      }
                    }),
                    Consumer<HomeProvider>(builder: (context, value, child) {
                      if (value.loadingRecommendation) {
                        return ShimmerStyleListScreen(
                          isFlashSale: false,
                        );
                      }
                      if (value.listRecommendationProduct.isEmpty) {
                        return Container();
                      }
                      return Column(
                        children: [
                          SegmentTittle(
                              segment: value.productRecommendation.title,
                              // products: value.productRecommendation.products,
                              isMore: true),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            child: StyleListScreen(
                              isFlashSale: false,
                              listProducts: value.listRecommendationProduct,
                            ),
                          ),
                        ],
                      );
                    }),
                    /*SegmentTittle(
                    segment: "Recently Viewed Products",
                    isMore: true,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 14),
                    child: StyleListScreen(
                      isFlashSale: false,
                    ),
                  ),*/

                    //---------------------------------------------------------------------------------------------------- CATEGORIES MENU

                    Consumer<CategoryProvider>(
                        builder: (context, value, child) {
                      if (value.loading) {
                        return Container();
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height / 21,
                          child: ListView.separated(
                              itemCount: value.productCategories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        clickIndex =
                                            value.productCategories[i].id;
                                        selectedCategory = value
                                            .productCategories[i].id
                                            .toString();
                                      });
                                      loadNewProduct(true);
                                    },
                                    child: tabCategory(
                                        value.productCategories[i],
                                        i,
                                        value.productCategories.length));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 8,
                                );
                              }),
                        );
                      }
                    }),
                    ListenableProvider.value(
                      value: products,
                      child: Consumer<ProductProvider>(
                          builder: (context, value, child) {
                        if (value.loadingNew) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            child: ShimmerGridListProduct(
                              isManageProduct: false,
                            ),
                          );
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 14),
                          child: GridListProduct(
                            // favorite: true,
                            isManageProduct: false,
                            listProduct: value.listNewProduct,
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabCategory(ProductCategoryModel model, int i, int count) {
    return Container(
      margin: EdgeInsets.only(
          left: i == 0 ? 15 : 0, right: i == count - 1 ? 15 : 0),
      child: Tab(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: clickIndex == model.id ? accentColor : Colors.white,
              border: Border.all(
                  color: clickIndex == model.id ? accentColor : accentColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              convertHtmlUnescape(model.name!),
              style: TextStyle(
                  fontSize: 14,
                  color:
                      clickIndex == model.id ? Colors.grey[100] : accentColor),
            )),
      ),
    );
  }
}
