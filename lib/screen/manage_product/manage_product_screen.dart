part of '../pages.dart';

class ManageProductScreen extends StatefulWidget {
  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  bool isData = false;
  ScrollController _scrollController = new ScrollController();
  int page = 1;

  @override
  void initState() {
    var product = Provider.of<StoreProvider>(context, listen: false);

    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (product.listOwnProducts.length % 8 == 0 &&
            !product.loadingStoreProduct) {
          setState(() {
            page++;
          });
          loadProductStore();
        }
      }
    });
    loadProductStore();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  Future loadProductStore() async {
    this.setState(() {});
    await Provider.of<StoreProvider>(context, listen: false)
        .fetchOwnProducts(page)
        .then((value){
          if (mounted)
            this.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);
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
          AppLocalizations.of(context)!.translate("manage_product")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: store.listOwnProducts.isEmpty && !store.loadingStoreProduct
          ? Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/myOrder/no_data.png',
                        width: 260),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 20),
                      child: Container(
                        width: 300,
                        child: TextStyles(
                          value: AppLocalizations.of(context)!
                              .translate("product_not_found"),
                          weight: FontWeight.bold,
                          size: 16,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      width: 140,
                      // padding: EdgeInsets.symmetric(horizontal: 20),
                      child: MaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: EdgeInsets.all(0),
                        elevation: 0,
                        color: accentColor,
                        onPressed: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductScreen(),
                            ),
                          );
                          if (result == '200') loadProductStore();
                        },
                        child: Container(
                            child: TextStyles(
                          value: AppLocalizations.of(context)!
                              .translate("add_new_product"),
                          color: Colors.white,
                          size: 12,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Consumer<StoreProvider>(
                              builder: (context, value, child) {
                            if (value.loadingStoreProduct && page == 1) {
                              return ShimmerGridListProduct(
                                isManageProduct: false,
                              );
                            }
                            return Container(
                              color: Colors.white,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(14, 0, 14, 60),
                                child: GridListProduct(
                                  isManageProduct: true,
                                  listProduct: value.listOwnProducts,
                                  refresh: loadProductStore,
                                ),
                              ),
                            );
                          }),
                          if (store.loadingStoreProduct && page != 1)
                            customLoading()
                        ],
                      )),
                ),
                Visibility(
                  visible: !store.loadingStoreProduct,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.grey.withOpacity(0.23),
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    width: double.infinity,
                    height: 60,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      width: 100,
                      height: 30,
                      child: MaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        color: accentColor,
                        onPressed: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductScreen(),
                            ),
                          );
                          if (result == '200') loadProductStore();
                        },
                        child: Container(
                            child: TextStyles(
                          value: AppLocalizations.of(context)!
                              .translate("add_new_product"),
                          color: Colors.white,
                          size: 12,
                        )),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
