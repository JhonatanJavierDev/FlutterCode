class EpekenShippingModel {
  bool? activePlugin;
  List<City>? city;
  List<Service>? service;

  EpekenShippingModel({this.activePlugin, this.city, this.service});

  EpekenShippingModel.fromJson(Map<String, dynamic> json) {
    activePlugin = json['active_plugin'];
    if (json['city'] != null) {
      city = new List<City>.empty(growable: true);
      json['city'].forEach((v) {
        city!.add(new City.fromJson(v));
      });
    }
    if (json['service'] != null) {
      service = new List<Service>.empty(growable: true);
      json['service'].forEach((v) {
        service!.add(new Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active_plugin'] = this.activePlugin;
    if (this.city != null) {
      data['city'] = this.city!.map((v) => v.toJson()).toList();
    }
    if (this.service != null) {
      data['service'] = this.service!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  String? selected;
  String? id;
  String? name;

  City({this.selected, this.id, this.name});

  City.fromJson(Map<String, dynamic> json) {
    selected = json['selected'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selected'] = this.selected;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Service {
  String? slug;
  String? name;
  String? selected;
  bool? isTrue;

  Service({this.slug, this.name, this.selected, this.isTrue});

  Service.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    name = json['name'];
    selected = json['selected'];
    isTrue = json['selected'] == '1' ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['selected'] = this.selected;
    data['is_selected'] = this.isTrue;
    return data;
  }
}

class ServiceSelected {
  String? slug;
  String? name;
  String? selected;
  bool? isTrue;

  ServiceSelected({this.slug, this.name, this.selected, this.isTrue = false});

  ServiceSelected.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    name = json['name'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['selected'] = this.selected;
    return data;
  }
}
