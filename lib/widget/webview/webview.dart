import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:catalinadev/utils/utility.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final url;
  final String? title;

  WebViewScreen({Key? key, this.url, this.title}) : super(key: key);
  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  bool isLoading = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title!,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(children: [
        WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onProgress: (int progress) {
            if (progress != 100) {
              setState(() {
                isLoading = true;
              });
            } else {
              setState(() {
                isLoading = false;
              });
            }
          },
          onWebViewCreated: (WebViewController webViewController) async {
            webViewController = webViewController;
            _controller.complete(webViewController);
          },
        ),
        isLoading
            ? Center(
                child: customLoading(),
              )
            : Stack(),
      ]),
    );
  }
}
