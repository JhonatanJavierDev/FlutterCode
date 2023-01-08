part of '../pages.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  int page = 1;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    final wl = Provider.of<WishlistProvider>(context, listen: false);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (wl.listWishList.length % 8 == 0 && !wl.loadingWL!) {
          setState(() {
            page++;
          });
          _getWishList();
        }
      }
    });
    _getWishListId();
  }

  void _getWishListId() async {
    Provider.of<WishlistProvider>(context, listen: false).getProductWishlist();
  }

  void _getWishList() async {
    this.setState(() {});
    Provider.of<WishlistProvider>(context, listen: false)
        .getListWishlist(page)
        .then((value) => this.setState(() {}));
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
            AppLocalizations.of(context)!.translate("my_wish")!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Consumer<WishlistProvider>(
          builder: (context, value, child) {
            if (value.loadingWL! && page == 1) {
              return ShimmerGridListProduct(
                isManageProduct: false,
              );
            }
            if (value.listWishList.length == 0) {
              return Center(
                  child: Container(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/myOrder/no_data.png',
                          width: 220),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextStyles(
                          value: AppLocalizations.of(context)!
                              .translate("no_wishlist")!,
                          weight: FontWeight.bold,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                ),
              ));
            } else {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridListProduct(
                        isWishlist: true,
                        isManageProduct: false,
                        favorite: true,
                        discount: true,
                        listProduct: value.listWishList,
                      ),
                      if (value.loadingWLProduct! && page != 1) customLoading()
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }
}
