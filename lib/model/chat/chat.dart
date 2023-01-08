import 'dart:io';

import 'package:flutter/cupertino.dart';

class ChatMessage with ChangeNotifier {
  String? messageContent;
  String? messageType;
  File? image;
  ChatMessage({this.messageContent, this.messageType, this.image});
}
