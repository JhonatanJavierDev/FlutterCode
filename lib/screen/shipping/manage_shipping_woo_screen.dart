part of '../pages.dart';

class ShippingWooScreen extends StatefulWidget {
  const ShippingWooScreen();

  @override
  _ShippingWooScreenState createState() => _ShippingWooScreenState();
}

class _ShippingWooScreenState extends State<ShippingWooScreen> {
  bool? _isEnable = false;
  String? _selectedPt = "", _selectedShippingType = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getListShipping();
    });
  }

  _getListShipping() async {
    context.read<ShippingServiceProvider>().reset();
    context
        .read<ShippingServiceProvider>()
        .getWcShippingSetting()
        .then((value) {
      setState(() {
        if (value!.userShipping != null) {
          _selectedPt = value.userShipping!.pt ?? "";
          _selectedShippingType = value.userShipping!.userShippingType ?? "";
        }
        _isEnable = value.userShipping!.isEnable ?? false;
      });
    });
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
            AppLocalizations.of(context)!.translate("shipping_service")!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: shipping.isLoadingSetting
            ? Center(child: spinDancing)
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
                                    .translate("enable_shipp")!,
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
                                        .translate("process_time")!,
                                    size: 15,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFAFAFA),
                                      border: Border.all(color: Colors.white)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          value = value;
                                          _selectedPt = value;
                                        });
                                      },
                                      dropdownColor: Colors.white,
                                      icon: Container(
                                          child: Icon(Ionicons.chevron_down,
                                              size: 18)),
                                      value: _selectedPt,
                                      items: <DropdownMenuItem<String>>[
                                        for (OptProcessingTime model in shipping
                                            .shippingWoo!.optProcessingTime!)
                                          new DropdownMenuItem(
                                            child: new Text(model.name!),
                                            value: model.id,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextStyles(
                                    value: AppLocalizations.of(context)!
                                        .translate("shipp_type")!,
                                    size: 15,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFAFAFA),
                                      border: Border.all(color: Colors.white)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          value = value;
                                          _selectedShippingType = value;
                                        });
                                      },
                                      dropdownColor: Colors.white,
                                      icon: Container(
                                          child: Icon(Ionicons.chevron_down,
                                              size: 18)),
                                      value: _selectedShippingType,
                                      items: <DropdownMenuItem<String>>[
                                        for (OptShippingType model in shipping
                                            .shippingWoo!.optShippingType!)
                                          new DropdownMenuItem(
                                            child: new Text(model.name!),
                                            value: model.id,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                            visible: shipping.shippingWoo!.listZones!.isEmpty &&
                                _isEnable!,
                            child: Center(
                                child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("no_shipping_zone")!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center),
                            ))),
                        shipping.shippingWoo!.userShipping == null
                            ? Container()
                            : Visibility(
                                visible: shipping.shippingWoo!.userShipping!
                                        .userShippingType!.isNotEmpty &&
                                    _isEnable! &&
                                    _selectedShippingType!.isNotEmpty,
                                child: ListView.separated(
                                    itemCount:
                                        shipping.shippingWoo!.listZones!.length,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      return _buildCardShipping(shipping
                                          .shippingWoo!.listZones![index]);
                                    }),
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
                          UIBlock.block(context);
                          context
                              .read<ShippingServiceProvider>()
                              .postShippingSettings(
                                  _isEnable, _selectedPt, _selectedShippingType)
                              .then((value) {
                            UIBlock.unblock(context);
                            if (value!.statusCode == 200) {
                              snackBar(context,
                                  message:
                                      "Successfully saving shipping settings");
                            } else if (value.statusCode == 500) {
                              snackBar(context, message: value.message!);
                            } else {
                              snackBar(context,
                                  message: AppLocalizations.of(context)!
                                      .translate("error_occurred")!);
                            }
                            _getListShipping();
                          });
                        },
                        child: TextStyles(
                          value:
                              AppLocalizations.of(context)!.translate("submit"),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  _buildCardShipping(Zone zone) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 50, right: 15),
      decoration: BoxDecoration(
          border: Border.all(color: accentColor),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextStyles(
            value: AppLocalizations.of(context)!.translate("zone_name")!,
            size: 15,
            weight: FontWeight.bold,
          ),
          TextStyles(
            value: zone.detailZone!.zoneName,
            size: 15,
          ),
          SizedBox(
            height: 8,
          ),
          TextStyles(
            value: AppLocalizations.of(context)!.translate("regions")!,
            size: 15,
            weight: FontWeight.bold,
          ),
          TextStyles(
            value: zone.detailZone!.formattedZoneLocation,
            size: 15,
          ),
          SizedBox(
            height: 8,
          ),
          TextStyles(
            value: AppLocalizations.of(context)!.translate("shipp_method")!,
            size: 15,
            weight: FontWeight.bold,
          ),
          TextStyles(
            value: zone.detailZone!.shippingMethods!.isNotEmpty
                ? zone.detailZone!.shippingMethods!.join(", ")
                : "No method found",
            size: 15,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            color: Colors.white,
            height: 30,
            width: double.infinity,
            child: MaterialButton(
              color: accentColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailShippingWooScreen(zoneId: zone.id),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              child: TextStyles(
                value: AppLocalizations.of(context)!.translate("edit"),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
