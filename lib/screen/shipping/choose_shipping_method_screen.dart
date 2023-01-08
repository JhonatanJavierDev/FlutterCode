part of '../pages.dart';

class ChooseShippingMethod extends StatefulWidget {
  final String? type;
  final String? zoneId;
  const ChooseShippingMethod({this.type, this.zoneId});

  @override
  _ChooseShippingMethodState createState() => _ChooseShippingMethodState();
}

class _ChooseShippingMethodState extends State<ChooseShippingMethod> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShippingServiceProvider>().setSelectedMethod('');
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
            AppLocalizations.of(context)!.translate("add_shipp_method")!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: TextStyles(
                      value: AppLocalizations.of(context)!
                          .translate("select_shipp_method")!,
                      size: 15,
                      weight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
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
                          });
                          context
                              .read<ShippingServiceProvider>()
                              .setSelectedMethod(value);
                        },
                        dropdownColor: Colors.white,
                        icon: Container(
                            child: Icon(Ionicons.chevron_down, size: 18)),
                        value: shipping.selectedMethod,
                        items: <DropdownMenuItem<String>>[
                          for (OptShippingMethod model
                              in shipping.detailShipping!.optShippingMethods!)
                            new DropdownMenuItem(
                              child: new Text(model.type!),
                              value: model.id,
                            ),
                        ],
                      ),
                    ),
                  ),
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
                  color:
                      shipping.selectedMethod == "" ? Colors.grey : accentColor,
                  onPressed: () {
                    if (shipping.selectedMethod != "") {
                      UIBlock.block(context);
                      context
                          .read<ShippingServiceProvider>()
                          .postShippingMethod(
                              widget.zoneId, shipping.selectedMethod, '')
                          .then((value) {
                        UIBlock.unblock(context);
                        if (value!.statusCode == 200) {
                          Navigator.pop(context, 200);
                          snackBar(context,
                              message: "Successfully added shipping method");
                        } else if (value.statusCode == 500) {
                          snackBar(context, message: value.message!);
                        } else {
                          snackBar(context,
                              message: AppLocalizations.of(context)!
                                  .translate("error_occurred")!);
                        }
                      });
                    }
                  },
                  child: TextStyles(
                    value: AppLocalizations.of(context)!.translate("submit"),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
