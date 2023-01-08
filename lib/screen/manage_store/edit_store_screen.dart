part of '../pages.dart';

class EditStoreScreen extends StatefulWidget {
  final StoreProvider? store;
  final bool isEdit;
  EditStoreScreen({this.store, this.isEdit = false});
  @override
  _EditStoreScreenState createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  ProductImage? imagesBanner;
  ProductImage? imagesLogo;

  TextEditingController storeName = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController zip = new TextEditingController();

  String? type;
  String? country = "ID";
  bool edit = false;
  bool loading = true;
  StoreModel? store;
  AddressDetail? addDetail;

  @override
  void initState() {
    super.initState();
    getStoreData();
  }

  _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      this.setState(() {});
      File imageFile = File(pickedFile.path);
      uploadImage(imageFile);
    }
  }

  uploadImage(File file) async {
    UIBlock.block(context);
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    await Provider.of<StoreProvider>(context, listen: false)
        .uploadImgProduct(context,
            title: "${storeName.text.toLowerCase()}-$type.jpg",
            media: base64Image)
        .then((value) {
      setState(() {
        if (type == "banner") {
          setState(() {
            imagesBanner =
                ProductImage(id: value.id, image: value.image, imgFile: file);
          });
        } else {
          imagesLogo =
              ProductImage(id: value.id, image: value.image, imgFile: file);
        }
        UIBlock.unblock(context);
      });
    });
  }

  registerVendor() async {
    if (storeName.text.isEmpty ||
        address.text.isEmpty ||
        description.text.isEmpty ||
        country!.isEmpty ||
        city.text.isEmpty ||
        zip.text.isEmpty) {
      return snackBar(context,
          message: AppLocalizations.of(context)!.translate("store_data_alert")!,
          textStyle: TextStyle(color: Colors.black),
          color: Colors.amber);
    } else if (imagesLogo == null && edit == false ||
        imagesBanner == null && edit == false) {
      return snackBar(context,
          message:
              AppLocalizations.of(context)!.translate("store_image_alert")!,
          textStyle: TextStyle(color: Colors.black),
          color: Colors.amber);
    } else {
      print("Register Store");
      UIBlock.block(context);
      Provider.of<RegisterUpdateVendor>(context, listen: false)
          .createupdateVendor(
        address: address.text,
        avatarID: imagesLogo!.id,
        bannerID: imagesBanner!.id,
        city: city.text,
        countryID: country,
        description: description.text,
        firstStore: storeName.text,
        isUpdate: edit,
        zip: zip.text,
      )
          .then(
        (value) {
          if (value != null) {
            if (edit == true) {
              getStoreData();
              return;
            } else {
              reLogUser();
            }
          }
        },
      );
    }
  }

  getStoreData() async {
    await Provider.of<StoreProvider>(context, listen: false)
        .fetchDetailManageStore(context)
        .then(
      (value) {
        print("value : ${value.toString()}");
        if (value != null) {
          store = value;
          print("get data store");
          if (widget.isEdit == true) {
            edit = true;
            //store = Provider.of<StoreProvider>(context, listen: false).manageStore;
            setState(() {
              storeName.text = store!.name!;
              if (store!.addressDetail != null)
                address.text = store!.addressDetail!.street1 ?? "";
              if (store!.description != null)
                description.text = store!.description!;
              if (store!.addressDetail != null)
                city.text = store!.addressDetail!.city ?? "";
              if (store!.addressDetail != null)
                country = store!.addressDetail!.country;
              if (store!.addressDetail != null)
                zip.text = store!.addressDetail!.zip ?? "";
              if (store!.banner != null)
                imagesBanner =
                    ProductImage(id: store!.bannerID, image: store!.banner);
              if (store!.icon != null)
                imagesLogo =
                    ProductImage(id: store!.iconID, image: store!.icon);
            });
          }
          setState(() {
            loading = false;
          });

          //Navigator.pop(context);
        } else if (Session.data.getString('role') != 'wcfm_vendor') {
          print("test");
          setState(() {
            loading = false;
          });
        } else {
          snackBar(context,
              message:
                  AppLocalizations.of(context)!.translate('something_wrong')!);
        }
      },
    );
  }

  reLogUser() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth
        .reLog(context,
            username: Session.data.getString('email'),
            password: Session.data.getString('password'))
        .then((value) {
      UIBlock.unblock(context);
      Navigator.pop(context, 200);
    });
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
          AppLocalizations.of(context)!.translate("regis_store")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: loading
          ? customLoading()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 80),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // ImgStyle(
                            //   url:
                            //       "https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
                            //   width: double.infinity,
                            //   height: 207,
                            //   radius: 0,
                            // ),
                            imagesBanner != null && edit == false
                                ? Container(
                                    width: double.infinity,
                                    height: 207,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.file(
                                        imagesBanner!.imgFile!,
                                      ),
                                    ),
                                  )
                                : widget.isEdit
                                    ? Container(
                                        width: double.infinity,
                                        height: 207,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: CachedNetworkImage(
                                            imageUrl: imagesBanner!.image!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                customLoading(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      )
                                    : Image.asset(
                                        "assets/images/store/bg-store.png"),
                            Container(
                              width: double.infinity,
                              height: 207,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ImgStyle(
                                  //   url:
                                  //       "https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80",
                                  //   width: 80,
                                  //   height: 80,
                                  //   radius: 100,
                                  // ),
                                  imagesLogo != null && edit == false
                                      ? Container(
                                          width: 100,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: Image.file(
                                                imagesLogo!.imgFile!,
                                              ),
                                            ),
                                          ),
                                        )
                                      : widget.isEdit
                                          ? Container(
                                              width: 100,
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(100),
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        imagesLogo!.image!,
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    placeholder:
                                                        (context, url) =>
                                                            customLoading(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Image.asset(
                                              "assets/images/store/pp-store.png",
                                              width: 100,
                                            ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  color: accentColor,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    type = "banner";
                                    _getFromGallery();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("change_banner")!,
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              Container(width: 10),
                              Expanded(
                                flex: 1,
                                child: MaterialButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  color: accentColor,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    type = "logo";
                                    _getFromGallery();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("change_logo")!,
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
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
                                value: AppLocalizations.of(context)!
                                    .translate("store_name"),
                                size: 14,
                                weight: FontWeight.bold,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                child: GreyText(
                                  paddingScroll: 92.0,
                                  controllerTxt: storeName,
                                  hintText: AppLocalizations.of(context)!
                                      .translate("etr_store_name"),
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
                                value: AppLocalizations.of(context)!
                                    .translate("address"),
                                size: 14,
                                weight: FontWeight.bold,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                child: GreyText(
                                  paddingScroll: 92.0,
                                  controllerTxt: address,
                                  hintText: AppLocalizations.of(context)!
                                      .translate("etr_addr"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("desc"),
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
                                    scrollPadding:
                                        EdgeInsets.only(bottom: 92.0),
                                    controller: description,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    maxLength: 1000,
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
                                            .translate("etr_desc")),
                                  ),
                                ),
                              ),
                              TextStyles(
                                value: AppLocalizations.of(context)!
                                    .translate("country"),
                                size: 14,
                                weight: FontWeight.bold,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    CountryCodePicker(
                                      alignLeft: true,
                                      onChanged: (e) {
                                        country = e.code;
                                      },
                                      initialSelection: country,
                                      showCountryOnly: true,
                                      showOnlyCountryWhenClosed: true,
                                      // favorite: ['+62', 'ID'],
                                    ),
                                    Positioned(
                                      right: 15,
                                      top: 16,
                                      child: Icon(Ionicons.ios_arrow_down,
                                          size: 18),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("city"),
                                  size: 14,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                child: GreyText(
                                  paddingScroll: 92.0,
                                  controllerTxt: city,
                                  hintText: AppLocalizations.of(context)!
                                      .translate("etr_city"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: TextStyles(
                                  value: AppLocalizations.of(context)!
                                      .translate("zip"),
                                  size: 14,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                child: GreyText(
                                  paddingScroll: 92.0,
                                  controllerTxt: zip,
                                  hintText: AppLocalizations.of(context)!
                                      .translate("etr_zip"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.grey.withOpacity(0.30),
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(14, 8, 14, 8),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            color: accentColor,
                            onPressed: () {
                              registerVendor();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("register")!
                                    .toUpperCase(),
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
