part of '../pages.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final controller = PageController();
  int pageIndex = 0;
  int page = 1;
  ScrollController _scrollController = new ScrollController();

  void initState() {
    final blogs = Provider.of<BlogProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          print("scrolling");
          if (blogs.listBlog.length % 4 == 0) {
            print("abc");
            setState(() {
              page++;
            });
            print('page $page');
            _getList();
          }
        }
      });

      _getList();
      // final dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.ssssssZ")
      //     .parse("2021-01-03T18:42:49.608466Z");
      // print(dt);
    });
  }

  _reset(dynamic newValue) {
    Provider.of<BlogProvider>(context, listen: false).reset();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getList() async {
    Provider.of<BlogProvider>(context, listen: false)
        .getListBlog(context, page: page);
  }

  Widget build(BuildContext context) {
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
          AppLocalizations.of(context)!.translate('title_blog')!,
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
        child: Consumer<BlogProvider>(builder: (context, value, child) {
          return Container(
            margin: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      bottom: value.loadMore && page != 1 ? 30 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 15,
                      ),
                      TextStyles(
                        value: AppLocalizations.of(context)!
                            .translate("read_blog"),
                        color: accentColor,
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 20),
                        child: Stack(
                          children: [
                            AspectRatio(
                              child: PageView(
                                controller: controller,
                                children: [
                                  for (var i = 0;
                                      i < value.blogBanner.length;
                                      i++)
                                    CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: value.blogBanner[i].image!,
                                      placeholder: (context, url) =>
                                          customLoading(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                ],
                                onPageChanged: (index) {
                                  setState(() {
                                    pageIndex = index;
                                  });
                                },
                              ),
                              aspectRatio: 1 / 0.7,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: value.listBlog.length,
                          itemBuilder: (BuildContext context, int index) {
                            var result = value.listBlog[index];
                            return Container(
                                margin: EdgeInsets.only(top: 12),
                                child: Stack(
                                  children: [
                                    Material(
                                      child: InkWell(
                                        onTap: () {
                                          value.getDetailBlog(context,
                                              id: result.id.toString());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailBlog(
                                                id: result.id,
                                              ),
                                            ),
                                          ).then(_reset);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 12),
                                                width: 128,
                                                height: 104,
                                                color: Colors.grey,
                                                child: result.blogImages != null
                                                    ? ImgStyle(
                                                        url: result
                                                            .blogImages![0]
                                                            .srcImg,
                                                        height: 104,
                                                        width: 128,
                                                        radius: 0,
                                                      )
                                                    : Container(),
                                              ),
                                              Expanded(
                                                // color: Colors.red,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextStyles(
                                                      value: dateFormater(
                                                          date: result.date!),
                                                      size: 10,
                                                      color: mutedColor,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top: 15,
                                                        bottom: 8,
                                                      ),
                                                      child: Text(
                                                        result.title!,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    TextStyles(
                                                      value:
                                                          "${AppLocalizations.of(context)!.translate("by")} ${result.author}",
                                                      size: 10,
                                                      color: mutedColor,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (value.loadMore && page != 1)
                  Positioned(
                    bottom: 0,
                    child: customLoading(),
                    left: 0,
                    right: 0,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
