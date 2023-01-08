part of '../pages.dart';

class AddProductScreen extends StatefulWidget {
  final bool isEdit;
  final ProductModel? product;

  const AddProductScreen({Key? key, this.isEdit = false, this.product})
      : super(key: key);
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? productType = "simple";
  String? statusType = "instock";

  List<File> files = [];
  List<int>? categoriesId = [];

  TextEditingController productName = new TextEditingController();
  TextEditingController regPrice = new TextEditingController();
  // final regPrice =
  //     MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  TextEditingController salePrice = new TextEditingController();
  TextEditingController description = new TextEditingController();

  TextEditingController weight = new TextEditingController();
  TextEditingController length = new TextEditingController();
  TextEditingController width = new TextEditingController();
  TextEditingController height = new TextEditingController();
  TextEditingController productStock = new TextEditingController();

  //variant
  TextEditingController varRegPrice = new TextEditingController();
  TextEditingController varSalePrice = new TextEditingController();

  int? currentCategory, currentSubCategory;

  List<ProductImage> images = [];
  List<ProductImage> variantImages = [];
  List<ProductCategoryModel> selectedCategories = [];
  List<AttributeModel> listAttr = [];
  List<VariantModel> listVar = [];

  int totalImage = 0;

  bool? _isManageStock = false;

  AttributeProvider? attributeProvider;

  _getFromGallery(bool variant) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      this.setState(() {});
      File imageFile = File(pickedFile.path);

      if (variant == true) {
        uploadImageVariant(imageFile);
      } else {
        uploadImage(imageFile);
      }
    }
  }

  void _detailCategoriesBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              margin: EdgeInsets.only(
                bottom: 15,
              ),
              child: new Wrap(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 15, left: 20, right: 15),
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
                                margin: EdgeInsets.only(
                                  top: 15,
                                ),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("categories")!,
                                  size: 16,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Consumer<CategoryProvider>(
                                builder: (context, value, child) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.7),
                                    child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(15, 15, 15, 5),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: value.listCategories.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var result =
                                              value.listCategories[index];
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          value
                                                              .changeStatusCategories(
                                                                  newValue:
                                                                      result
                                                                          .id);
                                                        },
                                                        child: Icon(result
                                                                .isSelected!
                                                            ? Icons.check_box
                                                            : Icons
                                                                .check_box_outline_blank),
                                                      ),
                                                    ),
                                                    TextStyles(
                                                        value: result.name)
                                                  ],
                                                ),
                                              ),
                                              result.subCategories == null
                                                  ? SizedBox()
                                                  : Container(
                                                      child: ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: result
                                                            .subCategories!
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var result2 = result
                                                                  .subCategories![
                                                              index];
                                                          return Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 20),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5),
                                                                  child: Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          value.changeStatusCategories(
                                                                              newValue: result2.id);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: 10),
                                                                          child: Icon(result2.isSelected!
                                                                              ? Icons.check_box
                                                                              : Icons.check_box_outline_blank),
                                                                        ),
                                                                      ),
                                                                      TextStyles(
                                                                          value:
                                                                              result2.name)
                                                                    ],
                                                                  ),
                                                                ),
                                                                result2.subCategories ==
                                                                        null
                                                                    ? SizedBox()
                                                                    : Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20),
                                                                        child: ListView
                                                                            .builder(
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: result2
                                                                              .subCategories!
                                                                              .length,
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            var result3 =
                                                                                result2.subCategories![index];
                                                                            return Row(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    value.changeStatusCategories(newValue: result3.id);
                                                                                  },
                                                                                  child: Icon(result3.isSelected! ? Icons.check_box : Icons.check_box_outline_blank),
                                                                                ),
                                                                                TextStyles(value: result3.name)
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 8),
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            color: accentColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("submit")!,
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  uploadImage(File file) async {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    await Provider.of<StoreProvider>(context, listen: false)
        .uploadImgProduct(context,
            title: "${productName.text.replaceAll(' ', '-').toLowerCase()}.jpg",
            media: base64Image)
        .then((value) {
      setState(() {
        images.add(
            new ProductImage(id: value.id, image: value.image, imgFile: file));
      });
      print("image length upload : ${images.length.toString()}");
    });
  }

  uploadImageVariant(File file) async {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    await Provider.of<StoreProvider>(context, listen: false)
        .uploadImgProduct(context,
            title: "${productName.text.replaceAll(' ', '-').toLowerCase()}.jpg",
            media: base64Image)
        .then((value) {
      setState(() {
        variantImages.add(
            new ProductImage(id: value.id, image: value.image, imgFile: file));
      });
    });
  }

  addProduct() async {
    this.setState(() {});

    /*Add Categories Id*/
    categoriesId = [];
    var categories = Provider.of<CategoryProvider>(context, listen: false)
        .categoriesSelected;
    if (categories.isNotEmpty) {
      print(json.encode(categories));
      for (var item in categories) {
        categoriesId!.add(item.id!);
      }
    } else {
      return snackBar(context,
          message: AppLocalizations.of(context)!
              .translate("product_alert_categories")!);
    }
    if (_isManageStock! && productStock.text.isEmpty) {
      return snackBar(context, message: "Stock quantity shouldn't empty");
    }
    /*Check Required Form*/
    if (productName.text.isNotEmpty &&
        regPrice.text != "0" &&
        regPrice.text.isNotEmpty &&
        images.isNotEmpty &&
        description.text.isNotEmpty) {
      print("Posting New Product");
      print("Image Length : ${images.length.toString()}");
      UIBlock.block(context);
      try {
        await Provider.of<StoreProvider>(context, listen: false)
            .inputProduct(context,
                title: productName.text,
                status: 'Publish',
                productType: 'simple',
                categories: categoriesId,
                content: description.text,
                salePrice: salePrice.text,
                regularPrice: regPrice.text,
                images: images,
                length: length.text.isNotEmpty ? int.parse(length.text) : null,
                width: width.text.isNotEmpty ? int.parse(width.text) : null,
                height: height.text.isNotEmpty ? int.parse(height.text) : null,
                weight:
                    weight.text.isNotEmpty ? double.parse(weight.text) : null,
                manageStock: _isManageStock!,
                stockQuantity:
                    _isManageStock! ? int.parse(productStock.text) : null,
                stockStatus: statusType)
            .then((value) async {
          UIBlock.unblock(context);
        });
      } catch (e) {
        printLog(e.toString());
        UIBlock.unblock(context);
        return snackBar(context,
            message:
                AppLocalizations.of(context)!.translate("error_occurred")!);
      }
    } else {
      return snackBar(context,
          message:
              AppLocalizations.of(context)!.translate("product_alert_field")!);
    }
  }

  addProductVariant() async {
    this.setState(() {});

    /*Add Categories Id*/
    categoriesId = [];
    var categories = Provider.of<CategoryProvider>(context, listen: false)
        .categoriesSelected;
    if (categories.isNotEmpty) {
      print(json.encode(categories));
      for (var item in categories) {
        categoriesId!.add(item.id!);
      }
    } else {
      return snackBar(context,
          message: AppLocalizations.of(context)!
              .translate("product_alert_categories")!);
    }
    if (_isManageStock! && productStock.text.isEmpty) {
      return snackBar(context, message: "Stock quantity shouldn't empty");
    }
    /*Check Required Form*/
    if (productName.text.isNotEmpty &&
        images.isNotEmpty &&
        description.text.isNotEmpty &&
        attributeProvider!.listVariant.length > 0) {
      print("Posting New Product");
      print("Image Length : ${images.length.toString()}");

      attributeProvider!.getProdAttribute();
      UIBlock.block(context);
      try {
        await Provider.of<StoreProvider>(context, listen: false)
            .inputProductVariant(
          context,
          title: productName.text,
          status: 'Publish',
          productType: 'variable',
          categories: categoriesId,
          content: description.text,
          productAttribute: attributeProvider!.listProductAttribute,
          variationData: attributeProvider!.listVariant,
          images: images,
        )
            .then((value) async {
          attributeProvider!.clearList();
          UIBlock.unblock(context);
        });
      } catch (e) {
        printLog(e.toString());
        UIBlock.unblock(context);
        return snackBar(context,
            message:
                AppLocalizations.of(context)!.translate("error_occurred")!);
      }
    } else {
      return snackBar(context,
          message:
              AppLocalizations.of(context)!.translate("product_alert_field")!);
    }
  }

  updateProduct() async {
    this.setState(() {});

    categoriesId = [];
    var categories = Provider.of<CategoryProvider>(context, listen: false)
        .categoriesSelected;
    if (categories.isNotEmpty) {
      print(json.encode(categories));
      for (var item in categories) {
        categoriesId!.add(item.id!);
      }
    } else {
      return snackBar(context,
          message: AppLocalizations.of(context)!
              .translate("product_alert_categories")!);
    }

    /*Check Required Form*/
    if (productName.text.isNotEmpty &&
        regPrice.text != "0" &&
        regPrice.text.isNotEmpty &&
        images.isNotEmpty &&
        description.text.isNotEmpty) {
      try {
        print("Updating Product");
        print("images length update : ${images.length.toString()}");
        UIBlock.block(context);
        await Provider.of<StoreProvider>(context, listen: false)
            .inputProduct(context,
                title: productName.text,
                status: 'Publish',
                productType: 'simple',
                categories: categoriesId,
                content: description.text,
                salePrice: salePrice.text,
                regularPrice: regPrice.text,
                images: images,
                length: length.text.isNotEmpty ? int.parse(length.text) : null,
                width: width.text.isNotEmpty ? int.parse(width.text) : null,
                height: height.text.isNotEmpty ? int.parse(height.text) : null,
                weight:
                    weight.text.isNotEmpty ? double.parse(weight.text) : null,
                id: widget.product!.id,
                manageStock: _isManageStock!,
                stockQuantity:
                    _isManageStock! ? int.parse(productStock.text) : null,
                stockStatus: statusType)
            .then((value) async {
          UIBlock.unblock(context);
        });
      } catch (e) {
        UIBlock.unblock(context);
        return snackBar(context,
            message:
                AppLocalizations.of(context)!.translate("error_occurred")!);
      }
    } else {
      return snackBar(context,
          message:
              AppLocalizations.of(context)!.translate("product_alert_field")!);
    }
  }

  updateProductVariant() async {
    this.setState(() {});

    categoriesId = [];
    var categories = Provider.of<CategoryProvider>(context, listen: false)
        .categoriesSelected;
    if (categories.isNotEmpty) {
      print(json.encode(categories));
      for (var item in categories) {
        categoriesId!.add(item.id!);
      }
    } else {
      return snackBar(context,
          message: AppLocalizations.of(context)!
              .translate("product_alert_categories")!);
    }

    /*Check Required Form*/
    if (productName.text.isNotEmpty &&
        images.isNotEmpty &&
        description.text.isNotEmpty) {
      try {
        print("Updating Product");
        print("images length update : ${images.length.toString()}");
        UIBlock.block(context);
        await Provider.of<StoreProvider>(context, listen: false)
            .inputProductVariant(
          context,
          id: widget.product!.id,
          title: productName.text,
          status: 'Publish',
          productType: 'variable',
          categories: categoriesId,
          content: description.text,
          productAttribute: attributeProvider!.listProductAttribute,
          variationData: attributeProvider!.listVariant,
          images: images,
        )
            .then((value) async {
          attributeProvider!.clearList();
          UIBlock.unblock(context);
        });
      } catch (e) {
        UIBlock.unblock(context);
        return snackBar(context,
            message:
                AppLocalizations.of(context)!.translate("error_occurred")!);
      }
    } else {
      return snackBar(context,
          message:
              AppLocalizations.of(context)!.translate("product_alert_field")!);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadNewCategories();
      context.read<AttributeProvider>().fetchAttribute().then((value) {
        checkVariationEdit();
      });
    });

    attributeProvider = Provider.of<AttributeProvider>(context, listen: false);
    if (widget.isEdit) {
      print("RegPrice : ${widget.product!.productRegPrice}");
      print("SalePrice : ${widget.product!.productSalePrice}");
      productName.text = widget.product!.productName!;
      productType = widget.product!.type;

      //end of load attribute variant
      regPrice.text = widget.product!.productRegPrice.toString();
      salePrice.text = widget.product!.productSalePrice.toString();
      description.text = widget.product!.productDescription!;
      weight.text = widget.product!.dimensions!.weight!;
      length.text = widget.product!.dimensions!.length!;
      width.text = widget.product!.dimensions!.width!;
      height.text = widget.product!.dimensions!.height!;
      statusType = widget.product!.stockStatus;
      if (statusType == 'instock' &&
          widget.product!.productStockManage == null) {
        _isManageStock = false;
      } else if (statusType == 'outofstock') {
        _isManageStock = false;
      } else if (widget.product!.productStockManage != null) {
        _isManageStock = true;
        productStock.text = widget.product!.productStock!.toString();
      }

      loadImage();
      print("image length inistate: ${images.length.toString()}");
      // loadCategories();
    }

    print("temp : ${tempWeight.length}");
  }

  checkVariationEdit() {
    if (widget.isEdit) {
      //load attribute variant
      for (int i = 0; i < widget.product!.attributes!.length; i++) {
        String id = widget.product!.attributes![i].id.toString();
        String name = widget.product!.attributes![i].name!;
        AttributeTermModel term;
        List<AttributeTermModel> listTerm = [];
        for (int j = 0;
            j < widget.product!.attributes![i].options!.length;
            j++) {
          for (int k = 0; k < attributeProvider!.listAttribute.length; k++) {
            for (int l = 0;
                l < attributeProvider!.listAttribute[k].term!.length;
                l++) {
              if (widget.product!.attributes![i].options![j] ==
                  attributeProvider!.listAttribute[k].term![l].name) {
                term = attributeProvider!.listAttribute[k].term![l];
                printLog("term name : ${json.encode(term)}");
                term.selected = true;
                listTerm.add(term);
                //printLog("list attribute length : ${json.encode(listTerm)}");
              }
            }
          }
        }
        listAttr.add(new AttributeModel(
            id: id, name: name, label: name.toLowerCase(), term: listTerm));
      }
      //printLog("listAttr : ${json.encode(listAttr)}");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<AttributeProvider>()
            .getListAttrForUpdate(listAttr: listAttr);
      });

      for (int i = 0; i < widget.product!.availableVariations!.length; i++) {
        String? height, length, width, weight;
        String? regularPrice,
            salePrice,
            statusStock,
            manageStock,
            stock,
            productId;
        VariationAttributesModel varAttr;
        List<VariationAttributesModel>? listVarAttr = [];

        height =
            widget.product!.availableVariations![i]["dimensions"]["height"];
        length =
            widget.product!.availableVariations![i]["dimensions"]["length"];
        width = widget.product!.availableVariations![i]["dimensions"]["width"];
        weight = widget.product!.availableVariations![i]["weight"];
        productId =
            widget.product!.availableVariations![i]["variation_id"].toString();
        regularPrice = widget
            .product!.availableVariations![i]["display_regular_price"]
            .toString();
        salePrice = "0";
        if (widget.product!.availableVariations![i]["display_regular_price"] !=
            widget.product!.availableVariations![i]["display_price"]) {
          salePrice = widget.product!.availableVariations![i]["display_price"]
              .toString();
        }
        statusStock = widget.product!.availableVariations![i]["is_in_stock"]
            ? "instock"
            : "outofstock";
        if (!widget.product!.availableVariations![i]["is_in_stock"]) {
          manageStock = "no";
        } else if (widget.product!.availableVariations![i]["is_in_stock"] &&
            widget.product!.availableVariations![i]["max_qty"] == "") {
          manageStock = "no";
        } else if (widget.product!.availableVariations![i]["is_in_stock"] &&
            widget.product!.availableVariations![i]["max_qty"] != "") {
          manageStock = "yes";
          stock = widget.product!.availableVariations![i]["max_qty"].toString();
        }

        String? attributeName, option, tempAttributeName;
        int ctr = widget.product!.availableVariations![i]["option"].length;
        List<String> temp = [];

        for (int j = 0; j < ctr; j++) {
          attributeName =
              widget.product!.availableVariations![i]["option"][0]["key"];
          temp = attributeName!.split("_");
          tempAttributeName = temp[2];
          option = widget.product!.availableVariations![i]["option"][0]
                      ["value"] ==
                  ""
              ? "All"
              : widget.product!.availableVariations![i]["option"][0]["value"];
          varAttr = new VariationAttributesModel(
              attributeName: tempAttributeName, option: option!);
          listVarAttr.add(varAttr);
        }

        listVar.add(new VariantModel(
            variableProductId: productId,
            height: height,
            length: length,
            varManageStock: manageStock,
            varRegularPrice: regularPrice,
            varSalePrice: salePrice,
            varStock: stock,
            varStockStatus: statusStock,
            weight: weight,
            width: width,
            listVariationAttr: listVarAttr));
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<AttributeProvider>()
            .getListVariantForUpdate(listVar: listVar);
      });
    }
  }

  loadImage() {
    widget.product!.images!.forEach((element) {
      setState(() {
        images.add(new ProductImage(id: element.id, image: element.src));
      });
    });
  }

  loadNewCategories() async {
    Provider.of<CategoryProvider>(context, listen: false)
        .fetchNewProductCategories(
            isEdit: widget.isEdit ? true : false,
            product: widget.isEdit ? widget.product : null)
        .then((value) {
      value.forEach((element) {});
    });
  }

  loadCategories() {
    final categories =
        Provider.of<CategoryProvider>(context, listen: false).productCategories;
    categories.forEach((element) {
      int index =
          widget.product!.categories!.indexWhere((cat) => cat.id == element.id);
      if (index != -1) selectedCategories.add(element);
    });
  }

  String attributes = '';
  String priceMin = '';
  String priceMax = '';
  String price = '';
  String weightMin = '';
  String weightMax = '';
  String weightString = '';
  List<String> tempLabel = [];
  List<String> tempPrice = [];
  List<String> tempWeight = [];
  bool cekList = true;
  htmleditor.HtmlEditorController controller =
      htmleditor.HtmlEditorController();

  getDataVariation() {
    tempLabel.clear();
    tempPrice.clear();
    //Start Attributes
    for (int i = 0; i < attributeProvider!.listAttribute.length; i++) {
      if (attributeProvider!.listAttribute[i].selected == true) {
        tempLabel.add(attributeProvider!.listAttribute[i].label!);
        attributes = tempLabel.join(", ");
      }
    }
    //END attributes
    //Start Price and Weight
    if (attributeProvider!.listVariant.length > 0) {
      for (int i = 0; i < attributeProvider!.listVariant.length; i++) {
        if (attributeProvider!.listVariant[i].deleteProductVariant == null) {
          if (attributeProvider!.listVariant[i].varSalePrice != null &&
              attributeProvider!.listVariant[i].varSalePrice != "0.00" &&
              attributeProvider!.listVariant[i].varSalePrice != "0") {
            tempPrice.add(attributeProvider!.listVariant[i].varSalePrice!);
          } else {
            tempPrice.add(attributeProvider!.listVariant[i].varRegularPrice!);
          }
          tempWeight.add(attributeProvider!.listVariant[i].weight!);
        } else if (attributeProvider!.listVariant.length == 1 &&
            attributeProvider!.listVariant[i].deleteProductVariant == "yes") {
          cekList = false;
        }
      }
    }
    if (tempPrice.length > 0 && tempWeight.length > 0) {
      tempWeight.sort();
      tempPrice.sort();
      weightMin = tempWeight.first;
      weightMax = tempWeight.last;
      priceMin = stringToCurrency(double.parse(tempPrice.first), context);
      priceMax = stringToCurrency(double.parse(tempPrice.last), context);
    }

    if (tempPrice.length == 1) {
      price = priceMin;
    } else if (priceMin == priceMax) {
      price = priceMin;
    } else {
      price = "${priceMin.toString()} - ${priceMax.toString()}";
    }
    if (tempWeight.length == 1) {
      weightString = weightMin + " kg";
    } else if (weightMin == weightMax) {
      weightString = weightMin + " kg";
    } else {
      weightString = "${weightMin.toString()} - ${weightMax.toString()} kg";
    }
    //END price and Weight
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    final categories =
        Provider.of<CategoryProvider>(context, listen: false).productCategories;
    return Scaffold(
      backgroundColor: Colors.white,
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
          widget.isEdit
              ? AppLocalizations.of(context)!.translate("update_product")!
              : AppLocalizations.of(context)!.translate("add_new_product")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<CategoryProvider>(builder: (context, values, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyles(
                        value: AppLocalizations.of(context)!
                            .translate("product_type"),
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 14),
                        decoration: BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            border: Border.all(color: Colors.white)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            onChanged: (dynamic value) {
                              setState(() {
                                value = value;
                                productType = value;
                              });
                            },
                            dropdownColor: Colors.white,
                            icon: Container(
                                child: Icon(Ionicons.ios_arrow_down, size: 18)),
                            value: productType,
                            items: <DropdownMenuItem<String>>[
                              DropdownMenuItem(
                                child: new Text('Simple'),
                                value: "simple",
                              ),
                              DropdownMenuItem(
                                child: new Text('Variable'),
                                value: "variable",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
              // productType == "variable"
              //     ? Container(
              //         margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             TextStyles(
              //               value: AppLocalizations.of(context)!
              //                   .translate("variant"),
              //               size: 14,
              //               weight: FontWeight.bold,
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 _detailVariantBottomSheet(context);
              //               },
              //               child: Container(
              //                 child: Icon(
              //                   MaterialCommunityIcons.plus_circle,
              //                   color: tittleColor,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : Container(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextStyles(
                      value:
                          "*${AppLocalizations.of(context)!.translate("product_name")}",
                      size: 14,
                      weight: FontWeight.bold,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: double.infinity,
                      child: GreyText(
                        hintText: AppLocalizations.of(context)!
                            .translate("product_name"),
                        controllerTxt: productName,
                      ),
                    ),
                  ],
                ),
              ),
              productType == "simple"
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextStyles(
                            value:
                                "*${AppLocalizations.of(context)!.translate("regular_price")}",
                            size: 14,
                            weight: FontWeight.bold,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: PriceForm(
                              controllerTxt: regPrice,
                              price: regPrice.text,
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.only(bottom: 15),
                          //   child: Theme(
                          //     data: Theme.of(context).copyWith(
                          //       textSelectionTheme:
                          //           TextSelectionThemeData(cursorColor: accentColor),
                          //       hintColor: Colors.transparent,
                          //     ),
                          //     child: TextFormField(
                          //       onChanged: (string) {
                          //         string =
                          //             '${_formatNumber(string.replaceAll(',', ''))}';
                          //         regPrice.value = TextEditingValue(
                          //           text: string,
                          //           selection: TextSelection.collapsed(
                          //               offset: string.length),
                          //         );
                          //       },
                          //       controller: regPrice,
                          //       style: TextStyle(color: Colors.black),
                          //       decoration: InputDecoration(
                          //           prefixText: _currency,
                          //           contentPadding: EdgeInsets.only(left: 20),
                          //           focusedBorder: border,
                          //           border: border,
                          //           hintStyle: TextStyle(color: Colors.black26),
                          //           labelStyle: TextStyle(
                          //               fontFamily: 'Brandon', color: Colors.white),
                          //           filled: true,
                          //           fillColor: Color(0xFFFAFAFA),
                          //           hintText: "00.00"),
                          //       keyboardType: TextInputType.number,
                          //       validator: (value) {
                          //         if (value == null || value.isEmpty) {
                          //           return 'Maaf, mohon untuk mengisi form bank name';
                          //         }
                          //         return null;
                          //       },
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  : Container(),
              productType == "simple"
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyles(
                              value: AppLocalizations.of(context)!
                                  .translate("sale_price"),
                              size: 14,
                              weight: FontWeight.bold,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: double.infinity,
                              child: PriceForm(
                                controllerTxt: salePrice,
                                price: salePrice.text,
                              ),
                            ),
                          ]),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyles(
                        value:
                            "*${AppLocalizations.of(context)!.translate("image_gallery")}",
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0; i < images.length; i++)
                                  Container(
                                    width: 90,
                                    height: 90,
                                    margin: EdgeInsets.only(right: 2),
                                    decoration: BoxDecoration(
                                      // color: Colors.blue,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        images[i].imgFile != null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.file(
                                                    images[i].imgFile!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.network(
                                                    images[i].image!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                images.removeAt(i);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: accentColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(40),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.cancel,
                                                color: primaryColor,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: store.loadImage
                                      ? CircularProgressIndicator()
                                      : InkWell(
                                          onTap: () async {
                                            _getFromGallery(false);
                                          },
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFAFAFA),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: accentColor,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              Divider(),
              productType == "simple"
                  ? Container(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isManageStock,
                            onChanged: (val) {
                              setState(() {
                                _isManageStock = !_isManageStock!;
                              });
                            },
                            activeColor: accentColor,
                          ),
                          TextStyles(
                            value: AppLocalizations.of(context)!
                                .translate("manage_stock")!,
                            size: 14,
                            weight: FontWeight.bold,
                          )
                        ],
                      ),
                    )
                  : Container(),
              productType == "simple"
                  ? Visibility(
                      visible: !_isManageStock!,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("stock_status"),
                                size: 14,
                                weight: FontWeight.bold,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 14),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFAFAFA),
                                    border: Border.all(color: Colors.white)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        value = value;
                                        statusType = value;
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                    icon: Container(
                                        child: Icon(Ionicons.ios_arrow_down,
                                            size: 18)),
                                    value: statusType,
                                    items: <DropdownMenuItem<String>>[
                                      DropdownMenuItem(
                                        child: new Text(
                                            AppLocalizations.of(context)!
                                                .translate("in_stock")!),
                                        value: "instock",
                                      ),
                                      DropdownMenuItem(
                                        child: new Text(
                                            AppLocalizations.of(context)!
                                                .translate("out_stock")!),
                                        value: "outofstock",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    )
                  : Container(),
              Visibility(
                visible: _isManageStock!,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyles(
                        value:
                            "*${AppLocalizations.of(context)!.translate("stock")}",
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        child: GreyText(
                            hintText: '0',
                            controllerTxt: productStock,
                            isNumber: true),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyles(
                        value:
                            "*${AppLocalizations.of(context)!.translate("category")}",
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 14),
                          decoration: BoxDecoration(
                              color: Color(0xFFFAFAFA),
                              border: Border.all(color: Colors.white)),
                          child: InkWell(
                            onTap: () {
                              // _showMultiSelect(context);
                              if (values.loading == false) {
                                _detailCategoriesBottomSheet(context);
                              }
                            },
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                onChanged: null,
                                hint: Text(values.loading
                                    ? AppLocalizations.of(context)!
                                        .translate("please_wait")!
                                    : AppLocalizations.of(context)!
                                        .translate("choose_cat")!),
                                dropdownColor: Colors.white,
                                icon: Container(
                                    child: Icon(Ionicons.ios_arrow_down,
                                        size: 18)),
                                value: currentCategory,
                                items: <DropdownMenuItem<int>>[
                                  for (ProductCategoryModel model in categories)
                                    new DropdownMenuItem(
                                      child: new Text(model.name!),
                                      value: model.id,
                                    ),
                                ],
                              ),
                            ),
                          )),
                      MultiSelectChipDisplay(
                        items: selectedCategories
                            .map((e) => MultiSelectItem(e, e.name!))
                            .toList(),
                        onTap: (dynamic value) {
                          setState(() {
                            selectedCategories.remove(value);
                          });
                        },
                      ),
                    ]),
              ),
              Consumer<CategoryProvider>(builder: (context, value, child) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Wrap(
                    children: [
                      for (var item in value.categoriesSelected)
                        chip(item.name!, accentColor),
                    ],
                  ),
                );
              }),
              /*Visibility(
                  visible: false,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextStyles(
                            value: 'Sub Category',
                            size: 14,
                            weight: FontWeight.bold,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 14),
                            decoration: BoxDecoration(
                                color: Color(0xFFFAFAFA),
                                border: Border.all(color: Colors.white)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    currentSubCategory = value;
                                    selectedCategories = currentSubCategory;
                                    categoriesId.clear();
                                    categoriesId.add(value);
                                  });
                                  print(selectedCategories);
                                },
                                dropdownColor: Colors.white,
                                icon: Container(
                                    child: Icon(FlutterIcons.ios_arrow_down_ion,
                                        size: 18)),
                                value: currentSubCategory,
                                hint: Text('Choose Sub Category'),
                                items: <DropdownMenuItem<int>>[
                                  for (ProductCategoryModel model
                                      in subCategories)
                                    new DropdownMenuItem(
                                      child: new Text(model.name),
                                      value: model.id,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),*/
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyles(
                        value:
                            "*${AppLocalizations.of(context)!.translate("description")}",
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        //       child: htmleditor.HtmlEditor(
                        //         controller: controller,
                        //         htmlEditorOptions: htmleditor.HtmlEditorOptions(
                        //           hint: 'Your text here...',
                        //           shouldEnsureVisible: true,
                        //           //initialText: "<p>text content initial, if any</p>",
                        //         ),
                        //         htmlToolbarOptions: htmleditor.HtmlToolbarOptions(
                        //           toolbarPosition: htmleditor
                        //               .ToolbarPosition.aboveEditor, //by default
                        //           toolbarType: htmleditor
                        //               .ToolbarType.nativeScrollable, //by default
                        //           onButtonPressed: (htmleditor.ButtonType type,
                        //               bool? status, Function? updateStatus) {
                        //             return true;
                        //           },
                        //           onDropdownChanged: (htmleditor.DropdownType type,
                        //               dynamic changed,
                        //               Function(dynamic)? updateSelectedItem) {
                        //             return true;
                        //           },
                        //           mediaLinkInsertInterceptor:
                        //               (String url, htmleditor.InsertFileType type) {
                        //             print(url);
                        //             return true;
                        //           },
                        //           // mediaUploadInterceptor:
                        //           //     (PlatformFile file, InsertFileType type) async {
                        //           //   print(file.name); //filename
                        //           //   print(file.size); //size in bytes
                        //           //   print(file.extension); //file extension (eg jpeg or mp4)
                        //           //   return true;
                        //           // },
                        //         ),
                        //         otherOptions: htmleditor.OtherOptions(height: 550),
                        //         callbacks: htmleditor.Callbacks(
                        //             onBeforeCommand: (String? currentHtml) {
                        //           print('html before change is $currentHtml');
                        //         }, onChangeContent: (String? changed) {
                        //           print('content changed to $changed');
                        //         }, onChangeCodeview: (String? changed) {
                        //           print('code changed to $changed');
                        //         }, onChangeSelection:
                        //                 (htmleditor.EditorSettings settings) {
                        //           print(
                        //               'parent element is ${settings.parentElement}');
                        //           print('font name is ${settings.fontName}');
                        //         }, onDialogShown: () {
                        //           print('dialog shown');
                        //         }, onEnter: () {
                        //           print('enter/return pressed');
                        //         }, onFocus: () {
                        //           print('editor focused');
                        //         }, onBlur: () {
                        //           print('editor unfocused');
                        //         }, onBlurCodeview: () {
                        //           print('codeview either focused or unfocused');
                        //         }, onInit: () {
                        //           print('init');
                        //         },
                        //             //this is commented because it overrides the default Summernote handlers
                        //             /*onImageLinkInsert: (String? url) {
                        //   print(url ?? "unknown url");
                        // },
                        // onImageUpload: (FileUpload file) async {
                        //   print(file.name);
                        //   print(file.size);
                        //   print(file.type);
                        //   print(file.base64);
                        // },*/
                        //             onImageUploadError: (htmleditor.FileUpload? file,
                        //                 String? base64Str,
                        //                 htmleditor.UploadError error) {
                        //           print(base64Str ?? '');
                        //           if (file != null) {
                        //             print(file.name);
                        //             print(file.size);
                        //             print(file.type);
                        //           }
                        //         }, onKeyDown: (int? keyCode) {
                        //           print('$keyCode key downed');
                        //           print(
                        //               'current character count: ${controller.characterCount}');
                        //         }, onKeyUp: (int? keyCode) {
                        //           print('$keyCode key released');
                        //         }, onMouseDown: () {
                        //           print('mouse downed');
                        //         }, onMouseUp: () {
                        //           print('mouse released');
                        //         }, onNavigationRequestMobile: (String url) {
                        //           print(url);
                        //           return htmleditor.NavigationActionPolicy.ALLOW;
                        //         }, onPaste: () {
                        //           print('pasted into editor');
                        //         }, onScroll: () {
                        //           print('editor scrolled');
                        //         }),
                        //         plugins: [
                        //           htmleditor.SummernoteAtMention(
                        //               getSuggestionsMobile: (String value) {
                        //                 var mentions = <String>[
                        //                   'test1',
                        //                   'test2',
                        //                   'test3'
                        //                 ];
                        //                 return mentions
                        //                     .where(
                        //                         (element) => element.contains(value))
                        //                     .toList();
                        //               },
                        //               mentionsWeb: ['test1', 'test2', 'test3'],
                        //               onSelect: (String value) {
                        //                 print(value);
                        //               }),
                        //         ],
                        //       ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                                cursorColor: Colors.white),
                            hintColor: Colors.transparent,
                          ),
                          child: TextFormField(
                            controller: description,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 20, top: 20),
                                focusedBorder: border,
                                border: border,
                                hintStyle: TextStyle(color: Colors.black26),
                                labelStyle: TextStyle(
                                    fontFamily: 'Brandon', color: Colors.black),
                                filled: true,
                                fillColor: Color(0xFFFAFAFA),
                                hintText: AppLocalizations.of(context)!
                                    .translate("desc_prod")),
                          ),
                        ),
                      )
                    ]),
              ),
              productType == "simple"
                  ? Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyles(
                              value: AppLocalizations.of(context)!
                                      .translate("weight")! +
                                  " (kg)",
                              size: 14,
                              weight: FontWeight.bold,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                      cursorColor: Colors.white),
                                  hintColor: Colors.transparent,
                                ),
                                child: TextFormField(
                                  controller: weight,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 20, top: 20),
                                      focusedBorder: border,
                                      border: border,
                                      hintStyle:
                                          TextStyle(color: Colors.black26),
                                      labelStyle: TextStyle(
                                          fontFamily: 'Brandon',
                                          color: Colors.black),
                                      filled: true,
                                      fillColor: Color(0xFFFAFAFA),
                                      hintText: AppLocalizations.of(context)!
                                          .translate("weight")),
                                ),
                              ),
                            )
                          ]),
                    )
                  : Container(),
              productType == "simple"
                  ? Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyles(
                              value: AppLocalizations.of(context)!
                                      .translate("dimension")! +
                                  " (cm)",
                              size: 14,
                              weight: FontWeight.bold,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                      cursorColor: Colors.white),
                                  hintColor: Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: length,
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 20, top: 20),
                                            focusedBorder: border,
                                            border: border,
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            labelStyle: TextStyle(
                                                fontFamily: 'Brandon',
                                                color: Colors.black),
                                            filled: true,
                                            fillColor: Color(0xFFFAFAFA),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .translate("length")),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: TextFormField(
                                        controller: width,
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 20, top: 20),
                                            focusedBorder: border,
                                            border: border,
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            labelStyle: TextStyle(
                                                fontFamily: 'Brandon',
                                                color: Colors.black),
                                            filled: true,
                                            fillColor: Color(0xFFFAFAFA),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .translate("width")),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: TextFormField(
                                        controller: height,
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 20, top: 20),
                                            focusedBorder: border,
                                            border: border,
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
                                            labelStyle: TextStyle(
                                                fontFamily: 'Brandon',
                                                color: Colors.black),
                                            filled: true,
                                            fillColor: Color(0xFFFAFAFA),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .translate("height")),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]),
                    )
                  : Container(),
              Divider(),
              productType == "variable"
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductVariationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 8),
                        color: Colors.white,
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: TextStyles(
                                  value: "Product Variation",
                                  size: 14,
                                  color: darkColor,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Icon(
                                MaterialIcons.keyboard_arrow_right,
                                color: mutedColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              productType == "variable"
                  ? Consumer<AttributeProvider>(
                      builder: ((context, value, child) {
                        if (attributeProvider!.listVariant.length > 0) {
                          getDataVariation();
                        }
                        print("cekList: $cekList");
                        return attributeProvider!.listVariant.length == 0 ||
                                !cekList
                            ? Container()
                            : Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: Row(
                                      children: [
                                        Text("Attributes",
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Text(attributes,
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: Row(
                                      children: [
                                        Text("Price",
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Text(price,
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: Row(
                                      children: [
                                        Text("Weight",
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Text(weightString,
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                      }),
                    )
                  : Container(),
              SizedBox(height: 10),
              Center(
                child: store.loadInput
                    ? Container(
                        width: 180,
                        margin: EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: customLoading(),
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: MaterialButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          color: accentColor,
                          onPressed: () async {
                            if (widget.isEdit) {
                              if (productType == "simple") {
                                updateProduct();
                              } else if (productType == "variable") {
                                updateProductVariant();
                              }
                            } else if (productType == "simple") {
                              addProduct();
                            } else if (productType == "variable") {
                              addProductVariant();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Text(
                              widget.isEdit
                                  ? AppLocalizations.of(context)!
                                      .translate("update_product")!
                                      .toUpperCase()
                                  : AppLocalizations.of(context)!
                                      .translate("post_product")!,
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        );
      }),
    );
  }

  /*void _showMultiSelect(BuildContext context) async {
    final categories =
        Provider.of<CategoryProvider>(context, listen: false).productCategories;

    final _items = categories
        .map((category) =>
            MultiSelectItem<ProductCategoryModel>(category, category.name))
        .toList();
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          items: _items,
          initialValue: selectedCategories,
          onConfirm: (values) {
            setState(() {
              selectedCategories = values;
            });
          },
        );
      },
    );
  }*/
}
