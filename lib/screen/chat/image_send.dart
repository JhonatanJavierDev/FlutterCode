part of '../pages.dart';

class ImageSend extends StatefulWidget {
  final File? image;
  final ProductImage? urlImage;
  final int? receiverID;
  final ListChat? person;

  ImageSend({this.image, this.urlImage, this.receiverID, this.person});

  @override
  _ImageSendState createState() => _ImageSendState();
}

class _ImageSendState extends State<ImageSend> {
  @override
  void initState() {
    super.initState();
    imageSend = false;
  }

  void addText() async {
    FocusScope.of(context).unfocus();
    Provider.of<DetailChatProvider>(context, listen: false)
        .sendMessage(
      receiverId: widget.receiverID.toString(),
      postID: widget.receiverID.toString(),
      urlImage: widget.urlImage!.image,
    )
        .then(
      (value) {
        print(value);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.18),
        leading: IconButton(
          onPressed: () {
            imageSend = false;
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 18,
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 8),
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: greyLine,
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: ImgStyle(
                url: widget.person!.photo,
                height: 35,
                radius: 100,
              ),
            ),
            TextStyles(
              value: widget.person!.sellerName,
              size: 14,
              weight: FontWeight.bold,
              color: Colors.black,
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.file(
                  widget.image!,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Positioned(
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
              child: GestureDetector(
                onTap: () {
                  addText();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(16),
                  child: Icon(MaterialIcons.send, color: accentColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
