part of 'widget.dart';

class StyleListScreen extends StatelessWidget {
  const StyleListScreen({Key? key, this.isFlashSale, this.listProducts})
      : super(key: key);
  final bool? isFlashSale;
  final List<ProductModel>? listProducts;

  final int rate = 3;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: isFlashSale! ? 1.10 : 1.25,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listProducts!.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 130.w,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  offset: Offset(-1, 0),
                  color: Colors.grey.withOpacity(0.40),
                  blurRadius: 3)
            ]),
            margin: EdgeInsets.fromLTRB(4, 12, 4, 12),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 115.h,
                      width: 130.w,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailProductScreen(
                                id: listProducts![index].id.toString(),
                                isFlashSale: isFlashSale,
                                product: listProducts![index],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            memCacheHeight: 330,
                            memCacheWidth: 330,
                            imageUrl: listProducts![index].images![0].src!,
                            fit: BoxFit.fitWidth,
                            width: 100,
                            placeholder: (context, url) => customLoading(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: MarqueeWidget(
                                  direction: Axis.horizontal,
                                  child: Text(
                                    listProducts![index].productName!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                              listProducts![index].discProduct == 0
                                  ? Text(
                                      " ",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[400],
                                      ),
                                    )
                                  : Visibility(
                                      visible:
                                          listProducts![index].discProduct != 0,
                                      child: Text(
                                        listProducts![index].formattedPrice!,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                              listProducts![index].type == 'simple' ||
                                      listProducts![index].type == 'grouped'
                                  ? Container(
                                      child: TextStyles(
                                        value:
                                            listProducts![index].discProduct !=
                                                    0
                                                ? listProducts![index]
                                                    .formattedSalePrice
                                                : listProducts![index]
                                                    .formattedPrice,
                                        size: 12,
                                        weight: FontWeight.bold,
                                        color: tittleColor,
                                        isPrice: true,
                                      ),
                                    )
                                  : buildPriceVariation(index, context),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingBarIndicator(
                                    rating: double.parse(
                                        listProducts![index].avgRating!),
                                    itemSize: 16,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Icon(
                                        MaterialCommunityIcons.star,
                                        size: 16,
                                        color: Colors.orange,
                                      );
                                    },
                                  ),
                                  Text(
                                    "(${listProducts![index].ratingCount})",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: listProducts![index].discProduct != 0,
                  child: Container(
                    width: 40,
                    height: 25,
                    decoration: BoxDecoration(
                      color: tittleColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${listProducts![index].discProduct!.toInt()}%",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                listProducts![index].isVariationDiscount!
                    ? Container(
                        height: 25,
                        width: listProducts![index].discVariation!.first ==
                                listProducts![index].discVariation!.last
                            ? 40
                            : 60,
                        decoration: BoxDecoration(
                          color: tittleColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            listProducts![index].discVariation!.first ==
                                    listProducts![index].discVariation!.last
                                ? "${listProducts![index].discVariation!.first}%"
                                : "${listProducts![index].discVariation!.first}-${listProducts![index].discVariation!.last}%",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Container(),
                Positioned(
                  bottom: 12,
                  left: 10,
                  child: Visibility(
                    visible: listProducts![index].vendor!.name!.isNotEmpty,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          child: ImageIcon(
                            AssetImage(
                                'assets/images/home/fluent_store-microsoft-16-filled.png'),
                            size: 14,
                            color: accentColor,
                          ),
                        ),
                        Text(
                          "${listProducts![index].vendor!.name}",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  buildPriceVariation(index, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        listProducts![index].variationRegPrices!.isNotEmpty
            ? Visibility(
                visible: listProducts![index].isVariationDiscount!,
                child: Text(
                  listProducts![index].variationRegPrices!.first ==
                          listProducts![index].variationRegPrices!.last
                      ? '${stringToCurrency(listProducts![index].variationRegPrices!.first!, context)}'
                      : '${stringToCurrency(listProducts![index].variationRegPrices!.first!, context)} - ${stringToCurrency(listProducts![index].variationRegPrices!.last!, context)}',
                  style: TextStyle(
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[400],
                  ),
                ),
              )
            : Container(),
        Container(
          child: TextStyles(
            value: listProducts![index].variationPrices!.isEmpty
                ? listProducts![index].formattedPrice
                : listProducts![index].variationPrices!.first ==
                        listProducts![index].variationPrices!.last
                    ? '${stringToCurrency(listProducts![index].variationPrices!.first!, context)}'
                    : '${stringToCurrency(listProducts![index].variationPrices!.first!, context)} - ${stringToCurrency(listProducts![index].variationPrices!.last!, context)}',
            size: 12,
            weight: FontWeight.bold,
            color: tittleColor,
            isPrice: true,
          ),
        ),
      ],
    );
  }
}

class ShimmerStyleListScreen extends StatelessWidget {
  const ShimmerStyleListScreen({
    Key? key,
    this.isFlashSale,
  }) : super(key: key);
  final bool? isFlashSale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 267.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: imgList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              width: 130,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    offset: Offset(-1, 0),
                    color: Colors.grey.withOpacity(0.40),
                    blurRadius: 3)
              ]),
              margin: EdgeInsets.fromLTRB(4, 12, 4, 12),
              child: Shimmer.fromColors(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        child: GestureDetector(
                          onTap: null,
                          child: ClipRRect(
                              child: Container(
                            color: Colors.white,
                          )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              height: 10,
                              width: 60,
                              color: Colors.white,
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              height: 10,
                              width: 60,
                              color: Colors.white,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 80,
                                  height: 20,
                                  margin: EdgeInsets.only(right: 5),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Icon(
                                        MaterialCommunityIcons.star_outline,
                                        size: 16,
                                        color: Colors.orange,
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  "(0)",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 8),
                                    child: ImageIcon(
                                      AssetImage(
                                          'assets/images/home/fluent_store-microsoft-16-filled.png'),
                                      size: 14,
                                      color: accentColor,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    height: 10,
                                    width: 60,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!));
        },
      ),
    );
  }
}

//------------------------------------------------------------------------------ BEST STORE LIST
class StoreList extends StatelessWidget {
  const StoreList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<HomeProvider>(context);
    if (home.bestStoreHome.isEmpty) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(color: tittleColor.withOpacity(0.40), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(9))),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/home/Blink-Best-Store-88x350 .gif",
                  width: 130.w),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BestStoreScreen(),
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    AppLocalizations.of(context)!.translate("more")!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: tittleColor.withOpacity(0.80),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: home.bestStoreHome.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 130.w,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        offset: Offset(-1, 0),
                        color: Colors.grey.withOpacity(0.40),
                        blurRadius: 3)
                  ]),
                  margin: EdgeInsets.fromLTRB(4, 12, 4, 12),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: ClipRRect(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailStoreScreen(
                                        id: home.bestStoreHome[index].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 110,
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl: home.bestStoreHome[index].icon!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          customLoading(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: ImageIcon(
                                    AssetImage(
                                        'assets/images/home/fluent_store-microsoft-16-filled.png'),
                                    size: 18.w,
                                    color: accentColor,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: MarqueeWidget(
                                    direction: Axis.horizontal,
                                    child: Text(
                                      "${home.bestStoreHome[index].name}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          // margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingBarIndicator(
                                    rating: home
                                        .bestStoreHome[index].averageRating
                                        .toDouble(),
                                    itemSize: 18,
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
                                  /*Container(
                                    width: 80,
                                    height: 20,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Icon(
                                          FlutterIcons.star_outline_mco,
                                          size: 15,
                                          color: Colors.orange,
                                        );
                                      },
                                    ),
                                  ),*/
                                  /*Text(
                                    "(${home.bestStoreHome[index].ratingCount})",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

//------------------------------------------------------------------------------ SHIMMER BEST STORE LIST
class ShimmerStoreList extends StatelessWidget {
  const ShimmerStoreList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(color: tittleColor.withOpacity(0.40), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(9))),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/home/Blink-Best-Store-88x350 .gif",
                  width: 130),
              GestureDetector(
                onTap: null,
                child: Container(
                  child: Text(
                    "More",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: tittleColor.withOpacity(0.80)),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: imgList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 130,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        offset: Offset(-1, 0),
                        color: Colors.grey.withOpacity(0.40),
                        blurRadius: 3)
                  ]),
                  margin: EdgeInsets.fromLTRB(4, 12, 4, 12),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: null,
                          child: Container(
                            height: 120,
                            child: ClipRRect(
                                child: Container(
                              color: Colors.white,
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 8),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                width: 20,
                                height: 10,
                                color: Colors.white,
                              ),
                              Container(
                                width: 50,
                                height: 10,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 20,
                                    margin: EdgeInsets.only(right: 2),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Icon(
                                          MaterialCommunityIcons.star_outline,
                                          size: 15,
                                          color: Colors.orange,
                                        );
                                      },
                                    ),
                                  ),
                                  Text(
                                    "(0)",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

//------------------------------------------------------------------------------ IMAGE GRID STYLE
class ImageGridStyle extends StatelessWidget {
  final List<MiniBannerModel>? banners;
  const ImageGridStyle({Key? key, this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: banners!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2 / 1,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (banners![index].linkTo == 'URL') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            title: banners![index].titleSlider,
                            url: banners![index].name,
                          ),
                        ),
                      );
                    }
                    if (banners![index].linkTo == 'category') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubCategoriesScreen(
                            id: banners![index].product.toString(),
                            title: banners![index].name,
                            nonSub: true,
                          ),
                        ),
                      );
                    }
                    if (banners![index].linkTo == 'blog') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailBlog(
                            id: banners![index].product,
                          ),
                        ),
                      );
                    }
                    if (banners![index].linkTo == 'product') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProductScreen(
                            isFlashSale: false,
                            id: banners![index].product.toString(),
                          ),
                        ),
                      );
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: CachedNetworkImage(
                      imageUrl: banners![index].image!,
                      placeholder: (context, url) => customLoading(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
