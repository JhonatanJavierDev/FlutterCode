import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';
import 'package:catalinadev/utils/utility.dart';

class ShippingServiceAPI {
  getEpekenSetting() async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
    };

    var response =
        await baseAPI.postAsync(getEpekenSettingURL, data, isCustom: true);

    return response;
  }

  submitShipping({Map? data}) async {
    print(data);

    var response =
        await baseAPI.postAsync(submitEpekenKurir, data, isCustom: true);

    return response;
  }

  getWcShippingSettings() async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
    };

    var response =
        await baseAPI.postAsync(wcShippingSetting, data, isCustom: true);

    return response;
  }

  getWcShippingDetail(String? zoneId) async {
    Map data = {"cookie": Session.data.getString('cookie'), "zone_id": zoneId};

    var response =
        await baseAPI.postAsync(wcShippingDetail, data, isCustom: true);

    return response;
  }

  postShippingMethod(
      String? zoneId, String? methodId, String? instanceId) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "zone_id": zoneId,
      if (methodId != null && methodId != '') "method_id": methodId,
      if (instanceId != null && instanceId != '') "instance_id": instanceId
    };

    printLog(data.toString(), name: "Data Post Shipping Method");

    var response =
        await baseAPI.postAsync(wcPostShipping, data, isCustom: true);

    return response;
  }

  postShippingSettings(bool? shippingEnable, String? processingTime,
      String? shippingType) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "shipping_enable": shippingEnable! ? "yes" : "no",
      "processing_time": processingTime,
      "shipping_type": shippingType
    };

    printLog(data.toString(), name: "Data Post Shipping Setting");

    var response =
        await baseAPI.postAsync(wcPostShippingSetting, data, isCustom: true);

    return response;
  }

  postShippingDetail(String? zoneId, String? postCodes, String? enableMethods,
      String? disableMethods) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "zone_id": zoneId,
      "shipping_zone_postcodes": postCodes,
      "enable_methods": enableMethods,
      "disable_methods": disableMethods
    };

    printLog(data.toString(), name: "Data Post Shipping Detail");

    var response =
        await baseAPI.postAsync(wcPostShippingDetail, data, isCustom: true);

    return response;
  }

  updateShippingMethod(
      String? instanceId,
      String? title,
      String? description,
      String? cost,
      String? minAmount,
      String? taxStatus,
      String? noClassCost,
      String? calcType) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "instance_id": instanceId,
      "title": title,
      "description": description,
      "cost": cost,
      "min_amount": minAmount,
      "tax_status": taxStatus,
      "class_cost_102": "",
      "class_cost_103": "",
      "class_cost_no_class_cost": noClassCost,
      "calculation_type": calcType
    };

    printLog(data.toString(), name: "Data Post Shipping Detail");

    var response =
        await baseAPI.postAsync(wcUpdateShippingMethod, data, isCustom: true);

    return response;
  }
}
