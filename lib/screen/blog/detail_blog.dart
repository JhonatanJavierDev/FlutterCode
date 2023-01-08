part of '../pages.dart';

class DetailBlog extends StatefulWidget {
  final int? id;
  final String? slug;
  DetailBlog({this.id, this.slug});
  @override
  _DetailBlogState createState() => _DetailBlogState();
}

class _DetailBlogState extends State<DetailBlog> {
  TextEditingController comment = TextEditingController();
  final controller = PageController();
  int pageIndex = 0;

  BlogListModel? blogModel;

  @override
  void initState() {
    super.initState();
    loadDetail();

    //_getComment();
  }

  _getComment() async {
    Provider.of<BlogProvider>(context, listen: false)
        .getComment(context, id: widget.id);
  }

  loadDetail() async {
    if (widget.slug == null) {
      print("masuk tanpa slug");
      await Provider.of<BlogProvider>(context, listen: false)
          .getDetailBlog(context, id: widget.id.toString())
          .then((value) {
        setState(() {});
        _getComment();
      });
    } else {
      print("masuk pakai slug : ${widget.slug.toString()}");
      await Provider.of<BlogProvider>(context, listen: false)
          .getDetailBlogBySlug(context, slug: widget.slug)
          .then((value) {
        setState(() {});
        _getComment();
      });
    }
  }

  Widget build(BuildContext context) {
    final blog = Provider.of<BlogProvider>(context).blogDetail;
    final blogProv = Provider.of<BlogProvider>(context, listen: false);
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () {
              shareLinks('blog', blog!.link);
            },
          )
        ],
      ),
      body: blogProv.loading
          ? customLoading()
          : SingleChildScrollView(
              child: Consumer<BlogProvider>(builder: (context, value, child) {
                return value.loading
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(child: spinDancing),
                      )
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 271,
                              color: Colors.grey,
                              child: value.blogDetail!.blogImages != null
                                  ? Stack(
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
                                                  imageUrl: value.blogDetail!
                                                      .blogImages![0].srcImg!,
                                                  placeholder: (context, url) =>
                                                      customLoading(),
                                                  errorWidget:
                                                      (context, url, error) =>
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
                                    )
                                  : Container(),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Text(
                                value.blogDetail!.title!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 15, 15),
                              child: Html(data: value.blogDetail!.content),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 2, 15, 15),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 14),
                                    child: ImgStyle(
                                      url: value.blogDetail!.authorAvatar,
                                      width: 55,
                                      height: 55,
                                      radius: 100,
                                    ),
                                  ),
                                  TextStyles(
                                    value: value.blogDetail!.author,
                                    weight: FontWeight.bold,
                                    size: 14,
                                  ),
                                  Spacer(),
                                  TextStyles(
                                    value: dateFormater(
                                        date: value.blogDetail!.date!),
                                    size: 12,
                                    color: Colors.grey.shade400,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Wrap(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 13, top: 8),
                                    child: Image.asset(
                                      'assets/images/account/tag-multiple.png',
                                      width: 25,
                                    ),
                                  ),
                                  for (var i = 0;
                                      i <
                                          value.blogDetail!.blogCategories!
                                              .length;
                                      i++)
                                    chipBorder(value.blogDetail!
                                        .blogCategories![i].categoryName!),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 17, horizontal: 15),
                              child: Line(
                                color: greyLine,
                                height: 1,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: TextStyles(
                                value:
                                    "${value.commentList.length} ${AppLocalizations.of(context)!.translate("comment")!} :",
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 17,
                              ),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: value.commentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var result = value.commentList[index];
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 14),
                                            child: ImgStyle(
                                              url: result.authorAvatar,
                                              width: 55,
                                              height: 55,
                                              radius: 100,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextStyles(
                                                value: result.authorName,
                                                weight: FontWeight.bold,
                                                size: 14,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          TextStyles(
                                            value: dateFormater(
                                                date: result.date!),
                                            size: 12,
                                            color: Color(0xFF1565C0),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Html(style: {
                                          "body": Style(
                                              margin: EdgeInsets.only(left: 66),
                                              padding: EdgeInsets.all(0))
                                        }, data: """${result.content}"""),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            if (Session.data.getBool('isLogin')!)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: TextStyles(
                                      value: AppLocalizations.of(context)!
                                          .translate("leave_comment")!,
                                      size: 14,
                                      weight: FontWeight.bold,
                                      color: accentColor,
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.yellow,
                                    margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: Container(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          textSelectionTheme:
                                              TextSelectionThemeData(
                                                  cursorColor: Colors.white),
                                          hintColor: Colors.transparent,
                                        ),
                                        child: TextFormField(
                                          controller: comment,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 5,
                                          maxLength: 1000,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(

                                              // contentPadding: EdgeInsets.only(left: 20, top: 20),
                                              focusedBorder: border,
                                              border: border,
                                              hintStyle: TextStyle(
                                                  color: Colors.black26),
                                              labelStyle: TextStyle(
                                                  fontFamily: 'Brandon',
                                                  color: Colors.black),
                                              filled: true,
                                              fillColor: Color(0xFFFAFAFA),
                                              hintText: AppLocalizations.of(
                                                      context)!
                                                  .translate("comment_here")!),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      // color: Colors.red,
                                      margin: EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: MaterialButton(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          color: accentColor,
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            if (comment.text.isNotEmpty) {
                                              value.sendComment(context,
                                                  comment: comment.text);
                                            }
                                            setState(() {
                                              comment.text = '';
                                            });
                                          },
                                          child: Container(
                                            child: TextStyles(
                                              value:
                                                  AppLocalizations.of(context)!
                                                      .translate("comment")!,
                                              weight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              )
                          ],
                        ),
                      );
              }),
            ),
    );
  }
}
