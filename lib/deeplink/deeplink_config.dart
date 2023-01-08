import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catalinadev/screen/intro/splash_screen.dart';
import 'package:catalinadev/screen/pages.dart';
import 'package:catalinadev/services/mv_notification.dart';
import 'package:catalinadev/utils/global_variable.dart';
import 'package:catalinadev/utils/utility.dart';
import 'package:catalinadev/widget/widget.dart';
import 'package:uni_links/uni_links.dart';

class DeeplinkConfig {
  Future Function()? onLinkClicked;
  Future<Widget> initUniLinks(BuildContext context) async {
    Widget screen = SplashScreen();
    try {
      String? initialLink = await getInitialLink();
      print(initialLink);
      if (initialLink != null) {
        Uri uri = Uri.parse(initialLink);
        print(uri);
        printLog('Deeplink Exists!', name: 'Deeplink');
        pathUrl(uri, context, true);
        screen = SplashScreen(
          onLinkClicked: onLinkClicked,
        );
      }
      if (selectedNotificationPayload != null) {
        var _payload = json.decode(selectedNotificationPayload!);
        if (_payload['type'] == 'order') {
          onLinkClicked = () async => await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NotificationScreen()));
        } else if (_payload['type'] == 'chat') {
          onLinkClicked =
              () async => await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatHomeScreen(
                        receiverId: _payload['id'],
                      )));
        } else {
          print("Else");
          Uri uri = Uri.parse(_payload['click_action']);
          pathUrl(uri, context, true);
        }
        screen = SplashScreen(
          onLinkClicked: onLinkClicked,
        );
      }
    } on PlatformException {
      print("Error");
    }
    return screen;
  }

  pathUrl(Uri uri, BuildContext context, bool fromLaunchApp) async {
    /*Shop (Detail Product)*/
    if (uri.pathSegments[0] == "shop" || uri.pathSegments[0] == "product") {
      if (uri.pathSegments[1].isNotEmpty) {
        print("Detalles del Producto");
        if (fromLaunchApp) {
          onLinkClicked = () async => await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DetailProductScreen(
                        slug: uri.pathSegments[1],
                      )));
        } else {
          await Navigator.of(GlobalVariable.navState.currentContext!)
              .push(MaterialPageRoute(
                  builder: (context) => DetailProductScreen(
                        slug: uri.pathSegments[1],
                      )));
        }
      }
    }

    /*Blog (Detail Blog)*/
    if (uri.pathSegments[0] == "artikel" ||
        uri.pathSegments[0] == "articles" ||
        uri.pathSegments[0] == "blog" ||
        uri.pathSegments[0] == "blogs" ||
        uri.pathSegments[0] == "post") {
      if (uri.pathSegments[1].isNotEmpty) {
        print("Detalles del Blog");
        debugPrint(uri.toString());
        debugPrint(uri.pathSegments[0]);
        debugPrint(uri.pathSegments[1]);
        if (fromLaunchApp) {
          onLinkClicked = () async => await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DetailBlog(
                        slug: uri.pathSegments[1],
                      )));
        } else {
          await Navigator.of(GlobalVariable.navState.currentContext!)
              .push(MaterialPageRoute(
                  builder: (context) => DetailBlog(
                        slug: uri.pathSegments[1],
                      )));
        }
      }
    }
  }
}
