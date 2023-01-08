part of '../pages.dart';

class SettingPaymentScreen extends StatefulWidget {
  final BankAccount? bank;
  SettingPaymentScreen({this.bank});

  @override
  _SettingPaymentScreenState createState() => _SettingPaymentScreenState();
}

class _SettingPaymentScreenState extends State<SettingPaymentScreen> {
  TextEditingController accountName = new TextEditingController();
  TextEditingController accountNumber = new TextEditingController();
  TextEditingController bankName = new TextEditingController();
  TextEditingController bankAddress = new TextEditingController();
  TextEditingController roatingAddress = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // print(widget.bank.acName);
    if (widget.bank != null) {
      accountName.text = widget.bank!.acName!;
      accountNumber.text = widget.bank!.acNumber!;
      bankName.text = widget.bank!.bankName!;
      bankAddress.text = widget.bank!.bankAddr!;
      roatingAddress.text = widget.bank!.routingNumber!;
    }
  }

  void validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      print('Form is valid');
      updateVendor();
    } else {
      print('form is invalid');
    }
  }

  updateVendor() async {
    Provider.of<StoreProvider>(context, listen: false)
        .sendRekeningVendor(
          context,
          acName: accountName.text,
          acNumber: accountNumber.text,
          bankAddress: bankAddress.text,
          bankName: bankName.text,
          routingNumber: roatingAddress.text,
        )
        .then((value) {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.18),
        // titleSpacing: 0,
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
          AppLocalizations.of(context)!.translate("setting_pay")!,
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
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextStyles(
                      value: AppLocalizations.of(context)!
                          .translate("detail_bank"),
                      weight: FontWeight.bold,
                      size: 16,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 30),
                      child: TextStyles(
                        value: AppLocalizations.of(context)!
                            .translate("enter_bank"),
                        color: mutedColor,
                        weight: FontWeight.bold,
                        size: 12,
                      ),
                    ),
                    Container(
                      child: TextStyles(
                        value: AppLocalizations.of(context)!
                            .translate("account_name"),
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme:
                              TextSelectionThemeData(cursorColor: accentColor),
                          hintColor: Colors.transparent,
                        ),
                        child: TextFormField(
                          controller: accountName,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              focusedBorder: border,
                              border: border,
                              hintStyle: TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(
                                  fontFamily: 'Brandon', color: Colors.white),
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              hintText: AppLocalizations.of(context)!
                                  .translate("etr_account_name")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('form_acc_name')!;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: TextStyles(
                        value: AppLocalizations.of(context)!
                            .translate("account_number"),
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme:
                              TextSelectionThemeData(cursorColor: accentColor),
                          hintColor: Colors.transparent,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: accountNumber,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              focusedBorder: border,
                              border: border,
                              hintStyle: TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(
                                  fontFamily: 'Brandon', color: Colors.white),
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              hintText: AppLocalizations.of(context)!
                                  .translate("etr_account_num")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('form_acc_number')!;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: TextStyles(
                        value: AppLocalizations.of(context)!
                            .translate("bank_name"),
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme:
                              TextSelectionThemeData(cursorColor: accentColor),
                          hintColor: Colors.transparent,
                        ),
                        child: TextFormField(
                          controller: bankName,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              focusedBorder: border,
                              border: border,
                              hintStyle: TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(
                                  fontFamily: 'Brandon', color: Colors.white),
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              hintText: AppLocalizations.of(context)!
                                  .translate("etr_bank_name")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('form_bank_name')!;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: TextStyles(
                        value: AppLocalizations.of(context)!
                            .translate("bank_addr"),
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme:
                              TextSelectionThemeData(cursorColor: accentColor),
                          hintColor: Colors.transparent,
                        ),
                        child: TextFormField(
                          controller: bankAddress,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              focusedBorder: border,
                              border: border,
                              hintStyle: TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(
                                  fontFamily: 'Brandon', color: Colors.white),
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              hintText: AppLocalizations.of(context)!
                                  .translate("etr_bank_addr")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('form_bank_addr')!;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: TextStyles(
                        value:
                            AppLocalizations.of(context)!.translate("root_num"),
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme:
                              TextSelectionThemeData(cursorColor: accentColor),
                          hintColor: Colors.transparent,
                        ),
                        child: TextFormField(
                          controller: roatingAddress,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              focusedBorder: border,
                              border: border,
                              hintStyle: TextStyle(color: Colors.black26),
                              labelStyle: TextStyle(
                                  fontFamily: 'Brandon', color: Colors.white),
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              hintText: AppLocalizations.of(context)!
                                  .translate("etr_root_num")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translate('form_roasting_num')!;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
              width: double.infinity,
              height: 70,
              child: MaterialButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                color: accentColor,
                onPressed: () {
                  validateAndSave();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    AppLocalizations.of(context)!.translate("submit")!,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
