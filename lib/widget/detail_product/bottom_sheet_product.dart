part of '../widget.dart';

class BottomSheetCart extends StatefulWidget {
  final ProductModel? product;
  final String? type;
  final Function()? loadCount;
  BottomSheetCart({Key? key, this.product, this.type, this.loadCount})
      : super(key: key);

  @override
  _BottomSheetCartState createState() => _BottomSheetCartState();
}

class _BottomSheetCartState extends State<BottomSheetCart> {
  int index = 0;
  int indexColor = 0;
  int counter = 1;

  List<ProductAttributeModel> attributes = [];
  List<ProductVariation> variation = [];

  bool load = false;
  bool isAvailable = false;
  bool isOutStock = false;

  double? variationPrice = 0;
  String? variationPriceHtml;
  double variationSalePrice = 0;

  String? variationName;

  int? variationStock = 0;

  /*get variant id, if product have variant*/
  checkProductVariant(ProductModel productModel) async {
    setState(() {
      load = true;
    });
    var tempVar = [];
    print(variation);
    variation.forEach((element) {
      setState(() {
        tempVar.add(element.value);
      });
    });
    variationName = tempVar.join();
    print(variationName);
    final product = Provider.of<ProductProvider>(context, listen: false);
    product
        .checkVariation(productId: productModel.id, list: variation)
        .then((value) {
      print('$value how');
      // printLog(value.toString(), name: "Response Variation");
      if (value!['variation_id'] != 0) {
        setState(() {
          productModel.variantId = value['variation_id'];
          load = false;
        });
        productModel.availableVariations!.forEach((element) {
          if (element['variation_id'] == value['variation_id']) {
            setState(() {
              print(element['formated_price']);
              variationPrice = element['display_price'].toDouble();
              printLog('$variationPrice', name: 'Variation Price');
              variationPriceHtml = element['display_regular_price'] != null &&
                      element['formated_sales_price'] != null
                  ? element['formated_sales_price']
                  : element['formated_price'];
              widget.product!.cartQuantity = 1;
              print(element['is_in_stock']);
              print(element['max_qty']);
              if (element['is_in_stock']) {
                print("if");
                if (element['max_qty'] == null || element['max_qty'] == '') {
                  variationStock = 999;
                  isAvailable = true;
                  isOutStock = false;
                } else {
                  variationStock = element['max_qty'];
                  isAvailable = true;
                  isOutStock = false;
                }
              } else if (!element['is_in_stock']) {
                print("else if");
                variationStock = 0;
                isAvailable = true;
                isOutStock = true;
              } else {
                print("else");
                variationStock = element['max_qty'];
                isAvailable = true;
                isOutStock = false;
              }
            });
          }
        });
      } else {
        setState(() {
          variationPrice = 0;
          isAvailable = false;
          load = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.product!.cartQuantity = 1;
    initVariation();
  }

  /*init variation & check if variation true*/
  initVariation() {
    if (widget.product!.attributes!.isNotEmpty &&
        widget.product!.type == 'variable') {
      widget.product!.attributes!.forEach((element) {
        if (element.variation == true) {
          print("Variation True");
          setState(() {
            attributes.add(element);
            element.selectedVariant = element.options!.first;
            if (element.id != 0 && element.id != null) {
              var _value =
                  element.options!.first.toString().replaceAll('.', '-');
              variation.add(new ProductVariation(
                  id: element.id,
                  value: slugify(_value).replaceAll('--', '-'),
                  columnName: 'pa_${slugify(element.name!)}'));
            } else {
              variation.add(new ProductVariation(
                  id: element.id,
                  value: element.options!.first,
                  columnName: slugify(element.name!)));
            }
          });
        }
      });
      checkProductVariant(widget.product!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: attributes.isNotEmpty,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: attributes.length,
                    itemBuilder: (context, i) {
                      return buildVariations(i);
                    })),
            Container(
              height: 1,
              width: double.infinity,
              color: greyText,
              margin: EdgeInsets.only(bottom: 15),
            ),
            Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: load
                    ? Shimmer.fromColors(
                        child: Container(
                          height: 25.h,
                          color: Colors.white,
                        ),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!)
                    : !isAvailable
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('current_var_stock')!,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Quantity",
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 16.w,
                                        height: 16.h,
                                        child: MaterialButton(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.all(0),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: widget.product!
                                                              .cartQuantity ==
                                                          1
                                                      ? greyText
                                                      : accentColor,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3))),
                                          color: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              if (widget
                                                      .product!.cartQuantity! >
                                                  1) {
                                                widget.product!.cartQuantity =
                                                    widget.product!
                                                            .cartQuantity! -
                                                        1;
                                              }
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              AntDesign.minus,
                                              color: widget.product!
                                                          .cartQuantity ==
                                                      1
                                                  ? greyText
                                                  : tittleColor,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text((widget.product!.cartQuantity)
                                          .toString()),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 16.w,
                                        height: 16.h,
                                        child: MaterialButton(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.all(0),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: widget.product!
                                                                  .productStock! >
                                                              widget.product!
                                                                  .cartQuantity! &&
                                                          !isOutStock
                                                      ? accentColor
                                                      : greyText,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3))),
                                          color: Colors.white,
                                          onPressed:
                                              widget.product!.productStock! <=
                                                          widget.product!
                                                              .cartQuantity! ||
                                                      isOutStock
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        widget.product!
                                                            .cartQuantity = widget
                                                                .product!
                                                                .cartQuantity! +
                                                            1;
                                                      });
                                                    },
                                          child: Container(
                                            child: Icon(
                                              AntDesign.plus,
                                              color: isOutStock
                                                  ? greyText
                                                  : tittleColor,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    stringToCurrency(variationPrice!, context),
                                    style: TextStyle(
                                        color: tittleColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Stock : $variationStock',
                                  )
                                ],
                              )
                            ],
                          )),
            Visibility(
              visible: widget.product!.productStock == null ||
                  widget.product!.productStock == 0,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('current_prod_stock')!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
        Visibility(
          visible: widget.type == 'add',
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                  )
                ],
              ),
              height: 45.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: 132.w,
                height: 30.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: !isAvailable || load || isOutStock
                            ? Colors.grey
                            : tittleColor, //Color of the border
                        //Style of the border
                      ),
                      alignment: Alignment.center,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5))),
                  onPressed: !isAvailable || load || isOutStock
                      ? null
                      : () async {
                          print(variationPriceHtml);
                          if (widget.product!.productStock != null &&
                              widget.product!.productStock != 0) {
                            setState(() {
                              widget.product!.selectedVariation = variation;
                              widget.product!.productPrice = variationPrice;
                              widget.product!.formattedPrice =
                                  convertHtmlUnescape(variationPriceHtml!);
                              widget.product!.variationName = variationName;
                            });
                            print(widget.product!.selectedVariation);
                            Navigator.pop(context);
                            await Provider.of<CartProvider>(context,
                                    listen: false)
                                .calculatePriceTotal(context, widget.product!)
                                .then((value) => widget.loadCount!());
                          } else {
                            Navigator.pop(context);
                            snackBar(context,
                                message: AppLocalizations.of(context)!
                                    .translate('prod_out_stock')!);
                          }
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 9.sp,
                        color: !isAvailable || load || isOutStock
                            ? Colors.grey
                            : tittleColor,
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate("add_cart")!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9.sp,
                            color: !isAvailable || load || isOutStock
                                ? Colors.grey
                                : tittleColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildVariations(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
          child: Text(
            attributes[index].name!,
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: attributes[index].options!.length,
              itemBuilder: (context, i) {
                return Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            if (attributes[index].id != 0) {
                              attributes[index].selectedVariant =
                                  attributes[index]
                                      .options![i]
                                      .toString()
                                      .toLowerCase();
                            } else {
                              attributes[index].selectedVariant =
                                  attributes[index].options![i];
                            }
                          });
                          print(
                              'Sel Var ' + attributes[index].selectedVariant!);
                          variation.forEach((element) {
                            if (element.id != 0) {
                              if (element.columnName ==
                                  'pa_${slugify(attributes[index].name!)}') {
                                print(attributes[index].options![i]);
                                setState(() {
                                  var _value = attributes[index]
                                      .options![i]
                                      .replaceAll('.', '-');
                                  element.value =
                                      slugify(_value).replaceAll('--', '-');
                                });
                              }
                            } else {
                              if (element.columnName ==
                                  slugify(attributes[index].name!)) {
                                setState(() {
                                  element.value = attributes[index].options![i];
                                });
                              }
                            }
                          });
                          checkProductVariant(widget.product!);
                        },
                        child: attributes[index].id == 0
                            ? sizeButton(
                                attributes[index].options![i], index, i)
                            : sizeButtonPA(
                                attributes[index].options![i], index, i)),
                    Container(
                      width: 10,
                    ),
                  ],
                );
              }),
        )
      ],
    );
  }

  Widget sizeButton(String variant, int groupVariant, int subVariant) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: widget.product!.attributes![groupVariant].selectedVariant ==
                    widget
                        .product!.attributes![groupVariant].options![subVariant]
                ? Colors.transparent
                : tittleColor),
        borderRadius: BorderRadius.circular(5),
        color: widget.product!.attributes![groupVariant].selectedVariant ==
                widget.product!.attributes![groupVariant].options![subVariant]
            ? tittleColor
            : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        variant,
        style: TextStyle(
            color: widget.product!.attributes![groupVariant].selectedVariant ==
                    widget
                        .product!.attributes![groupVariant].options![subVariant]
                ? Colors.white
                : tittleColor),
      ),
    );
  }

  Widget sizeButtonPA(String variant, int groupVariant, int subVariant) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: attributes[groupVariant].selectedVariant!.toLowerCase() ==
                    attributes[groupVariant]
                        .options![subVariant]
                        .toString()
                        .toLowerCase()
                ? Colors.transparent
                : tittleColor),
        borderRadius: BorderRadius.circular(5),
        color: attributes[groupVariant].selectedVariant!.toLowerCase() ==
                attributes[groupVariant]
                    .options![subVariant]
                    .toString()
                    .toLowerCase()
            ? tittleColor
            : Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        variant,
        style: TextStyle(
            color: attributes[groupVariant].selectedVariant!.toLowerCase() ==
                    attributes[groupVariant]
                        .options![subVariant]
                        .toString()
                        .toLowerCase()
                ? Colors.white
                : tittleColor),
      ),
    );
  }
}
