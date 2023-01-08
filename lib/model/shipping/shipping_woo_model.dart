class ShippingWoo {
  List<dynamic>? optProcessingTime;
  List<dynamic>? optShippingType;
  UserShipping? userShipping;
  List<dynamic>? listZones;

  ShippingWoo(
      {this.optProcessingTime,
      this.optShippingType,
      this.userShipping,
      this.listZones});

  ShippingWoo.fromJson(Map<String, dynamic> json) {
    dynamic _listOptProcessingTime = [];
    dynamic _listOptShippingType = [];
    dynamic _listZones = [];

    if (json['option_processing_time'] != null &&
        json['option_processing_time'] != '') {
      json['option_processing_time'].forEach(
          (k, v) => _listOptProcessingTime.add(OptProcessingTime(k, v)));
    }

    if (json['option_shipping_type'] != null &&
        json['option_shipping_type'] != '') {
      json['option_shipping_type']
          .forEach((k, v) => _listOptShippingType.add(OptShippingType(k, v)));
    }

    if (json['list zones'] != null &&
        json['list zones'] != '' &&
        json['list zones'].isNotEmpty) {
      json['list zones']
          .forEach((k, v) => _listZones.add(Zone(k, DetailZone.fromJson(v))));
    }

    optProcessingTime = _listOptProcessingTime;
    print(optProcessingTime.toString());
    optShippingType = _listOptShippingType;
    userShipping = json['user_shipping'] != null && json['user_shipping'] != ""
        ? new UserShipping.fromJson(json['user_shipping'])
        : null;
    listZones = _listZones;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userShipping != null) {
      data['user_shipping'] = this.userShipping!.toJson();
    }
    return data;
  }
}

class OptProcessingTime {
  String? id;
  String? name;
  OptProcessingTime(this.id, this.name);

  @override
  String toString() {
    return 'OptProcessingTime{id: $id, name: $name}';
  }
}

class OptShippingType {
  String? id;
  String? name;
  OptShippingType(this.id, this.name);

  @override
  String toString() {
    return 'OptShippingType{id: $id, name: $name}';
  }
}

class UserShipping {
  bool? isEnable;
  String? userShippingEnable;
  String? pt;
  String? userShippingType;

  UserShipping({this.userShippingEnable, this.pt, this.userShippingType});

  UserShipping.fromJson(Map<String, dynamic> json) {
    userShippingEnable = json['_wcfmmp_user_shipping_enable'];
    pt = json['_wcfmmp_pt'];
    userShippingType = json['_wcfmmp_user_shipping_type'];
    if (json['_wcfmmp_user_shipping_enable'] == 'no') {
      isEnable = false;
    } else {
      isEnable = true;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_wcfmmp_user_shipping_enable'] = this.userShippingEnable;
    data['_wcfmmp_pt'] = this.pt;
    data['_wcfmmp_user_shipping_type'] = this.userShippingType;
    return data;
  }
}

class Zone {
  String? id;
  DetailZone? detailZone;
  Zone(this.id, this.detailZone);
}

class DetailZone {
  int? id;
  String? zoneName;
  int? zoneOrder;
  List<ZoneLocations>? zoneLocations;
  int? zoneId;
  String? formattedZoneLocation;
  List<String>? shippingMethods;

  DetailZone(
      {this.id,
      this.zoneName,
      this.zoneOrder,
      this.zoneLocations,
      this.zoneId,
      this.formattedZoneLocation,
      this.shippingMethods});

  DetailZone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zoneName = json['zone_name'];
    zoneOrder = json['zone_order'];
    if (json['zone_locations'] != null) {
      zoneLocations = <ZoneLocations>[];
      json['zone_locations'].forEach((v) {
        zoneLocations!.add(new ZoneLocations.fromJson(v));
      });
    }
    zoneId = json['zone_id'];
    formattedZoneLocation = json['formatted_zone_location'];
    if (json['shipping_methods'] != null) {
      shippingMethods = json['shipping_methods'].cast<String>();
    } else {
      shippingMethods = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['zone_name'] = this.zoneName;
    data['zone_order'] = this.zoneOrder;
    if (this.zoneLocations != null) {
      data['zone_locations'] =
          this.zoneLocations!.map((v) => v.toJson()).toList();
    }
    data['zone_id'] = this.zoneId;
    data['formatted_zone_location'] = this.formattedZoneLocation;
    data['shipping_methods'] = this.shippingMethods;
    return data;
  }
}

class ZoneLocations {
  String? code;
  String? type;

  ZoneLocations({this.code, this.type});

  ZoneLocations.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['type'] = this.type;
    return data;
  }
}
