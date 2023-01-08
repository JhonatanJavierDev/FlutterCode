part of '../pages.dart';

class FormShippingMethod extends StatefulWidget {
  final ShippingMethod? shippingMethod;
  const FormShippingMethod({this.shippingMethod});

  @override
  _FormShippingMethodState createState() => _FormShippingMethodState();
}

class _FormShippingMethodState extends State<FormShippingMethod> {
  TextEditingController _title = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _cost = new TextEditingController();
  TextEditingController _minAmount = new TextEditingController();
  TextEditingController _noClassCost = new TextEditingController();

  String _selectedTax = 'none';
  String? _selectedCalcType;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    _title.text = widget.shippingMethod!.shippingDetail!.settings!.title!;
    _description.text =
        widget.shippingMethod!.shippingDetail!.settings!.description!;
    _cost.text = widget.shippingMethod!.shippingDetail!.settings!.cost!;
    _minAmount.text =
        widget.shippingMethod!.shippingDetail!.settings!.minAmount!;
    _noClassCost.text =
        widget.shippingMethod!.shippingDetail!.settings!.classCostNoClassCost!;

    if (widget.shippingMethod!.shippingDetail!.settings!.calculationType! !=
        "") {
      _selectedCalcType =
          widget.shippingMethod!.shippingDetail!.settings!.calculationType!;
    }

    _selectedTax = widget.shippingMethod!.shippingDetail!.settings!.taxStatus!;
  }

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
            AppLocalizations.of(context)!.translate("edit_shipp_method")!,
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
                children: [_buildForm()],
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
                    _updateShippingMethod();
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

  _buildForm() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          _customTextField(
              _title,
              AppLocalizations.of(context)!.translate("title_method")!,
              AppLocalizations.of(context)!.translate("title_method")!),
          Visibility(
            visible:
                widget.shippingMethod?.shippingDetail?.id != 'free_shipping',
            child: _customTextField(_cost, "Cost", "0",
                inputType: TextInputType.number),
          ),
          Visibility(
            visible:
                widget.shippingMethod?.shippingDetail?.id == 'free_shipping',
            child: _customTextField(
                _minAmount,
                AppLocalizations.of(context)!
                    .translate("minim_order_freeshipp")!,
                "0",
                inputType: TextInputType.number),
          ),
          Visibility(
            visible:
                widget.shippingMethod?.shippingDetail?.id != 'free_shipping',
            child: _dropdownTaxes(),
          ),
          _customTextField(_description, "Description", "Description",
              maxLine: 3),
          Visibility(
            visible: widget.shippingMethod?.shippingDetail?.id == 'flat_rate',
            child: Container(
              child: Column(
                children: [
                  _customTextField(
                      _noClassCost,
                      AppLocalizations.of(context)!
                          .translate("no_delivery_costfee")!,
                      "N/A"),
                  _dropdownCalculationType()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _dropdownCalculationType() {
    final shipping = Provider.of<ShippingServiceProvider>(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextStyles(
            value: AppLocalizations.of(context)!.translate("calc_type")!,
            size: 15,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                onChanged: (dynamic value) {
                  setState(() {
                    value = value;
                    _selectedCalcType = value;
                  });
                },
                dropdownColor: Colors.white,
                icon: Container(child: Icon(Ionicons.chevron_down, size: 18)),
                value: _selectedCalcType,
                hint: Text(""),
                items: <DropdownMenuItem<String>>[
                  for (CalculationType model
                      in shipping.detailShipping!.calculationTypes!)
                    new DropdownMenuItem(
                      child: new Text(model.type!),
                      value: model.id,
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _dropdownTaxes() {
    final shipping = Provider.of<ShippingServiceProvider>(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextStyles(
            value: AppLocalizations.of(context)!.translate("tax_status")!,
            size: 15,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                onChanged: (dynamic value) {
                  setState(() {
                    value = value;
                    _selectedTax = value;
                  });
                },
                dropdownColor: Colors.white,
                icon: Container(child: Icon(Ionicons.chevron_down, size: 18)),
                value: _selectedTax,
                hint: Text(""),
                items: <DropdownMenuItem<String>>[
                  for (TaxStatus model in shipping.detailShipping!.taxStatuses!)
                    new DropdownMenuItem(
                      child: new Text(model.type!),
                      value: model.id,
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _customTextField(
      TextEditingController txtController, String? label, String? hint,
      {int maxLine = 1, TextInputType? inputType = TextInputType.text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextStyles(
            value: label,
            size: 15,
            weight: FontWeight.bold,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10, top: 10),
            child: TextFormField(
              controller: txtController,
              style: TextStyle(color: Colors.black),
              maxLines: maxLine,
              keyboardType: inputType,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: accentColor, width: 1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: accentColor, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: accentColor, width: 2)),
                  hintStyle: TextStyle(color: Colors.black26),
                  labelStyle:
                      TextStyle(fontFamily: 'Brandon', color: Colors.white),
                  hintText: hint,
                  helperMaxLines: 3,
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(10),
                  helperStyle: TextStyle(fontStyle: FontStyle.italic)),
            ),
          )
        ],
      ),
    );
  }

  _updateShippingMethod() {
    if (_title.text.isNotEmpty) {
      UIBlock.block(context);
      context
          .read<ShippingServiceProvider>()
          .updateShippingMethod(
              widget.shippingMethod?.shippingDetail?.instanceId,
              _title.text,
              _description.text,
              _cost.text,
              _minAmount.text,
              _selectedTax,
              _noClassCost.text,
              _selectedCalcType)
          .then((value) {
        UIBlock.unblock(context);
        if (value!.statusCode == 200) {
          Navigator.pop(context, 200);
          snackBar(context,
              message:
                  AppLocalizations.of(context)!.translate('success_update')!);
        } else if (value.statusCode == 500) {
          snackBar(context, message: value.message!);
        } else {
          snackBar(context,
              message:
                  AppLocalizations.of(context)!.translate("error_occurred")!);
        }
      });
    } else {
      snackBar(context,
          message:
              AppLocalizations.of(context)!.translate('shipping_title_req')!);
    }
  }
}
