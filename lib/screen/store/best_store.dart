part of '../pages.dart';

class BestStoreScreen extends StatefulWidget {
  @override
  _BestStoreScreenState createState() => _BestStoreScreenState();
}

class _BestStoreScreenState extends State<BestStoreScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Provider.of<StoreProvider>(context, listen: false)
        .fetchBestStore(context, 10);
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
            AppLocalizations.of(context)!.translate('best_store')!,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListenableProvider.value(
                value: store,
                child:
                    Consumer<StoreProvider>(builder: (context, value, child) {
                  if (value.loadingBestStore) {
                    return Container(
                      child: ShimmerAllStoreList(),
                    );
                  }
                  return Container(
                      child: AllStoreList(
                    isBest: true,
                  ));
                }),
              ),
            ],
          ),
        ));
  }
}
