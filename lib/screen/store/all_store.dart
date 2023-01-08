part of '../pages.dart';

class AllStoreScreen extends StatefulWidget {
  @override
  _AllStoreScreenState createState() => _AllStoreScreenState();
}

class _AllStoreScreenState extends State<AllStoreScreen> {
  TextEditingController search = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  int page = 1;
  int cekReset = 0;
  bool cancel = false;

  @override
  void initState() {
    final stores = Provider.of<StoreProvider>(context, listen: false);
    super.initState();
    stores.resetAllStore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (stores.listStoreProducts.length % 8 == 0) {
          setState(() {
            page++;
          });
          loadData();
        }
      }
    });
    loadData();
  }

  loadData({int? reset}) async {
    await Provider.of<StoreProvider>(context, listen: false).fetchAllStore(
        context,
        search: search.text.toString(),
        page: page,
        cekReset: reset);
  }

  removeData() async {
    await Provider.of<StoreProvider>(context, listen: false).resetAllStore();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);

    return Scaffold(
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
          AppLocalizations.of(context)!.translate("all_store")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: ListenableProvider.value(
                value: store,
                child:
                    Consumer<StoreProvider>(builder: (context, value, child) {
                  if (value.loadingAllStore) {
                    return Container(
                      child: ShimmerAllStoreList(),
                    );
                  }
                  return Container(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              bottom: value.loadMore && page != 1 ? 30 : 0),
                          child: AllStoreList(),
                        ),
                        if (value.loadMore && page != 1)
                          Positioned(
                            bottom: 5,
                            child: customLoading(),
                            left: 0,
                            right: 0,
                          )
                      ],
                    ),
                  );
                }),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5, color: Colors.grey.withOpacity(0.23))
                  ]),
              height: 40,
              margin: EdgeInsets.fromLTRB(14, 15, 14, 5),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: search,
                onSubmitted: (value) {
                  this.setState(() {
                    page = 1;
                    cekReset = 1;
                  });
                  if (search.text.toString() == "") {
                    removeData();
                  }
                  loadData(reset: cekReset);
                },
                onTap: () {
                  setState(() {
                    cancel = true;
                  });
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: search.text.isNotEmpty
                          ? Colors.redAccent
                          : Colors.transparent,
                    ),
                    onPressed: () {
                      this.setState(() {
                        page = 1;
                        search.text = "";
                      });
                      if (search.text.toString() == "") {
                        removeData();
                      }
                      loadData();
                    },
                  ),
                  prefixIcon: Container(
                    child: Icon(
                      EvilIcons.search,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  hintText:
                      AppLocalizations.of(context)!.translate("search_store"),
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E9E9E),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(17, 5, 0, 5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
