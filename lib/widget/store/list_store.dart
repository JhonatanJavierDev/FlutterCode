part of '../widget.dart';

// All Store List
class AllStoreList extends StatefulWidget {
  final bool isBest;
  const AllStoreList({Key? key, this.isBest = false}) : super(key: key);

  @override
  _AllStoreListState createState() => _AllStoreListState();
}

class _AllStoreListState extends State<AllStoreList> {
  @override
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    var size = MediaQuery.of(context).size;
    var list;

    if (widget.isBest) {
      list = store.bestStoreAll;
    } else {
      list = store.stores;
    }

    final double itemHeight = 270;
    final double itemWidth = size.width / 2;

    return Container(
      margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (itemWidth / itemHeight),
          crossAxisCount: 2,
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(-1, 0),
                    color: Colors.grey.withOpacity(0.40),
                    blurRadius: 3)
              ],
            ),
            margin: EdgeInsets.fromLTRB(4, 12, 4, 12),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailStoreScreen(
                              id: list[index].id,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 140,
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: list[index].icon,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => customLoading(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: ImageIcon(
                              AssetImage(
                                  'assets/images/home/fluent_store-microsoft-16-filled.png'),
                              size: 18,
                              color: accentColor,
                            ),
                          ),
                          Container(
                            width: 115,
                            child: MarqueeWidget(
                              direction: Axis.horizontal,
                              child: Text(
                                list[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: list[index].averageRating.toDouble(),
                                itemSize: 20,
                                itemCount: 5,
                                unratedColor: Colors.grey,
                                itemBuilder: (context, index) {
                                  return Icon(
                                    MaterialCommunityIcons.star,
                                    size: 20,
                                    color: Colors.orange,
                                  );
                                },
                              ),
                              /*Container(
                                width: 80,
                                height: 20,
                                margin: EdgeInsets.only(right: 2),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Icon(
                                      FlutterIcons.star_outline_mco,
                                      size: 15,
                                      color: Colors.orange,
                                    );
                                  },
                                ),
                              ),*/
                              /*Text(
                                "(${list[index].ratingCount})",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    child: MarqueeWidget(
                      direction: Axis.horizontal,
                      child: TextStyles(
                        value: list[index].address,
                        size: 12,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// All Store List
class ShimmerAllStoreList extends StatelessWidget {
  const ShimmerAllStoreList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = 270;
    final double itemWidth = size.width / 2;
    return Container(
      margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (itemWidth / itemHeight),
          crossAxisCount: 2,
        ),
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              width: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(-1, 0),
                      color: Colors.grey.withOpacity(0.40),
                      blurRadius: 3)
                ],
              ),
              margin: EdgeInsets.fromLTRB(4, 12, 4, 12),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: null,
                      child: Container(
                        height: 140,
                        child: ClipRRect(
                            child: Container(
                          color: Colors.white,
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            width: 20,
                            height: 15,
                            color: Colors.white,
                          ),
                          Container(
                            width: 50,
                            height: 15,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 20,
                                margin: EdgeInsets.only(right: 2),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Icon(
                                      MaterialCommunityIcons.star_outline,
                                      size: 15,
                                      color: Colors.orange,
                                    );
                                  },
                                ),
                              ),
                              Text(
                                "(0)",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Container(
                              width: 50,
                              height: 12,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
