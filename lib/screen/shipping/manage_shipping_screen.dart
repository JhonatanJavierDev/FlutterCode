part of '../pages.dart';

class ShippingServiceScreen extends StatefulWidget {
  const ShippingServiceScreen();

  @override
  _ShippingServiceScreenState createState() => _ShippingServiceScreenState();
}

class _ShippingServiceScreenState extends State<ShippingServiceScreen> {
  String? _currentSelectedValue;
  bool? isEpekenActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getListShipping();
    });
  }

  _getListShipping() async {
    Provider.of<ShippingServiceProvider>(context, listen: false)
        .getShippingProvider()
        .then((value) {
      setState(() {
        isEpekenActive = value!.activePlugin!;
      });
      if (value!.activePlugin!) {
        for (var item in value.city!) {
          if (item.selected == "1") {
            setState(() {
              _currentSelectedValue = item.id;
            });
          }
        }
      }
    });
  }

  Widget build(BuildContext context) {
    if (!isEpekenActive!) {
      return ShippingWooScreen();
    }
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
      body: Consumer<ShippingServiceProvider>(
        builder: (context, value, child) {
          return value.isLoading
              ? Center(child: spinDancing)
              : !value.listEpeken!.activePlugin!
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: TextStyles(
                              value: "Epeken All Kurir Plugin Not Installed",
                              size: 16,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 20,
                                  bottom: 10,
                                ),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("city"),
                                  size: 14,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFAFAFA),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _currentSelectedValue,
                                        isDense: true,
                                        hint: Text(AppLocalizations.of(context)!
                                            .translate("select_city")!),
                                        icon: Container(
                                          child: Icon(Ionicons.ios_arrow_down,
                                              size: 18),
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _currentSelectedValue = newValue!;
                                            state.didChange(newValue);
                                            print(_currentSelectedValue);
                                          });
                                        },
                                        items: value.listEpeken!.city!
                                            .map((var values) {
                                          return DropdownMenuItem<String>(
                                            value: values.id,
                                            child: Text(values.name!),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: value.listEpeken!.service!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var result =
                                        value.listEpeken!.service![index];
                                    return Material(
                                      child: InkWell(
                                        onTap: () {
                                          value.setKurir(data: result);
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 12, 0, 12),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 13),
                                                child: Icon(
                                                  result.selected == '1'
                                                      ? Icons.check_box
                                                      : Icons
                                                          .check_box_outline_blank,
                                                  color: accentColor,
                                                ),
                                              ),
                                              TextStyles(
                                                value: result.name,
                                                size: 16,
                                                weight: FontWeight.bold,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.white,
                            height: 60,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: MaterialButton(
                                color: accentColor,
                                onPressed: () {
                                  if (_currentSelectedValue == null) {
                                    snackBar(context,
                                        message: AppLocalizations.of(context)!
                                            .translate("shipping_not_found")!,
                                        color: Colors.redAccent);
                                  } else {
                                    value.submitShipping(context,
                                        kotaID: _currentSelectedValue);
                                  }
                                },
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("submit"),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
        },
      ),
    );
  }
}
