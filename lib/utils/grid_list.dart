part of 'shared.dart';

class GridListProduct extends StatefulWidget {
  final bool? isManageProduct, discount, favorite, isWishlist;
  final List<ProductModel>? listProduct;
  final Future Function()? refresh;

  const GridListProduct(
      {Key? key,
      this.isManageProduct,
      this.discount,
      this.favorite,
      this.isWishlist,
      this.listProduct,
      this.refresh})
      : super(key: key);

  @override
  _GridListProductState createState() => _GridListProductState();
}

class _GridListProductState extends State<GridListProduct> {
  void _detailModalBottomSheet(context, String id) {
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
                        padding: EdgeInsets.only(top: 8, left: 20, right: 15),
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
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      child: TextStyles(
                                        value: AppLocalizations.of(context)!
                                            .translate("sure_delete_wish"),
                                        size: 16,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      child: TextStyles(
                                        value: AppLocalizations.of(context)!
                                            .translate("sure_title_wish"),
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MaterialButton(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          color: accentColor,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate("no")!,
                                              style: TextStyle(
                                                  color: primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(width: 10),
                                      Expanded(
                                        flex: 1,
                                        child: MaterialButton(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: tittleColor, width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          color: Colors.white,
                                          onPressed: () {
                                            UIBlock.block(context);
                                            Provider.of<WishlistProvider>(
                                                    context,
                                                    listen: false)
                                                .removeWhistList(id: id)
                                                .then((value) {
                                              print(value);
                                              if (value == false) {
                                                print("berhasil");
                                                Provider.of<WishlistProvider>(
                                                        context,
                                                        listen: false)
                                                    .getProductWishlist()
                                                    .then((value) {
                                                  UIBlock.unblock(context);
                                                  Navigator.pop(context);
                                                });
                                              } else {
                                                UIBlock.unblock(context);
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate("yes")!,
                                              style: TextStyle(
                                                color: tittleColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
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

  void showAlertDeleteDialog(BuildContext context,
      {required ProductModel product}) {
    SimpleDialog alert = SimpleDialog(
      contentPadding: EdgeInsets.all(5.0),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.close),
            color: accentColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TextStyles(
                value:
                    AppLocalizations.of(context)!.translate("remove_product"),
                size: 16,
                weight: FontWeight.bold,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  child: TextStyles(
                    value: AppLocalizations.of(context)!
                        .translate("sure_title_wish"),
                    size: 14,
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 15, left: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: product.images![0].src!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => customLoading(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: MarqueeWidget(
                          direction: Axis.horizontal,
                          child: TextStyles(
                            value: product.productName,
                            size: 16,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        height: 40,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: TextStyles(
                          value: AppLocalizations.of(context)!.translate("no"),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(width: 8),
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: accentColor),
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 0,
                        height: 40,
                        onPressed: () async {
                          UIBlock.block(context);
                          await Provider.of<StoreProvider>(context,
                                  listen: false)
                              .removeProduct(context, product.id)
                              .then((value) {
                            UIBlock.unblock(context);
                            Navigator.pop(context);
                            if (value) widget.refresh!();
                          });
                        },
                        child: TextStyles(
                          value: AppLocalizations.of(context)!.translate("yes"),
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.listProduct!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: widget.isManageProduct! ? 0.50 : 0.55,
        crossAxisCount: 2,
        crossAxisSpacing: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailProductScreen(
                  id: widget.listProduct![index].id.toString(),
                  isFavorite: widget.listProduct![index].isWishList,
                  isFlashSale: false,
                  product: widget.listProduct![index],
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  offset: Offset(-1, 0),
                  color: Colors.grey.withOpacity(0.40),
                  blurRadius: 3)
            ]),
            margin: EdgeInsets.fromLTRB(4, 12, 4, 0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.listProduct![index].images![0].src!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => customLoading(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 5),
                            margin: EdgeInsets.only(bottom: 5),
                            child: MarqueeWidget(
                              direction: Axis.horizontal,
                              child: Text(
                                widget.listProduct![index].productName!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          widget.listProduct![index].discProduct == 0
                              ? Text(
                                  " ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[400],
                                  ),
                                )
                              : Visibility(
                                  visible:
                                      widget.listProduct![index].discProduct !=
                                          0,
                                  child: Text(
                                    widget.listProduct![index].formattedPrice!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                          /*SizedBox(
                            height: 2.h,
                          ),*/
                          widget.listProduct![index].type == 'simple' ||
                                  widget.listProduct![index].type == 'grouped'
                              ? Container(
                                  child: TextStyles(
                                    value: widget.listProduct![index]
                                                .discProduct !=
                                            0
                                        ? widget.listProduct![index]
                                            .formattedSalePrice
                                        : widget
                                            .listProduct![index].formattedPrice,
                                    size: 14,
                                    weight: FontWeight.bold,
                                    color: tittleColor,
                                    isPrice: true,
                                  ),
                                )
                              : buildPriceVariation(index, context),
                          /*SizedBox(
                            height: 2.h,
                          ),*/
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingBarIndicator(
                                rating: double.parse(
                                    widget.listProduct![index].avgRating!),
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
                                "(${widget.listProduct![index].ratingCount})",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            visible: widget.isManageProduct! ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 8),
                                    child: Image.asset(
                                      'assets/images/home/fluent_store-microsoft-16-filled.png',
                                      width: 14,
                                    ),
                                  ),
                                  Text(
                                    "${widget.listProduct![index].vendor!.name}",
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
                    ),
                    Spacer(),
                    widget.isManageProduct == true
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            child: MaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.all(0),
                              elevation: 0,
                              color: accentColor,
                              onPressed: () async {
                                var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddProductScreen(
                                      product: widget.listProduct![index],
                                      isEdit: true,
                                    ),
                                  ),
                                );
                                print("Result : $result");
                                if (result == '200') widget.refresh!();
                              },
                              child: Container(
                                  child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("edit"),
                                color: Colors.white,
                                size: 12,
                              )),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Visibility(
                  visible: widget.listProduct![index].discProduct != 0,
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
                        "${widget.listProduct![index].discProduct!.toInt()}%",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                widget.listProduct![index].isVariationDiscount!
                    ? Container(
                        height: 25,
                        width: widget
                                    .listProduct![index].discVariation!.first ==
                                widget.listProduct![index].discVariation!.last
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
                            widget.listProduct![index].discVariation!.first ==
                                    widget
                                        .listProduct![index].discVariation!.last
                                ? "${widget.listProduct![index].discVariation!.first}%"
                                : "${widget.listProduct![index].discVariation!.first}-${widget.listProduct![index].discVariation!.last}%",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Container(),
                Visibility(
                  visible: widget.isManageProduct!,
                  child: Positioned(
                      right: 6,
                      top: 6,
                      child: InkWell(
                        onTap: () async {
                          // await Provider.of<StoreProvider>(context,
                          //         listen: false)
                          //     .removeProduct(context, listProduct[index].id)
                          //     .then((value) {
                          //   if (value) refresh();
                          // });
                          showAlertDeleteDialog(context,
                              product: widget.listProduct![index]);
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.80),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: darkColor.withOpacity(0.50))
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              MaterialCommunityIcons.trash_can_outline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )),
                ),
                Visibility(
                  visible: widget.favorite == null ? false : widget.favorite!,
                  child: Positioned(
                      right: 6,
                      top: 6,
                      child: InkWell(
                        onTap: () {
                          _detailModalBottomSheet(
                            context,
                            widget.listProduct![index].id.toString(),
                          );
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.80),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: darkColor.withOpacity(0.50),
                              )
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              widget.listProduct![index].isWishList == true
                                  ? MaterialIcons.favorite
                                  : MaterialIcons.favorite_border,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )),
                ),
                Visibility(
                  visible:
                      widget.listProduct![index].vendor!.name!.isNotEmpty &&
                          widget.isManageProduct != true,
                  child: Positioned(
                    bottom: 10,
                    left: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: Image.asset(
                              'assets/images/home/fluent_store-microsoft-16-filled.png',
                              width: 14,
                            ),
                          ),
                          Text(
                            "${widget.listProduct![index].vendor!.name}",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 10,
                //   left: 10,
                //   child:
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  buildPriceVariation(index, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.listProduct![index].variationRegPrices!.isNotEmpty
            ? Visibility(
                visible: widget.listProduct![index].isVariationDiscount! &&
                    widget.listProduct![index].variationRegPrices!.isNotEmpty,
                child: Text(
                  widget.listProduct![index].variationRegPrices!.first ==
                          widget.listProduct![index].variationRegPrices!.last
                      ? '${stringToCurrency(widget.listProduct![index].variationRegPrices!.first!, context)}'
                      : '${stringToCurrency(widget.listProduct![index].variationRegPrices!.first!, context)} - ${stringToCurrency(widget.listProduct![index].variationRegPrices!.last!, context)}',
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
            value: widget.listProduct![index].variationPrices!.isEmpty
                ? widget.listProduct![index].formattedPrice
                : widget.listProduct![index].variationPrices!.first ==
                        widget.listProduct![index].variationPrices!.last
                    ? '${stringToCurrency(widget.listProduct![index].variationPrices!.first!, context)}'
                    : '${stringToCurrency(widget.listProduct![index].variationPrices!.first!, context)} - ${stringToCurrency(widget.listProduct![index].variationPrices!.last!, context)}',
            size: 14,
            weight: FontWeight.bold,
            color: tittleColor,
            isPrice: true,
          ),
        ),
      ],
    );
  }
}

class ShimmerGridListProduct extends StatelessWidget {
  const ShimmerGridListProduct(
      {Key? key, this.isManageProduct, this.discount, this.favorite})
      : super(key: key);

  final bool? isManageProduct, discount, favorite;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = isManageProduct! ? 360 : 320;
    final double itemWidth = size.width / 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: imgList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (itemWidth / itemHeight), crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: null,
          child: Container(
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
                      height: 140,
                      child: ClipRRect(
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            height: 15,
                            width: 55,
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            height: 15,
                            width: 40,
                            color: Colors.white,
                          ),
                          Row(
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
                              Text("(0)")
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  height: 15,
                                  width: 45,
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
                highlightColor: Colors.grey[100]!),
          ),
        );
      },
    );
  }
}
