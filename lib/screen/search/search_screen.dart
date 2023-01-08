part of '../pages.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearch = false;
  int indexed = 0;

  int page = 1;

  String order = 'DESC';
  String orderBy = 'popularity';
  TextEditingController search = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  Future searchProducts() async {
    setState(() {
      isSearch = true;
    });
    await Provider.of<SearchProvider>(context, listen: false)
        .searchProducts(search.text, order, orderBy, page);
  }

  @override
  void initState() {
    super.initState();
    final search = Provider.of<SearchProvider>(context, listen: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print(true);
        if (search.listSearchProducts.length % 8 == 0) {
          setState(() {
            page++;
          });
          searchProducts();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.18),
        titleSpacing: 0,
        leadingWidth: 35,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(MaterialCommunityIcons.arrow_left, color: darkColor),
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFBDBDBD), width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15),
          height: 38,
          child: TextField(
            controller: search,
            keyboardType: TextInputType.text,
            onSubmitted: (value) async {},
            onChanged: (value) {
              if (search.text.isEmpty) {
                setState(() {
                  isSearch = false;
                });
              }
              setState(() {
                page = 1;
              });
              if (search.text.isNotEmpty) searchProducts();
            },
            // textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: Container(
                child: Icon(EvilIcons.search, color: Colors.black38),
              ),
              hintText:
                  AppLocalizations.of(context)!.translate("search_product")!,
              hintStyle: TextStyle(fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
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
      ),
      body: isSearch == false
          ? Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/search_icon.png', width: 160),
                    Container(
                      height: 20,
                    ),
                    TextStyles(
                      value: AppLocalizations.of(context)!
                          .translate("search_product_here")!,
                      size: 18,
                      color: darkColor,
                    )
                  ],
                ),
              ),
            )
          : ListenableProvider.value(
              value: searchProvider,
              child: Consumer<SearchProvider>(builder: (context, value, child) {
                if (value.loadingSearch && page == 1) {
                  return SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.all(15),
                        child: ShimmerGridListProduct(
                          isManageProduct: false,
                        )),
                  );
                }
                if (value.listSearchProducts.isEmpty) {
                  return Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          child: GridListProduct(
                            isManageProduct: false,
                            listProduct: value.listSearchProducts,
                          ),
                        ),
                        if (searchProvider.loadingSearch && page != 1)
                          customLoading()
                      ],
                    ));
              }),
            ),
    );
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
                                            searchProducts();
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            height: 40,
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
}
