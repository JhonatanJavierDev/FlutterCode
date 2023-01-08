part of '../pages.dart';

class AddVariationScreen extends StatefulWidget {
  final bool isEdit;
  final VariantModel? variant;
  final int? index;
  const AddVariationScreen(
      {Key? key, this.isEdit = false, this.variant, this.index})
      : super(key: key);

  @override
  State<AddVariationScreen> createState() => _AddVariationScreenState();
}

class _AddVariationScreenState extends State<AddVariationScreen> {
  AttributeProvider? attributeProvider;
  int lengthAttr = 0;
  bool selectedAttribute = false;
  bool _isManageStock = false;
  List<String> nameAttribute = [];
  List<AttributeModel> listAttribute = [];
  List<VariantModel> listvariant = [];
  String? attributeType;
  String statusType = "instock";
  TextEditingController productStock = new TextEditingController();
  TextEditingController weight = new TextEditingController();
  TextEditingController length = new TextEditingController();
  TextEditingController width = new TextEditingController();
  TextEditingController height = new TextEditingController();
  TextEditingController regPrice = new TextEditingController();
  TextEditingController salePrice = new TextEditingController();

  @override
  void initState() {
    super.initState();
    attributeProvider = Provider.of<AttributeProvider>(context, listen: false);
    getData();

    if (widget.isEdit) {
      weight.text = widget.variant!.weight!;
      length.text = widget.variant!.length!;
      width.text = widget.variant!.width!;
      height.text = widget.variant!.height!;
      regPrice.text = widget.variant!.varRegularPrice!;
      salePrice.text = widget.variant!.varSalePrice!;
      statusType = widget.variant!.varStockStatus!;
      if (_isManageStock) {
        productStock.text = widget.variant!.varStock!;
      }

      print("length : ${listAttribute.length}");
      for (int i = 0; i < listAttribute.length; i++) {
        for (int j = 0; j < listAttribute[i].term!.length; j++) {
          for (int k = 0; k < widget.variant!.listVariationAttr!.length; k++) {
            if (listAttribute[i].term![j].idTerm ==
                widget.variant!.listVariationAttr![k].id) {
              listAttribute[i].selectedTerm = listAttribute[i].term![j];
            }
          }
        }
        print(listAttribute[i].selectedTerm);
      }
      if (widget.variant!.varManageStock! == 'no') {
        _isManageStock = false;
      } else if (widget.variant!.varManageStock! == 'yes' &&
          statusType == "instock") {
        _isManageStock = true;
      }
    }
  }

  cekSelectedAttribute() {
    selectedAttribute = false;
    lengthAttr = 0;
    int length = attributeProvider!.listAttribute.length;
    for (int i = 0; i < length; i++) {
      if (attributeProvider!.listAttribute[i].selected == true) {
        selectedAttribute = true;
        lengthAttr++;
      }
    }
  }

  getData() {
    for (int i = 0; i < attributeProvider!.listAttribute.length; i++) {
      if (attributeProvider!.listAttribute[i].selected!) {
        listAttribute.add(attributeProvider!.listAttribute[i]);
      }
    }
    for (int i = 0; i < listAttribute.length; i++) {
      listAttribute[i].term!.sort(((a, b) => a.idTerm!.compareTo(b.idTerm!)));
      listAttribute[i].selectedTerm = listAttribute[i].term!.first;
    }
  }

  updateVariation(int index) {
    if (_isManageStock && productStock.text.isEmpty) {
      return snackBar(context, message: "Stock quantity shouldn't empty");
    }
    List<VariationAttributesModel> listVariantAttr = [];
    for (int i = 0; i < listAttribute.length; i++) {
      VariationAttributesModel varModel = new VariationAttributesModel(
          attributeName: listAttribute[i].term![0].taxonomy,
          id: int.parse(listAttribute[i].id!),
          option: listAttribute[i].selectedTerm!.slug);
      listVariantAttr.add(varModel);
    }
    print(regPrice.text);
    var _tempRegPrice = regPrice.text.replaceAll(new RegExp(r'[^0-9.]'), '');
    var _tempSalePrice = salePrice.text.replaceAll(new RegExp(r'[^0-9.]'), '');
    print(_tempRegPrice);
    //Check Form
    if (_tempRegPrice != "0.00" && regPrice.text.isNotEmpty) {
      attributeProvider!.updateVariant(
          index: index,
          height: height.text,
          length: length.text,
          id: widget.variant!.variableProductId,
          regPrice: _tempRegPrice.toString(),
          salePrice: _tempSalePrice.toString(),
          stockStatus: statusType,
          manageStock: _isManageStock ? "yes" : "no",
          weight: weight.text,
          width: width.text,
          stock: productStock.text,
          listVariantAttr: listVariantAttr);
      Navigator.pop(context);
    } else {
      return snackBar(context, message: "Regular Price shouldn't empty");
    }
  }

  submitVariation() {
    if (_isManageStock && productStock.text.isEmpty) {
      return snackBar(context, message: "Stock quantity shouldn't empty");
    }
    List<VariationAttributesModel> listVariantAttr = [];
    for (int i = 0; i < listAttribute.length; i++) {
      VariationAttributesModel varModel = new VariationAttributesModel(
          attributeName: listAttribute[i].term![0].taxonomy,
          id: int.parse(listAttribute[i].id!),
          option: listAttribute[i].selectedTerm!.slug == "All" ||
                  listAttribute[i].selectedTerm!.slug == "all"
              ? ""
              : listAttribute[i].selectedTerm!.slug);
      listVariantAttr.add(varModel);
    }
    print(regPrice.text);
    var _tempRegPrice = regPrice.text.replaceAll(new RegExp(r'[^0-9.]'), '');
    var _tempSalePrice = salePrice.text.replaceAll(new RegExp(r'[^0-9.]'), '');
    print(_tempRegPrice);
    //Check Form
    if (_tempRegPrice != "0.00" && regPrice.text.isNotEmpty) {
      print("status type : ${statusType.toString()}");
      attributeProvider!.submitVariant(
          height: height.text,
          length: length.text,
          regPrice: _tempRegPrice.toString(),
          salePrice: _tempSalePrice.toString(),
          stockStatus: statusType,
          manageStock: _isManageStock ? "yes" : "no",
          weight: weight.text,
          width: width.text,
          stock: productStock.text,
          listVariantAttr: listVariantAttr);
      Navigator.pop(context);
    } else {
      return snackBar(context, message: "Regular Price shouldn't empty");
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Add Variation",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              itemCount: listAttribute.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Visibility(
                    visible: listAttribute[index].selected!,
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(listAttribute[index].name!,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
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
                                  print(value);

                                  setState(() {
                                    value = value;
                                  });
                                  for (int i = 0;
                                      i < listAttribute[index].term!.length;
                                      i++) {
                                    if (value ==
                                        listAttribute[index].term![i].slug) {
                                      setState(() {
                                        listAttribute[index].selectedTerm =
                                            listAttribute[index].term![i];
                                      });
                                    }
                                  }
                                },
                                dropdownColor: Colors.white,
                                icon: Container(
                                    child: Icon(Ionicons.ios_arrow_down,
                                        size: 18)),
                                value: listAttribute[index].selectedTerm!.slug,
                                items: <DropdownMenuItem<String>>[
                                  for (int i = 0;
                                      i < listAttribute[index].term!.length;
                                      i++)
                                    if (listAttribute[index].selected! &&
                                        listAttribute[index].term![i].selected!)
                                      DropdownMenuItem(
                                        child: new Text(listAttribute[index]
                                            .term![i]
                                            .name!),
                                        value:
                                            listAttribute[index].term![i].slug,
                                      ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ),
            Divider(),
            Container(
              child: Row(
                children: [
                  Checkbox(
                    value: _isManageStock,
                    onChanged: (val) {
                      setState(() {
                        _isManageStock = !_isManageStock;
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
            ),
            Visibility(
              visible: !_isManageStock,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                                child: Icon(Ionicons.ios_arrow_down, size: 18)),
                            value: statusType,
                            items: <DropdownMenuItem<String>>[
                              DropdownMenuItem(
                                child: new Text(AppLocalizations.of(context)!
                                    .translate("in_stock")!),
                                value: "instock",
                              ),
                              DropdownMenuItem(
                                child: new Text(AppLocalizations.of(context)!
                                    .translate("out_stock")!),
                                value: "outofstock",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            Visibility(
              visible: _isManageStock,
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
              margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextStyles(
                      value:
                          AppLocalizations.of(context)!.translate("weight")! +
                              " (kg)",
                      size: 14,
                      weight: FontWeight.bold,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme:
                              TextSelectionThemeData(cursorColor: Colors.white),
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
                              hintStyle: TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(
                                  fontFamily: 'Brandon', color: Colors.black),
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              hintText: AppLocalizations.of(context)!
                                  .translate("weight")),
                        ),
                      ),
                    )
                  ]),
            ),
            Container(
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
                          textSelectionTheme:
                              TextSelectionThemeData(cursorColor: Colors.white),
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
                                    contentPadding:
                                        EdgeInsets.only(left: 20, top: 20),
                                    focusedBorder: border,
                                    border: border,
                                    hintStyle: TextStyle(color: Colors.black26),
                                    labelStyle: TextStyle(
                                        fontFamily: 'Brandon',
                                        color: Colors.black),
                                    filled: true,
                                    fillColor: Color(0xFFFAFAFA),
                                    hintText: AppLocalizations.of(context)!
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
                                    contentPadding:
                                        EdgeInsets.only(left: 20, top: 20),
                                    focusedBorder: border,
                                    border: border,
                                    hintStyle: TextStyle(color: Colors.black26),
                                    labelStyle: TextStyle(
                                        fontFamily: 'Brandon',
                                        color: Colors.black),
                                    filled: true,
                                    fillColor: Color(0xFFFAFAFA),
                                    hintText: AppLocalizations.of(context)!
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
                                    contentPadding:
                                        EdgeInsets.only(left: 20, top: 20),
                                    focusedBorder: border,
                                    border: border,
                                    hintStyle: TextStyle(color: Colors.black26),
                                    labelStyle: TextStyle(
                                        fontFamily: 'Brandon',
                                        color: Colors.black),
                                    filled: true,
                                    fillColor: Color(0xFFFAFAFA),
                                    hintText: AppLocalizations.of(context)!
                                        .translate("height")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
            Divider(),
            Container(
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
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextStyles(
                      value:
                          AppLocalizations.of(context)!.translate("sale_price"),
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
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 25,
                margin: EdgeInsets.only(bottom: 15),
                child: MaterialButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: accentColor,
                  onPressed: () {
                    if (!widget.isEdit) {
                      submitVariation();
                    } else if (widget.isEdit) {
                      updateVariation(widget.index!);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
