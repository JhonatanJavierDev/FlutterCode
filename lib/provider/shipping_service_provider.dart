import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:catalinadev/model/shipping/shipping_detail_model.dart';
import 'package:catalinadev/model/shipping/shipping_model.dart';
import 'package:catalinadev/services/shipping_api.dart';
import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/shared.dart';
import 'package:catalinadev/utils/utility.dart';
import 'package:uiblock/uiblock.dart';

import '../model/basic_response.dart';
import '../model/shipping/shipping_woo_model.dart';

class ShippingServiceProvider with ChangeNotifier {
  EpekenShippingModel? listEpeken, dupListepeken;
  bool isLoading = true;
  bool isLoadingSetting = true;
  List<Service> service = [];
  ShippingWoo? shippingWoo;
  ShippingDetail? detailShipping;
  String? selectedMethod;

  Future<EpekenShippingModel?> getShippingProvider() async {
    try {
      isLoading = true;
      notifyListeners();
      await ShippingServiceAPI().getEpekenSetting().then((data) {
        print(Session.data.getString('cookie'));
        isLoading = false;
        if (data != null) {
          service = [];
          listEpeken = EpekenShippingModel.fromJson(data);
          printLog(json.encode(listEpeken));
          notifyListeners();
        }
        notifyListeners();
      });
      return listEpeken;
    } catch (e) {
      notifyListeners();
    }
    return listEpeken;
  }

  Future<void> setKurir({Service? data}) async {
    print(json.encode(data));

    for (var item in listEpeken!.service!) {
      if (item.name == data!.name) {
        if (item.selected == "0") {
          item.selected = "1";
        } else {
          item.selected = "0";
        }
        notifyListeners();
      }
    }
  }

  Future<void> submitShipping(context, {String? kotaID}) async {
    UIBlock.block(context);
    var services = [];
    String vendor;
    for (var item in listEpeken!.service!) {
      if (item.selected == '1' || item.isTrue == true) {
        services.add('"${item.slug}" : ${item.selected == '1' ? true : false}');
      }
    }
    vendor = services.join(",");
    String data =
        '{"cookie": "${Session.data.getString('cookie')}","vendor_data_kota_asal":"$kotaID",$vendor}';
    Map? valueMap = json.decode(data);
    await ShippingServiceAPI().submitShipping(data: valueMap).then((data) {
      UIBlock.unblock(context);
      if (data != null) {
        listEpeken = EpekenShippingModel.fromJson(data);
        snackBar(context,
            message:
                AppLocalizations.of(context)!.translate("shipping_change")!,
            color: Colors.green);
      }
    });

    notifyListeners();
  }

  set clearData(bool newValue) {
    isLoading = newValue;
    notifyListeners();
  }

  bool get clearData => isLoading;

  Future<ShippingWoo?> getWcShippingSetting() async {
    isLoadingSetting = true;
    try {
      await ShippingServiceAPI().getWcShippingSettings().then((data) {
        print(Session.data.getString('cookie'));
        if (data != null) {
          shippingWoo = ShippingWoo.fromJson(data);
          printLog(data.toString());
          isLoadingSetting = false;
          notifyListeners();
        }
        notifyListeners();
      });
      return shippingWoo;
    } catch (e) {
      printLog(e.toString(), name: "Error");
      isLoadingSetting = false;
      notifyListeners();
    }
    return shippingWoo;
  }

  Future<ShippingDetail?> getWcShippingDetail(String? zoneId) async {
    try {
      isLoading = true;
      await ShippingServiceAPI().getWcShippingDetail(zoneId).then((data) {
        print(Session.data.getString('cookie'));
        if (data != null) {
          printLog(data.toString(), name: 'Detail Shipping');
          detailShipping = ShippingDetail.fromJson(data);
          isLoading = false;
          notifyListeners();
        }
        notifyListeners();
      });
      return detailShipping;
    } catch (e) {
      printLog(e.toString(), name: "Error");
      isLoading = false;
      notifyListeners();
    }
    return detailShipping;
  }

  Future<BasicResponse?> postShippingMethod(
      String? zoneId, String? methodId, String? instanceId) async {
    BasicResponse? _response;
    try {
      isLoading = true;
      await ShippingServiceAPI()
          .postShippingMethod(zoneId, methodId, instanceId)
          .then((data) {
        print(Session.data.getString('cookie'));
        if (data != null) {
          printLog(data.toString(), name: 'Post Shipping Method');
          isLoading = false;
          if (data['status'] == "success") {
            _response = BasicResponse(200, data['message']);
          } else {
            _response = BasicResponse(500, data['message']);
          }
          notifyListeners();
        }
        notifyListeners();
      });
      return _response;
    } catch (e) {
      printLog(e.toString(), name: "Error");
      _response = BasicResponse(404, e.toString());
      isLoading = false;
      notifyListeners();
      return _response;
    }
  }

  Future<BasicResponse?> postShippingSettings(bool? shippingEnable,
      String? processingTime, String? shippingType) async {
    BasicResponse? _response;
    try {
      isLoading = true;
      await ShippingServiceAPI()
          .postShippingSettings(shippingEnable, processingTime, shippingType)
          .then((data) {
        if (data != null) {
          printLog(data.toString(), name: 'Post Shipping Settings');
          isLoading = false;
          if (data['status'] == "success") {
            _response = BasicResponse(200, data['message']);
          } else {
            _response = BasicResponse(500, data['message']);
          }
          notifyListeners();
        }
        notifyListeners();
      });
      return _response;
    } catch (e) {
      printLog(e.toString(), name: "Error");
      _response = BasicResponse(404, e.toString());
      isLoading = false;
      notifyListeners();
      return _response;
    }
  }

  Future<BasicResponse?> postShippingDetail(String? zoneId, String? postCodes,
      String? enableMethods, String? disableMethods) async {
    BasicResponse? _response;
    try {
      isLoading = true;
      await ShippingServiceAPI()
          .postShippingDetail(zoneId, postCodes, enableMethods, disableMethods)
          .then((data) {
        if (data != null) {
          printLog(data.toString(), name: 'Post Shipping Detail');
          isLoading = false;
          if (data['status'] == "success") {
            _response = BasicResponse(200, data['message']);
          } else {
            _response = BasicResponse(500, data['message']);
          }
          notifyListeners();
        }
        notifyListeners();
      });
      return _response;
    } catch (e) {
      printLog(e.toString(), name: "Error");
      _response = BasicResponse(404, e.toString());
      isLoading = false;
      notifyListeners();
      return _response;
    }
  }

  Future<BasicResponse?> updateShippingMethod(
      String? instanceId,
      String? title,
      String? description,
      String? cost,
      String? minAmount,
      String? taxStatus,
      String? noClassCost,
      String? calcType) async {
    BasicResponse? _response;
    try {
      isLoading = true;
      await ShippingServiceAPI()
          .updateShippingMethod(instanceId, title, description, cost, minAmount,
              taxStatus, noClassCost, calcType)
          .then((data) {
        if (data != null) {
          printLog(data.toString(), name: 'Update Shipping Method');
          isLoading = false;
          if (data['status'] == "success") {
            _response = BasicResponse(200, data['message']);
          } else {
            _response = BasicResponse(500, data['message']);
          }
          notifyListeners();
        }
        notifyListeners();
      });
      return _response;
    } catch (e) {
      printLog(e.toString(), name: "Error");
      _response = BasicResponse(404, e.toString());
      isLoading = false;
      notifyListeners();
      return _response;
    }
  }

  setSelectedMethod(value) {
    selectedMethod = value;
    notifyListeners();
  }

  reset() {
    isLoading = true;
    notifyListeners();
  }
}
