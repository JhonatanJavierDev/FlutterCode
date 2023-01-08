part of '../pages.dart';

class TermCondition extends StatefulWidget {
  final String? type;
  TermCondition({this.type});
  @override
  _TermConditionState createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late WebViewController _webViewController;
  bool isLoading = true;

  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final terms =
        Provider.of<HomeProvider>(context, listen: false).termCondition;
    final privacy = Provider.of<HomeProvider>(context, listen: false).policy;

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
          widget.type == 'term'
              ? AppLocalizations.of(context)!.translate("term_cond")!
              : AppLocalizations.of(context)!.translate("privacy_police")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.type == 'term' ? terms : privacy,
            javascriptMode: JavascriptMode.unrestricted,
            onProgress: (int progress) {
              print("WebView is loading (progress : $progress%)");

              _webViewController.runJavascript(
                  "document.getElementById('headerwrap').style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementById('footerwrap').style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByTagName('header')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByTagName('footer')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('return-to-shop')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('page-title')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('woocommerce-error')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('woocommerce-breadcrumb')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('useful-links')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('widget woocommerce widget_product_search')[1].style.display= 'none';");
            },
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
              _controller.complete(webViewController);
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
              setState(() {
                isLoading = false;
              });
              _webViewController.runJavascript(
                  "document.getElementById('headerwrap').style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementById('footerwrap').style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByTagName('header')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByTagName('footer')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('return-to-shop')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('page-title')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('woocommerce-error')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('woocommerce-breadcrumb')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('useful-links')[0].style.display= 'none';");
              _webViewController.runJavascript(
                  "document.getElementsByClassName('widget woocommerce widget_product_search')[1].style.display= 'none';");
            },
            gestureNavigationEnabled: true,
          ),
          isLoading
              ? Center(
                  child: customLoading(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
