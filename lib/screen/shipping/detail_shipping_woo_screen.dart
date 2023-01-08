part of '../pages.dart';

class DetailShippingWooScreen extends StatefulWidget {
  final String? zoneId;
  const DetailShippingWooScreen({this.zoneId});

  @override
  _DetailShippingWooScreenState createState() =>
      _DetailShippingWooScreenState();
}

class _DetailShippingWooScreenState extends State<DetailShippingWooScreen> {
  bool? _isEnable = false;
  TextEditingController zipCode = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDetailShipping();
    });
  }

  _getDetailShipping() async {
    context.read<ShippingServiceProvider>().reset();
    context
        .read<ShippingServiceProvider>()
        .getWcShippingDetail(widget.zoneId)
        .then((value) {
      setState(() {
        _isEnable = value?.isLimitZoneEnabled;
        if (value!.locations!.isNotEmpty) {
          List<String>? _postCodes = [];
          value.locations!.forEach((element) {
            _postCodes.add(element.code!);
          });
          zipCode.text = _postCodes.join(',');
        }
      });
    });
    context.read<ShippingServiceProvider>().getWcShippingSetting();
  }

  Widget build(BuildContext context) {
    final shipping = Provider.of<ShippingServiceProvider>(context);

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
            AppLocalizations.of(context)!.translate("back_zone_list")!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: shipping.isLoading
            ? Center(child: spinDancing)
            : shipping.detailShipping == null
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 10, top: 15),
                                    child: TextStyles(
                                      value: AppLocalizations.of(context)!
                                          .translate("zone_name")!,
                                      size: 15,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: TextStyles(
                                      value: shipping
                                          .detailShipping?.detailZone?.zoneName,
                                      size: 15,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: TextStyles(
                                      value: AppLocalizations.of(context)!
                                          .translate("zone_loc")!,
                                      size: 15,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    child: TextStyles(
                                      value: shipping.detailShipping
                                          ?.formattedZoneLocation,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _isEnable,
                                    onChanged: (val) {
                                      setState(() {
                                        _isEnable = !_isEnable!;
                                      });
                                    },
                                    activeColor: accentColor,
                                  ),
                                  TextStyles(
                                    value: AppLocalizations.of(context)!
                                        .translate("limit_loc")!,
                                    size: 15,
                                    weight: FontWeight.bold,
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: _isEnable!,
                              child: Container(
                                margin: EdgeInsets.only(left: 50, right: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: TextStyles(
                                        value: AppLocalizations.of(context)!
                                            .translate("set_postcode")!,
                                        size: 15,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: TextFormField(
                                        controller: zipCode,
                                        style: TextStyle(color: Colors.black),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9a-zA-Z ,]")),
                                        ],
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                borderSide: BorderSide(
                                                    color: accentColor,
                                                    width: 1)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                borderSide: BorderSide(
                                                    color: accentColor,
                                                    width: 2)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                borderSide: BorderSide(
                                                    color: accentColor,
                                                    width: 2)),
                                            contentPadding:
                                                EdgeInsets.only(left: 20),
                                            hintStyle:
                                                TextStyle(color: Colors.black26),
                                            labelStyle: TextStyle(fontFamily: 'Brandon', color: Colors.white),
                                            hintText: AppLocalizations.of(context)!.translate('postcode')!,
                                            helperText: "Postcodes containing wildcards (e.g. CB23*) or fully numeric ranges (e.g. 90210...99000) are also supported.",
                                            helperMaxLines: 3,
                                            helperStyle: TextStyle(fontStyle: FontStyle.italic)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 50, right: 15, top: 10),
                              child: TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("shipp_method")!,
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                            ),
                            Visibility(
                              visible: shipping
                                  .detailShipping!.shippingMethods!.isEmpty,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 50, right: 15, top: 10),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate('no_shipping_found')!,
                                  size: 15,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: shipping
                                  .detailShipping!.shippingMethods!.isNotEmpty,
                              child: ListView.separated(
                                  itemCount: shipping
                                      .detailShipping!.shippingMethods!.length,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 5,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    return _buildListShippingMethod(shipping
                                        .detailShipping!
                                        .shippingMethods![index]);
                                  }),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 50, right: 100, top: 10),
                              child: MaterialButton(
                                color: accentColor,
                                onPressed: () async {
                                  dynamic _result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChooseShippingMethod(
                                              zoneId: widget.zoneId),
                                    ),
                                  );
                                  if (_result == 200) {
                                    _getDetailShipping();
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0)),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("add_shipp_method")!,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: 60,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: MaterialButton(
                            color: accentColor,
                            onPressed: () {
                              _submitShippingDetail(
                                  shipping.detailShipping!.shippingMethods!);
                            },
                            child: TextStyles(
                              value: AppLocalizations.of(context)!
                                  .translate("submit"),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
  }

  _buildListShippingMethod(ShippingMethod shippingMethod) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: shippingMethod.shippingDetail?.isEnabled,
                onChanged: (val) {
                  setState(() {
                    shippingMethod.shippingDetail?.isEnabled =
                        !shippingMethod.shippingDetail!.isEnabled!;
                  });
                },
                activeColor: accentColor,
              ),
              TextStyles(
                value: shippingMethod.shippingDetail?.title,
                size: 15,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    color: Colors.white,
                    icon: Icon(Icons.delete, size: 25),
                    onPressed: () {
                      showAlertDeleteDialog(
                          shippingMethod.shippingDetail?.instanceId);
                    },
                  )),
              SizedBox(
                width: 10,
              ),
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    icon: Icon(Icons.edit, size: 25),
                    onPressed: () async {
                      dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormShippingMethod(
                              shippingMethod: shippingMethod),
                        ),
                      );
                      if (result == 200) {
                        _getDetailShipping();
                      }
                    },
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void showAlertDeleteDialog(instanceId) {
    SimpleDialog alert = SimpleDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              TextStyles(
                value: AppLocalizations.of(context)!
                    .translate("remove_shipp_method")!,
                size: 16,
                weight: FontWeight.bold,
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
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
                          value: AppLocalizations.of(context)!.translate("no")!,
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
                          Navigator.pop(context);
                          UIBlock.block(context);
                          context
                              .read<ShippingServiceProvider>()
                              .postShippingMethod(widget.zoneId, '', instanceId)
                              .then((value) {
                            UIBlock.unblock(context);
                            if (value!.statusCode == 200) {
                              snackBar(context,
                                  message:
                                      "Successfully removing shipping method");
                            } else if (value.statusCode == 500) {
                              snackBar(context, message: value.message!);
                            } else {
                              snackBar(context,
                                  message: AppLocalizations.of(context)!
                                      .translate("error_occurred")!);
                            }
                            _getDetailShipping();
                          });
                        },
                        child: TextStyles(
                          value:
                              AppLocalizations.of(context)!.translate("yes")!,
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

  _submitShippingDetail(List<dynamic> shippingMethods) {
    UIBlock.block(context);
    String? _finalPostCode = zipCode.text;
    if (zipCode.text.endsWith(',') || zipCode.text.startsWith(",")) {
      _finalPostCode = zipCode.text.replaceAll(",", "");
    }
    if (!_isEnable!) {
      _finalPostCode = '';
    }
    List<String>? _enableMethods = [];
    List<String>? _disableMethods = [];
    shippingMethods.forEach((element) {
      if (element.shippingDetail?.isEnabled) {
        _enableMethods.add(element.shippingDetail?.instanceId);
      } else {
        _disableMethods.add(element.shippingDetail?.instanceId);
      }
    });
    context
        .read<ShippingServiceProvider>()
        .postShippingDetail(widget.zoneId, _finalPostCode,
            _enableMethods.join(","), _disableMethods.join(","))
        .then((value) {
      UIBlock.unblock(context);
      if (value!.statusCode == 200) {
        snackBar(context, message: "Successfully saving shipping detail");
        zipCode.clear();
        _getDetailShipping();
      } else if (value.statusCode == 500) {
        snackBar(context, message: value.message!);
      } else {
        snackBar(context,
            message:
                AppLocalizations.of(context)!.translate("error_occurred")!);
      }
    });
  }
}
