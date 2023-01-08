import 'package:flutter/material.dart';

class Language with ChangeNotifier {
  String? region;
  String? flag;
  String? codeRegion;
  bool? status;

  Language({this.region, this.flag, this.codeRegion, this.status = false});

  Language.fromJson(Map<String, dynamic> json) {
    region = json['region'];
    flag = json['flag'];
    codeRegion = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['region'] = this.region;
    data['flag'] = this.flag;
    data['code'] = this.codeRegion;
    data['status'] = this.status;
    return data;
  }
}
