import 'package:catalinadev/model/shipping/shipping_woo_model.dart';
import 'package:catalinadev/utils/utility.dart';

class ShippingDetail {
  DetailZone? detailZone;
  String? formattedZoneLocation;
  List<Locations>? locations;
  List<dynamic>? shippingMethods;
  List<dynamic>? optShippingMethods;
  List<dynamic>? calculationTypes;
  List<dynamic>? taxStatuses;
  bool? isLimitZoneEnabled;

  ShippingDetail(
      {this.detailZone,
      this.formattedZoneLocation,
      this.locations,
      this.shippingMethods});

  ShippingDetail.fromJson(Map<String, dynamic> json) {
    dynamic _listOptShippingMethod = [];
    dynamic _listCalcType = [];
    dynamic _listTaxStatus = [];
    dynamic _listShippingMethod = [];

    if (json['detail']['shipping_methods'] != null &&
        json['detail']['shipping_methods'] != '' &&
        json['detail']['shipping_methods'].isNotEmpty) {
      json['detail']['shipping_methods'].forEach((k, v) => _listShippingMethod
          .add(ShippingMethod(k, ShippingMethodDetail.fromJson(v))));
    }

    if (json['option_shipping_method'] != null &&
        json['option_shipping_method'] != '') {
      json['option_shipping_method'].forEach(
          (k, v) => _listOptShippingMethod.add(OptShippingMethod(k, v)));
    }
    if (json['flatRate_calculation_type'] != null &&
        json['flatRate_calculation_type'] != '') {
      json['flatRate_calculation_type']
          .forEach((k, v) => _listCalcType.add(CalculationType(k, v)));
    }
    if (json['flatRate_localPickup_tax_status'] != null &&
        json['flatRate_localPickup_tax_status'] != '') {
      json['flatRate_localPickup_tax_status']
          .forEach((k, v) => _listTaxStatus.add(TaxStatus(k, v)));
    }
    detailZone = json['detail']['data'] != null
        ? new DetailZone.fromJson(json['detail']['data'])
        : null;
    formattedZoneLocation = json['detail']['formatted_zone_location'];
    if (json['detail']['locations'] != null) {
      locations = <Locations>[];
      json['detail']['locations'].forEach((v) {
        locations!.add(new Locations.fromJson(v));
      });
    }
    if (locations!.isNotEmpty) {
      isLimitZoneEnabled = true;
    } else {
      isLimitZoneEnabled = false;
    }
    shippingMethods = _listShippingMethod;
    optShippingMethods = _listOptShippingMethod;
    calculationTypes = _listCalcType;
    taxStatuses = _listTaxStatus;

    printLog(_listShippingMethod.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detailZone != null) {
      data['data'] = this.detailZone!.toJson();
    }
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShippingMethod {
  String? id;
  ShippingMethodDetail? shippingDetail;
  ShippingMethod(this.id, this.shippingDetail);
}

class ShippingMethodDetail {
  String? instanceId;
  String? id;
  String? enabled;
  String? title;
  Settings? settings;
  bool? isEnabled;

  ShippingMethodDetail(
      {this.instanceId,
      this.id,
      this.enabled,
      this.title,
      this.settings,
      this.isEnabled});

  ShippingMethodDetail.fromJson(Map<String, dynamic> json) {
    instanceId = json['instance_id'];
    id = json['id'];
    enabled = json['enabled'];
    title = json['title'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    isEnabled = json['enabled'] == 'yes' ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['instance_id'] = this.instanceId;
    data['id'] = this.id;
    data['enabled'] = this.enabled;
    data['title'] = this.title;
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Settings {
  String? title;
  String? description;
  String? cost;
  String? taxStatus;
  String? classCost102;
  String? classCost103;
  String? classCostNoClassCost;
  String? calculationType;
  String? minAmount;

  Settings(
      {this.title,
      this.description,
      this.cost,
      this.taxStatus,
      this.classCost102,
      this.classCost103,
      this.classCostNoClassCost,
      this.calculationType,
      this.minAmount});

  Settings.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    cost = json['cost'];
    taxStatus = json['tax_status'] ?? "none";
    minAmount = json['min_amount'] ?? "";
    classCost102 = json['class_cost_102'] ?? "";
    classCost103 = json['class_cost_103'] ?? "";
    classCostNoClassCost = json['class_cost_no_class_cost'] ?? "";
    calculationType = json['calculation_type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['cost'] = this.cost;
    data['tax_status'] = this.taxStatus;
    data['min_amount'] = this.minAmount;
    data['class_cost_102'] = this.classCost102;
    data['class_cost_103'] = this.classCost103;
    data['class_cost_no_class_cost'] = this.classCostNoClassCost;
    data['calculation_type'] = this.calculationType;
    return data;
  }
}

class Locations {
  String? code;
  String? type;

  Locations({this.code, this.type});

  Locations.fromJson(Map<String, dynamic> json) {
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

class OptShippingMethod {
  String? id;
  String? type;
  OptShippingMethod(this.id, this.type);
}

class CalculationType {
  String? id;
  String? type;
  CalculationType(this.id, this.type);
}

class TaxStatus {
  String? id;
  String? type;
  TaxStatus(this.id, this.type);
}
