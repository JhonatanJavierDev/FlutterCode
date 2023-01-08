import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:intl/intl.dart';
import 'package:catalinadev/model/chat/detail_chat_model.dart';
import 'package:catalinadev/utils/shared.dart';
import 'package:catalinadev/utils/utility.dart';
import 'package:catalinadev/widget/widget.dart';

class ListDetailChat extends StatelessWidget {
  final ChatDetail? chat;
  const ListDetailChat({Key? key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var time = DateFormat('yyyy-MM-dd HH:mm:ss').parse(chat!.createdAt!);
    return Column(
      children: [
        chat!.subject!.length == 0
            ? SizedBox()
            : Container(
                padding: EdgeInsets.only(left: 14, right: 14, top: 10),
                child: Align(
                  alignment: (chat!.potition == "left"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.56,
                    padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4),
                            ],
                            border: Border.all(color: tittleColor),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: chat!.potition == "left"
                                  ? Radius.circular(0)
                                  : Radius.circular(10),
                              topRight: chat!.potition == "left"
                                  ? Radius.circular(10)
                                  : Radius.circular(0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return DetailScreen(
                                          image: chat!.subject![0]
                                              .productImages![0].src,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child:
                                          chat!.subject![0].productImages?[0] !=
                                                  null
                                              ? ImgStyle(
                                                  url: chat!.subject![0]
                                                      .productImages?[0].src,
                                                  height: 60,
                                                  width: 60,
                                                  radius: 10,
                                                )
                                              : Icon(Icons.image_not_supported,
                                                  size: 60),
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
                                          value: chat!.subject![0]
                                                      .productName ==
                                                  null
                                              ? 'Not Available'
                                              : chat!.subject![0].productName,
                                          size: 12,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: TextStyles(
                                          size: 14,
                                          weight: FontWeight.bold,
                                          value: convertHtmlUnescape(chat!
                                                      .subject![0]
                                                      .productFormattedPrice ==
                                                  null
                                              ? 'Not Available'
                                              : chat!.subject![0]
                                                  .productFormattedPrice!),
                                        ),
                                      ),
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
                                                  (BuildContext context,
                                                      int index) {
                                                return Icon(
                                                  MaterialCommunityIcons
                                                      .star_outline,
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
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                child: MaterialButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  color: chat!.subject![0].productId != null
                                      ? accentColor
                                      : Colors.grey,
                                  onPressed: () {
                                    if (chat!.subject![0].productId != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailProductScreen(
                                            id: chat!.subject![0].productId
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    } else {
                                      // ignore: unnecessary_statements
                                      null;
                                    }
                                  },
                                  child: TextStyles(
                                      value: AppLocalizations.of(context)!
                                          .translate("add_cart")!,
                                      size: 12,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        chat!.message!.length == 0 && chat!.image == null
            ? SizedBox()
            : Container(
                padding: EdgeInsets.only(
                    left: 14,
                    right: 14,
                    top: chat!.subject!.length == 0 ? 10 : 3),
                child: Align(
                  alignment: (chat!.potition == "left"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: chat!.potition == "left"
                            ? Radius.circular(0)
                            : Radius.circular(10),
                        topRight: chat!.potition == "left"
                            ? Radius.circular(10)
                            : Radius.circular(0),
                      ),
                      color: (chat!.potition == "left"
                          ? greyLine
                          : Color(0xFF1565C0)),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                    child: Column(
                      crossAxisAlignment: chat!.potition == "left"
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        chat!.image != null
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return DetailScreen(
                                      image: chat!.image,
                                    );
                                  }));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: CachedNetworkImage(
                                    imageUrl: chat!.image!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    placeholder: (context, url) =>
                                        customLoading(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              )
                            : Text(
                                chat!.message!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: chat!.potition == "left"
                                        ? Colors.black
                                        : Colors.white),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextStyles(
                            value:
                                '${time.hour}:${time.minute.toString().length == 1 ? "0${time.minute}" : time.minute}',
                            size: 10,
                            color: chat!.potition == "left"
                                ? Colors.black
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
