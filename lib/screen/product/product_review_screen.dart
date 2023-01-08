import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:catalinadev/model/product/product_review_model.dart';
import 'package:catalinadev/provider/product_provider.dart';
import 'package:catalinadev/utils/shared.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductReview extends StatefulWidget {
  final String? productId;
  ProductReview({Key? key, this.productId}) : super(key: key);

  @override
  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  int currentIndex = 0;

  int countAll = 0;
  int countOneStar = 0;
  int countTwoStar = 0;
  int countThreeStar = 0;
  int countFourStar = 0;
  int countFiveStar = 0;

  List<ProductReviewModel> listReview = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    final review = Provider.of<ProductProvider>(context, listen: false);
    await Provider.of<ProductProvider>(context, listen: false)
        .loadAllReviewProduct(widget.productId, page: 1, perPage: 100)
        .then((value) {
      setState(() {
        listReview = review.listReviewAllStar;

        countAll = review.listReviewAllStar.length;
        countOneStar = review.listReviewOneStar.length;
        countTwoStar = review.listReviewTwoStar.length;
        countThreeStar = review.listReviewThreeStar.length;
        countFourStar = review.listReviewFourStar.length;
        countFiveStar = review.listReviewFiveStar.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final review = Provider.of<ProductProvider>(context, listen: false);
    Widget buildReview = Container(
      child: ListenableProvider.value(
        value: review,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          if (value.isLoadingReview) {
            return ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      commentShimmer(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        color: greyText,
                        width: double.infinity,
                        height: 2,
                      ),
                    ],
                  );
                });
          }
          if (listReview.isEmpty) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 48,
                    color: tittleColor,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .translate("no_review_product")!,
                  )
                ],
              ),
            );
          }
          return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: listReview.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    comment(
                        listReview[i].reviewer!,
                        listReview[i].review!,
                        listReview[i].rating,
                        listReview[i].dateCreated,
                        listReview[i].avatar),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      color: Colors.grey[100],
                      width: double.infinity,
                      height: 2,
                    ),
                  ],
                );
              });
        }),
      ),
    );

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.translate("all_review")!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            firstPart(),
            Expanded(
              child: buildReview,
            )
          ],
        ),
      ),
    );
  }

  Widget comment(String name, String comment, int? starGoldItem, String? date,
      String? avatar) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ImgStyle(
              url: avatar,
              width: 60,
              height: 60,
              radius: 5,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.circle,
                      size: 5,
                    ),
                    starGold(starGoldItem),
                  ],
                ),
                comment.isEmpty
                    ? Container()
                    : Container(
                        child: Html(style: {
                          "body": Style(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              fontSize: FontSize.small)
                        }, data: """$comment"""),
                      ),
                /*item == 0
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50.h,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return Container(
                                height: 50.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                    color: HexColor("c4c4c4"),
                                    borderRadius: BorderRadius.circular(5)),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                width: 5,
                              );
                            },
                            itemCount: item),
                      ),*/
                /*Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(date,
                    style: TextStyle(fontSize: 8.sp),
                  ),
                ),*/
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget firstPart() {
    final review = Provider.of<ProductProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 5),
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
          if (currentIndex == 0) {
            setState(() {
              listReview = review.listReviewAllStar;
            });
          } else if (currentIndex == 1) {
            setState(() {
              listReview = review.listReviewFiveStar;
            });
          } else if (currentIndex == 2) {
            setState(() {
              listReview = review.listReviewFourStar;
            });
          } else if (currentIndex == 3) {
            setState(() {
              listReview = review.listReviewThreeStar;
            });
          } else if (currentIndex == 4) {
            setState(() {
              listReview = review.listReviewTwoStar;
            });
          } else if (currentIndex == 5) {
            setState(() {
              listReview = review.listReviewOneStar;
            });
          }
        },
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border.all(color: tittleColor),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        tabs: [
          tabStyle(
              0,
              Text(
                AppLocalizations.of(context)!.translate("all")!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
              countAll),
          tabStyle(1, starGold(5), countFiveStar),
          tabStyle(2, starGold(4), countFourStar),
          tabStyle(3, starGold(3), countThreeStar),
          tabStyle(4, starGold(2), countTwoStar),
          tabStyle(5, starGold(1), countOneStar),
        ],
      ),
    );
  }

  Widget starGold(int? starCount) {
    return Container(
      height: 20.h,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: starCount,
          itemBuilder: (context, i) {
            return Container(
                width: 12.w,
                height: 15.h,
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 15,
                ));
          }),
    );
  }

  Widget tabStyle(int index, Widget title, int total) {
    return Container(
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.transparent : Colors.grey[100],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title,
          SizedBox(
            width: 5.w,
          ),
          Text("($total)",
              style: TextStyle(
                fontSize: 10.sp,
                color: currentIndex == index ? tittleColor : Colors.black,
              ))
        ],
      ),
    );
  }

  Widget commentShimmer() {
    return Shimmer.fromColors(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 80,
                      color: Colors.white,
                    ),
                    starGold(5),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 10,
                      width: 120,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!);
  }
}
