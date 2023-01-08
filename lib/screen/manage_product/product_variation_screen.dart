part of '../pages.dart';

class ProductVariationScreen extends StatefulWidget {
  const ProductVariationScreen({Key? key}) : super(key: key);

  @override
  State<ProductVariationScreen> createState() => _ProductVariationScreenState();
}

class _ProductVariationScreenState extends State<ProductVariationScreen> {
  List<String> listAttr = [];
  AttributeProvider? attributeProvider;
  bool selectedAttribute = false;
  bool edit = false;
  int lengthAttr = 0;

  @override
  void initState() {
    super.initState();
    attributeProvider = Provider.of<AttributeProvider>(context, listen: false);
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
    if (attributeProvider!.listVariant.length > 0) {}
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
          "Product Variation",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        Consumer<AttributeProvider>(
                          builder: ((context, value, child) {
                            cekSelectedAttribute();
                            return Container(
                              margin: EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SelectAttributeScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Attribute",
                                          style: TextStyle(
                                              color: accentColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        selectedAttribute == false
                                            ? Text(
                                                "Please select attributes first (Min 1 attribute)",
                                                style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 14))
                                            : Container(
                                                width: 300,
                                                height: 40,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: attributeProvider!
                                                      .listAttribute.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Visibility(
                                                        visible:
                                                            attributeProvider!
                                                                .listAttribute[
                                                                    index]
                                                                .selected!,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border
                                                                    .all(),
                                                              ),
                                                              child: Text(
                                                                  attributeProvider!
                                                                      .listAttribute[
                                                                          index]
                                                                      .name!,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12)),
                                                            ),
                                                          ],
                                                        ));
                                                  },
                                                ),
                                              ),
                                      ],
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
                            );
                          }),
                        ),
                        Consumer<AttributeProvider>(
                          builder: (context, value, child) {
                            return attributeProvider!.listVariant.length == 0
                                ? Container()
                                : Container(
                                    child: ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        attributeProvider!.listVariant.length,
                                    itemBuilder: (context, index) {
                                      return attributeProvider!
                                                  .listVariant[index]
                                                  .deleteProductVariant ==
                                              null
                                          ? Container(
                                              margin: EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(-1, 0),
                                                        color: Colors.grey
                                                            .withOpacity(0.40),
                                                        blurRadius: 3),
                                                  ],
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.3)),
                                              child: ExpansionTile(
                                                title: Text(
                                                    "Variation ${(index + 1).toString()}"),
                                                collapsedIconColor:
                                                    Colors.black,
                                                collapsedTextColor:
                                                    Colors.black,
                                                textColor: Colors.black,
                                                iconColor: Colors.black,
                                                subtitle: Container(
                                                  width: 100,
                                                  height: 50,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        attributeProvider!
                                                            .listVariant[index]
                                                            .listVariationAttr!
                                                            .length,
                                                    itemBuilder: (context, j) {
                                                      return Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        3),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 0.3),
                                                            ),
                                                            child: Text(
                                                                attributeProvider!
                                                                            .listVariant[
                                                                                index]
                                                                            .listVariationAttr![
                                                                                j]
                                                                            .option! ==
                                                                        ""
                                                                    ? "All"
                                                                    : attributeProvider!
                                                                        .listVariant[
                                                                            index]
                                                                        .listVariationAttr![
                                                                            j]
                                                                        .option!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "Regular Price",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Spacer(),
                                                            Text(
                                                                '${stringToCurrency(double.parse(attributeProvider!.listVariant[index].varRegularPrice!), context)}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                          ],
                                                        ),
                                                        attributeProvider!
                                                                        .listVariant[
                                                                            index]
                                                                        .varSalePrice !=
                                                                    "0.00" &&
                                                                attributeProvider!
                                                                        .listVariant[
                                                                            index]
                                                                        .varSalePrice !=
                                                                    "0"
                                                            ? Row(
                                                                children: [
                                                                  Text(
                                                                      "Sale Price",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black38,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Spacer(),
                                                                  Text(
                                                                      '${stringToCurrency(double.parse(attributeProvider!.listVariant[index].varSalePrice!), context)}',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold))
                                                                ],
                                                              )
                                                            : Container(),
                                                        Row(
                                                          children: [
                                                            Text("Stock Status",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Spacer(),
                                                            Text(
                                                                '${attributeProvider!.listVariant[index].varStockStatus}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("Weight",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Spacer(),
                                                            Text(
                                                                '${attributeProvider!.listVariant[index].weight} kg',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                          ],
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Dimension",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Spacer(),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  'Width ${attributeProvider!.listVariant[index].width} cm',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  softWrap:
                                                                      true,
                                                                ),
                                                                Text(
                                                                  'Length ${attributeProvider!.listVariant[index].length} cm',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                  'Height ${attributeProvider!.listVariant[index].height} cm',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                      MaterialIcons
                                                                          .edit),
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        "$edit");
                                                                    setState(
                                                                        () {
                                                                      edit =
                                                                          true;
                                                                    });
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => AddVariationScreen(
                                                                              isEdit: true,
                                                                              variant: attributeProvider!.listVariant[index],
                                                                              index: index),
                                                                        ));
                                                                  },
                                                                ),
                                                              ),
                                                              Container(
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                      MaterialIcons
                                                                          .delete),
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        "delete");
                                                                    attributeProvider!
                                                                        .deleteVariant(
                                                                            index);
                                                                    printLog(
                                                                        "listVariantDelete: ${attributeProvider!.listVariant.length}");
                                                                  },
                                                                ),
                                                              ),
                                                            ])
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ))
                                          : Container();
                                    },
                                  ));
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              if (selectedAttribute) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddVariationScreen(),
                                  ),
                                );
                              } else {
                                snackBar(context,
                                    message: "Please select attributes first");
                              }
                            },
                            child: Row(
                              children: [
                                Icon(MaterialIcons.add_circle,
                                    color: Colors.black),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Add Variation Product"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))),
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
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
