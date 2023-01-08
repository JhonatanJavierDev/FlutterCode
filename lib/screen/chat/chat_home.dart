part of '../pages.dart';

class ChatHomeScreen extends StatefulWidget {
  late final String? receiverId;
  late final ProductModel? product;
  ChatHomeScreen({this.receiverId, this.product});
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

bool imageSend = false;

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final formatCurrency = new NumberFormat.simpleCurrency();
  bool loadingSend = false;
  bool ada = false;
  bool clickChat = false;
  bool loadingChat = true;
  int? chatId;
  File? _image;
  final text = TextEditingController();
  final picker = ImagePicker();
  List<ChatDetail> detailChat = [];
  ListChat? detailPerson;
  List<ChatMessage>? messages;

  ProductModel? _product;
  String? _receiverId;

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
    _product = widget.product;
    _receiverId = widget.receiverId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getListChat();
      await getDetailChat();
    });
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  getListChat() async {
    Provider.of<DetailChatProvider>(context, listen: false)
        .getlistChat()
        .then((value) {
      if (value.isNotEmpty) {
        setState(() {
          ada = true;
        });

        if (_receiverId != null) {
          for (var item in value) {
            if (_receiverId == item.receiverId!) {
              setState(() {
                chatId = int.parse(item.id!);
                detailPerson = item;
              });
            }
          }
        }
        getDetailChat();
      } else {
        setState(() {
          ada = false;
        });
      }
    });
  }

  getDetailChat() async {
    loadingChat = false;
    Provider.of<DetailChatProvider>(context, listen: false)
        .getDetailChat(chatID: chatId.toString())
        .then((value) {
      setState(() {
        detailChat = value;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });
        clickChat = true;
        loadingChat = true;
      });
    });
  }

  getBackProsesKirim(dynamic value) {
    getDetailChat();
  }

  void addText() async {
    FocusScope.of(context).unfocus();
    setState(() {
      loadingSend = true;
    });

    Provider.of<DetailChatProvider>(context, listen: false)
        .sendMessage(
      message: text.text,
      receiverId: _product != null ? _product!.vendor!.id : _receiverId,
      postID: _product != null ? _product!.id : _receiverId,
      type: _product != null ? "produk" : null,
    )
        .then((value) {
      removeProductSelected();
      text.clear();
      setState(() {
        loadingSend = false;
      });

      if (value == true) {
        getListChat();
        getDetailChat();
      }
    });
  }

  Future<ProductImage?> uploadImage(File file) async {
    List<int> imageBytes = file.readAsBytesSync();
    ProductImage? result;
    String base64Image = base64Encode(imageBytes);
    await Provider.of<StoreProvider>(context, listen: false)
        .uploadImgProduct(context,
            title: "${"image".toLowerCase()}.jpg", media: base64Image)
        .then((value) {
      result = value;
      return result;
    });
    return result;
  }

  void removeProductSelected() async {
    setState(() {
      if (_product != null) {
        _product = null;
      }
    });
  }

  void _detailModalBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 20, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 100),
                                child: Line(
                                  color: Color(0xFFC4C4C4),
                                  height: 5,
                                ),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 60),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        getImageFromGallery();
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.image,
                                            size: 30,
                                            color: tittleColor,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: TextStyles(
                                              color: tittleColor,
                                              value: AppLocalizations.of(
                                                      context)!
                                                  .translate("image_gallery"),
                                              size: 14,
                                              weight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        getImageFromCamera();
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.camera_alt,
                                            size: 30,
                                            color: tittleColor,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: TextStyles(
                                              color: tittleColor,
                                              value:
                                                  AppLocalizations.of(context)!
                                                      .translate("camera"),
                                              size: 14,
                                              weight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void scrollToBottom() {
    if (_scrollController!.hasClients) {
      Timer(Duration(milliseconds: 500), () {
        _scrollController!.animateTo(
            _scrollController!.position.maxScrollExtent * 2.5,
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut);
      });
    }
  }

  ScrollController? _scrollController;

  Future getImageFromGallery() async {
    UIBlock.block(context);
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      uploadImage(_image!).then((value) {
        if (value != null) {
          UIBlock.unblock(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageSend(
                person: detailPerson,
                image: _image,
                urlImage: value,
                receiverID: int.parse(
                  _receiverId!,
                ),
              ),
            ),
          ).then(getBackProsesKirim);
        } else {
          UIBlock.unblock(context);
        }
      });
    } else {
      UIBlock.unblock(context);
    }
  }

  Future getImageFromCamera() async {
    try {
      print("Picking Image");
      final pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
      if (pickedFile == null) return;
      final imageTemporary = File(pickedFile.path);
      setState(() {
        _image = imageTemporary;
      });
      print("Image Picked");

      if (_image != null) {
        print("Sending Image");
        UIBlock.block(context);

        await uploadImage(_image!).then((value) {
          if (value != null) {
            UIBlock.unblock(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageSend(
                  person: detailPerson,
                  image: _image,
                  urlImage: value,
                  receiverID: int.parse(
                    _receiverId!,
                  ),
                ),
              ),
            ).then(getBackProsesKirim);
          } else {
            UIBlock.unblock(context);
          }
        });
      } else {
        UIBlock.unblock(context);
      }
    } catch (error) {
      printLog("error: $error");
    }
  }

  Future refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    getDetailChat();
    getListChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          AppLocalizations.of(context)!.translate("chat")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<DetailChatProvider>(builder: (context, value, child) {
        return RefreshIndicator(
          onRefresh: refreshData,
          child: Container(
            child: ada
                ? Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 65),
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              padding: const EdgeInsets.only(
                                  left: 15, top: 15, bottom: 5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.grey.withOpacity(0.08),
                                    offset: Offset(0, 0),
                                  )
                                ],
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: value.listChat.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              removeProductSelected();
                                              _receiverId = value
                                                  .listChat[index].receiverId;
                                              detailPerson =
                                                  value.listChat[index];
                                              chatId = int.parse(
                                                  value.listChat[index].id!);
                                              getListChat();
                                              getDetailChat();
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            padding: const EdgeInsets.all(2),
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: _receiverId ==
                                                      value.listChat[index]
                                                          .receiverId
                                                  ? tittleColor
                                                  : Colors.white,
                                              border: Border.all(
                                                  width: 1.5,
                                                  color: Colors.transparent),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(100),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                ImgStyle(
                                                  radius: 100,
                                                  url: value
                                                      .listChat[index].photo,
                                                ),
                                                value.listChat[index].unread !=
                                                        "0"
                                                    ? Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          child: Center(
                                                              child: Text(
                                                            value
                                                                .listChat[index]
                                                                .unread
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          120)),
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(height: 10),
                                        Container(
                                          width: 80,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: TextStyles(
                                            align: TextAlign.center,
                                            value: value
                                                .listChat[index].sellerName,
                                            size: 12,
                                            weight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            chatId == null
                                ? Flexible(
                                    child: Container(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/chat/chat.png',
                                          width: 130,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 35,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("ask_seller_about")!,
                                            style: TextStyle(
                                                color: tittleColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    )),
                                  )
                                : loadingChat == false
                                    ? Flexible(
                                        child: Center(
                                          child: spinDancing,
                                        ),
                                      )
                                    : Flexible(
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          itemCount: detailChat.length,
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 5),
                                          itemBuilder: (context, index) {
                                            return ListDetailChat(
                                              chat: detailChat[index],
                                            );
                                          },
                                        ),
                                      ),
                          ],
                        ),
                      ),
                      chatId == null
                          ? Container()
                          : Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: greyLine,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 6,
                                      color: Colors.grey.withOpacity(0.23),
                                      offset: Offset(0, 0),
                                    )
                                  ],
                                ),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _detailModalBottomSheet(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          child: Icon(MaterialIcons.image,
                                              color: accentColor),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          child: TextField(
                                            controller: text,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .translate("text_here"),
                                              hintStyle:
                                                  TextStyle(fontSize: 13),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      17, 5, 0, 5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (text.text == "") {
                                            snackBar(context,
                                                message: AppLocalizations.of(
                                                        context)!
                                                    .translate('write_a_msg')!,
                                                color: Colors.redAccent);
                                          } else {
                                            if (!loadingSend) {
                                              addText();
                                            }
                                          }
                                          // addText();
                                          // scrollToBottom();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          child: Icon(MaterialIcons.send,
                                              color: accentColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      _product == null
                          ? Container()
                          : Positioned(
                              bottom: 75,
                              left: 15,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        right: 30,
                                        top: 10,
                                        left: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            blurRadius: 4),
                                      ],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          child: ImgStyle(
                                            url: _product!.images![0].src,
                                            height: 60,
                                            width: 60,
                                            radius: 10,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 90,
                                              child: TextStyles(
                                                isLine: true,
                                                value: _product!.productName,
                                              ),
                                            ),
                                            Visibility(
                                              visible: _product!
                                                          .formattedSalePrice !=
                                                      null
                                                  ? true
                                                  : false,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                child: TextStyles(
                                                  size: 12,
                                                  color: mutedColor,
                                                  value:
                                                      _product!.formattedPrice,
                                                  lineThrough: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: TextStyles(
                                                size: 16,
                                                weight: FontWeight.bold,
                                                value: _product!
                                                            .formattedSalePrice !=
                                                        null
                                                    ? _product!
                                                        .formattedSalePrice
                                                    : _product!.formattedPrice,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 7,
                                    right: 7,
                                    child: GestureDetector(
                                      onTap: () {
                                        removeProductSelected();
                                      },
                                      child: Icon(Icons.close, size: 18),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ],
                  )
                : value.isLoading
                    ? Center(child: spinDancing)
                    : const ChatNotFound(),
          ),
        );
      }),
    );
  }
}
