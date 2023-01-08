import 'package:flutter/material.dart';


class Categories with ChangeNotifier {
  String? categories;
  String? catIcon;
  String? description;
  List<Sub>? sub;

  Categories({this.categories, this.description, this.sub, this.catIcon});

  Categories.fromJson(Map<String, dynamic> json) {
    categories = json['categories'];
    catIcon = json['cat_icon'];
    description = json['description'];
    if (json['sub'] != null) {
      sub = [];
      json['sub'].forEach((v) {
        sub!.add(new Sub.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categories'] = this.categories;
    data['cat_icon'] = this.catIcon;
    data['description'] = this.description;
    if (this.sub != null) {
      data['sub'] = this.sub!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sub {
  String? icon;
  String? iconTittle;
  bool? status;

  Sub({this.icon, this.iconTittle, this.status});

  Sub.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    iconTittle = json['icon_tittle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['icon_tittle'] = this.iconTittle;
    return data;
  }
}
