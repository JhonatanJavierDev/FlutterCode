part of '../pages.dart';

class SubCategoriesScreen extends StatefulWidget {
  final bool? nonSub;
  final String? title, slug, id;
  SubCategoriesScreen({this.nonSub, this.title, this.slug, this.id});

  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  int variantIndex = 0;
  int indexed = 0;
  int page = 1;

  String order = 'DESC';
  String orderBy = 'popularity';
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    final product = Provider.of<ProductProvider>(context, listen: false);

    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (product.listProductCategory.length % 8 == 0) {
          setState(() {
            page++;
          });
          loadProducts();
        }
      }
    });
    loadProducts();
  }

  loadProducts() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchProductByCategory(widget.id,
            page: page, order: order, orderBy: orderBy);
  }

  void _detailModalBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
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
                                      return GestureDetector(
                                        onTap: () {
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextStyles(
                                                  value: AppLocalizations.of(
                                                          context)!
                                                      .translate(filterList[i]
                                                          .replaceAll(" ", "_")
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
    final product = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: Visibility(
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                      value: AppLocalizations.of(context)!.translate("sort"),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          widget.title!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              // margin: EdgeInsets.fromLTRB(15, 20, 15, 60),
              child: Column(
                children: [
                  widget.nonSub != true
                      ? Container(
                          height: 38,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    variantIndex = index;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 3),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: variantIndex == index
                                        ? accentColor
                                        : Colors.white,
                                    border: Border.all(
                                      color: variantIndex == index
                                          ? Colors.white
                                          : darkColor.withOpacity(0.09),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${AppLocalizations.of(context)!.translate('sub_category')!}($index)",
                                      style: TextStyle(
                                        color: variantIndex == index
                                            ? Colors.white
                                            : darkColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                  ListenableProvider.value(
                    value: product,
                    child: Consumer<ProductProvider>(
                        builder: (context, value, child) {
                      if (value.loadingCategory && page == 1) {
                        return Container(
                            child: ShimmerGridListProduct(
                          isManageProduct: false,
                        ));
                      }
                      if (value.listProductCategory.isEmpty) {
                        return Center(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20,
                                ),
                                Image.asset('assets/images/search_icon.png',
                                    width: 160),
                                Container(
                                  height: 20,
                                ),
                                TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate('prod_not_found')!,
                                  size: 18,
                                  color: darkColor,
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SingleChildScrollView(
                          child: Column(
                        children: [
                          SizedBox(height: 20),
                          MVBannerSlider(),
                          AdMobState(type: 'category'),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: GridListProduct(
                              isManageProduct: false,
                              listProduct: value.listProductCategory,
                            ),
                          ),
                          if (product.loadingCategory && page != 1)
                            customLoading()
                        ],
                      ));
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
