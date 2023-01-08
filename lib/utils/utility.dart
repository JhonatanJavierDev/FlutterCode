import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:catalinadev/utils/shared.dart';
import 'package:share_plus/share_plus.dart';

printLog(String message, {String? name}) {
  return log(message, name: name ?? 'log');
}

snackBar(context,
    {required String message,
    Color? color,
    int duration = 2,
    TextStyle? textStyle}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: textStyle,
    ),
    backgroundColor: color != null ? color : null,
    duration: Duration(seconds: duration),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

customLoading({Color? color, double size = 20.0}) {
  final spinKit = SpinKitRotatingCircle(
    color: color != null ? color : accentColor,
    size: size,
  );
  return spinKit;
}

convertHtmlUnescape(String textCharacter) {
  var unescape = HtmlUnescape();
  var text = unescape.convert(textCharacter);
  return text;
}

shareLinks(String type, String? url) {
  return Share.share("Let's see our $type, click me $url !");
}
