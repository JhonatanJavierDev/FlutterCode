part of '../pages.dart';

// ignore: must_be_immutable
class FlashSaleScreen extends StatefulWidget {
  final String? id;
  final bool? featured;
  List<ProductModel>? flash;
  FlashSaleScreen({this.id, this.featured, this.flash});
  @override
  _FlashSaleScreenState createState() => _FlashSaleScreenState();
}

class _FlashSaleScreenState extends State<FlashSaleScreen> {
  int? indexed;
  bool scrollVisibility = true;
  ScrollController _scrollController = new ScrollController();
  int page = 1;

  final controller = PageController();
  int pageIndex = 0;

  String order = 'DESC';
  String orderBy = 'popularity';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // scrollcontroller.addListener(() {
      //   print("asddas");
      //   // if (scrollcontroller.position.pixels > 0 ||
      //   //     scrollcontroller.position.pixels <
      //   //         scrollcontroller.position.maxScrollExtent)
      //   //   scrollVisibility = false;
      //   // else
      //   //   scrollVisibility = true;

      //   // setState(() {});
      // });
      _scrollController.addListener(() {});
    });
  }

  loadProducts() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchMoreExtendProductFlash(widget.id,
            page: page, order: order, orderBy: orderBy, featured: false)
        .then((value) {
      if (value.isNotEmpty) {
        setState(() {
          widget.flash = value;
        });
      }
    });
  }

  void _detailModalBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
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
                                          .translate("sort_by"),
                                      size: 16,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: filterList.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider();
                                    },
                                    itemBuilder: (BuildContext context, int i) {
                                      return InkWell(
                                        child: GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              indexed = i;
                                            });

                                            setModalState(() {
                                              indexed = i;
                                              page = 1;
                                            });
                                            if (i == 0) {
                                              setState(() {
                                                order = 'DESC';
                                                orderBy = 'popularity';
                                              });
                                            } else if (i == 1) {
                                              setState(() {
                                                order = 'DESC';
                                                orderBy = 'date';
                                              });
                                            } else if (i == 2) {
                                              setState(() {
                                                order = 'DESC';
                                                orderBy = 'price';
                                              });
                                            } else if (i == 3) {
                                              setState(() {
                                                order = 'ASC';
                                                orderBy = 'price';
                                              });
                                            }
                                            loadProducts();
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            height: 40,
                                            // padding: EdgeInsets.symmetric(
                                            //     vertical: 10),
                                            // margin: EdgeInsets.only(top: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextStyles(
                                                    value: AppLocalizations.of(
                                                            context)!
                                                        .translate(filterList[i]
                                                            .replaceAll(
                                                                " ", "_")
                                                            .toLowerCase())),
                                                indexed != i
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

  Widget build(BuildContext context) {
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
          'FLASH SALE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // IntroScreen(),
          Consumer<HomeProvider>(builder: (context, value, child) {
            return CustomScrollView(
              slivers: [
                for (var i = 0; i < value.flashSaleBanner.length; i++)
                  SliverToBoxAdapter(
                    child: value.flashSaleBanner[i].image != ""
                        ? Container(
                            height: 207,
                            child: PageView(
                              controller: controller,
                              children: [
                                for (var i = 0;
                                    i < value.flashSaleBanner.length;
                                    i++)
                                  CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: value.flashSaleBanner[i].image!,
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
                            ))
                        : SizedBox(),
                  ),
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  actions: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Container(
                              height: 120,
                              child: Image.asset(
                                'assets/images/detail/bg-flashsale.png',
                                fit: BoxFit.cover,
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 12, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                    "assets/images/home/Blink-Flash-Sale-88x350.gif",
                                    width: 104),
                                Container(
                                  height: 3,
                                ),
                                TextStyles(
                                  value:
                                      "${AppLocalizations.of(context)!.translate("remaining_time")!}:",
                                  size: 10,
                                  weight: FontWeight.bold,
                                  color: Color(0xFFED4B9E),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 20,
                            bottom: 8,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: CountdownTimer(
                                endTime: end,
                                widgetBuilder: (_, CurrentRemainingTime? time) {
                                  if (time == null) {
                                    return Text('Game over');
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
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
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

                                  // return Text(
                                  //     'hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Consumer<HomeProvider>(
                    builder: (context, value, child) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: GridListProduct(
                          isManageProduct: false,
                          listProduct: widget.flash,
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }),
          // CustomScrollView(
          //   slivers: [
          //     SliverToBoxAdapter(
          //       child: Container(
          //         height: 207,
          //         child: Consumer<HomeProvider>(
          //           builder: ((context, value, child) {
          //             print(value);
          //             print(value.flashSaleBanner);
          //             return PageView(
          //               controller: controller,
          //               children: [
          //                 for (var i = 0; i < value.flashSaleBanner.length; i++)
          //                   CachedNetworkImage(
          //                     fit: BoxFit.cover,
          //                     imageUrl: value.flashSaleBanner[i].image!,
          //                     placeholder: (context, url) => customLoading(),
          //                     errorWidget: (context, url, error) =>
          //                         Icon(Icons.error),
          //                   ),
          //               ],
          //               onPageChanged: (index) {
          //                 setState(() {
          //                   pageIndex = index;
          //                 });
          //               },
          //             );
          //           }),
          //         ),
          //       ),
          //     ),
          //     SliverAppBar(
          //       elevation: 0,
          //       pinned: true,
          //       automaticallyImplyLeading: false,
          //       actions: [
          //         Container(
          //           width: MediaQuery.of(context).size.width,
          //           child: Stack(
          //             children: [
          //               Container(
          //                   height: 120,
          //                   child: Image.asset(
          //                     'assets/images/detail/bg-flashsale.png',
          //                     fit: BoxFit.cover,
          //                   )),
          //               Padding(
          //                 padding: const EdgeInsets.fromLTRB(15, 12, 0, 0),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Image.asset(
          //                         "assets/images/home/Blink-Flash-Sale-88x350.gif",
          //                         width: 104),
          //                     Container(
          //                       height: 3,
          //                     ),
          //                     TextStyles(
          //                       value:
          //                           "${AppLocalizations.of(context)!.translate("remaining_time")!}:",
          //                       size: 10,
          //                       weight: FontWeight.bold,
          //                       color: Color(0xFFED4B9E),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Positioned(
          //                 right: 20,
          //                 bottom: 8,
          //                 child: Container(
          //                   margin: EdgeInsets.only(top: 5),
          //                   child: CountdownTimer(
          //                     endTime: end,
          //                     widgetBuilder: (_, CurrentRemainingTime? time) {
          //                       if (time == null) {
          //                         return Text('Game over');
          //                       }
          //                       return Row(
          //                         children: [
          //                           TimerStyle(
          //                             timer: time.hours,
          //                             color: Colors.white,
          //                             width: 35,
          //                             height: 35,
          //                             backgroundColor: Colors.white,
          //                             textColor: tittleColor,
          //                           ),
          //                           Container(
          //                             margin:
          //                                 EdgeInsets.symmetric(horizontal: 5),
          //                             child: Text(
          //                               ":",
          //                               style: TextStyle(
          //                                   fontWeight: FontWeight.bold,
          //                                   fontSize: 16,
          //                                   color: Colors.white),
          //                             ),
          //                           ),
          //                           TimerStyle(
          //                             timer: time.min,
          //                             color: Colors.white,
          //                             width: 35,
          //                             height: 35,
          //                             backgroundColor: Colors.white,
          //                             textColor: tittleColor,
          //                           ),
          //                           Container(
          //                             margin:
          //                                 EdgeInsets.symmetric(horizontal: 5),
          //                             child: Text(
          //                               ":",
          //                               style: TextStyle(
          //                                   fontWeight: FontWeight.bold,
          //                                   fontSize: 16,
          //                                   color: Colors.white),
          //                             ),
          //                           ),
          //                           TimerStyle(
          //                             timer: time.sec,
          //                             color: Colors.white,
          //                             width: 35,
          //                             height: 35,
          //                             backgroundColor: Colors.white,
          //                             textColor: tittleColor,
          //                           ),
          //                         ],
          //                       );

          //                       // return Text(
          //                       //     'hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
          //                     },
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //     SliverToBoxAdapter(
          //       child: Consumer<HomeProvider>(
          //         builder: (context, value, child) {
          //           return Container(
          //             margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //             child: GridListProduct(
          //               isManageProduct: false,
          //               listProduct: widget.flash,
          //             ),
          //           );
          //         },
          //       ),
          //     )
          //   ],
          // ),
          Visibility(
            visible: scrollVisibility,
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
                                AssetImage('assets/images/sort.png'),
                                color: tittleColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("sort"),
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
          )
        ],
      ),
    );
  }
}
