import 'dart:convert';

import 'package:catalinadev/model/product/attribute_model.dart';
import 'package:catalinadev/model/product/variant_model.dart';
import 'package:catalinadev/model/store/store_model.dart';
import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';
import 'package:catalinadev/utils/utility.dart';

class StoreAPI {
  allStoreApi(
      {int? page = 1,
      int perPage = 6,
      String? search = '',
      String? orderBy = ''}) async {
    Map data = {
      "page": page,
      "per_page": perPage,
      "search_term": search,
      "order_by": orderBy
    };
    var response = await baseAPI.postAsync(
      '$allStoreUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  detailStoreApi({int? id}) async {
    Map data = {"vendor_id": id};
    var response = await baseAPI.postAsync(
      '$detailStoreUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  detailStoreApiCookie() async {
    Map data = {"cookie": Session.data.getString('cookie')};
    var response = await baseAPI.postAsync(
      '$detailStoreUrl',
      data,
      isCustom: true,
    );
    print(Session.data.getString('cookie'));
    return response;
  }

  uploadImageApi({String? title, required String mediaAttachment}) async {
    printLog(mediaAttachment);
    Map data = {"title": title, "media_attachment": mediaAttachment};
    var response = await baseAPI.postAsync('$uploadImgUrl', data, version: 2);
    return response;
  }

  inputProductApi(
      {String? title,
      String? regularPrice,
      String? salePrice,
      String? content,
      List<int>? categories,
      String? productType,
      String? status,
      List<ProductImage>? image,
      int? length,
      int? width,
      int? height,
      double? weight,
      int? id,
      String? stockStatus,
      bool? manageStock,
      int? stockQuantity}) async {
    var _tempRegPrice = regularPrice!.replaceAll(new RegExp(r'[^0-9.]'), '');
    var _tempSalePrice = salePrice!.replaceAll(new RegExp(r'[^0-9.]'), '');

    Map data = {
      "cookie": Session.data.getString('cookie'),
      "title": title,
      "regular_price": double.parse(_tempRegPrice),
      "sale_price": _tempSalePrice == ''
          ? ''
          : double.parse(_tempSalePrice) == 0
              ? ''
              : double.parse(_tempSalePrice),
      "content": content,
      "product_type": productType,
      "categories": categories,
      "status": status,
      "image_ids": image,
      "dimensions": {
        "length": length,
        "width": width,
        "height": height,
        "weight": weight,
      },
      "stock_status": stockStatus,
      "manage_stock": manageStock,
      "stock_quantity": stockQuantity
    };

    if (id != null) {
      data["product_id"] = id;
    }

    printLog(data.toString());
    print("data post : ${data.toString()}");
    var response =
        await baseAPI.postAsync('$inputProductUrl', data, version: 2);
    printLog(response.toString());
    return response;
  }

  inputProductVariantApi({
    String? title,
    List<ProductAtributeModel>? productAttribute,
    List<VariantModel>? variationData,
    String? content,
    List<int>? categories,
    String? productType,
    String? status,
    List<ProductImage>? image,
    int? id,
  }) async {
    //var _tempRegPrice = regularPrice!.replaceAll(new RegExp(r'[^0-9.]'), '');
    //var _tempSalePrice = salePrice!.replaceAll(new RegExp(r'[^0-9.]'), '');

    Map data = {
      "cookie": Session.data.getString('cookie'),
      "title": title,
      "content": content,
      "product_type": productType,
      "categories": categories,
      "status": status,
      "image_ids": image,
      "product_atribute": productAttribute,
      "variation_data": variationData
    };

    if (id != null) {
      data["product_id"] = id;
    }

    printLog(data.toString());
    printLog("data post : ${json.encode(data)}");
    var response =
        await baseAPI.postAsync('$inputProductUrl', data, version: 2);
    printLog(response.toString());
    return response;
  }

  removeProductApi(int? id) async {
    Map data = {"cookie": Session.data.getString('cookie'), "product_id": id};
    var response =
        await baseAPI.postAsync('$removeProductUrl', data, version: 2);
    printLog(response.toString());
    return response;
  }

  closeOpenStoreAPI({bool? status}) async {
    Map data = {"cookie": Session.data.getString('cookie'), "is_open": status};

    var response = baseAPI.postAsync(openCloseStoreURL, data, isCustom: true);

    return response;
  }

  //---------------------------------------------------------------------------VENDOR

  requestWidrawalApi() async {
    Map data = {"cookie": Session.data.getString('cookie')};

    var response =
        baseAPI.postAsync(vendorRequestListURL, data, isCustom: true);

    return response;
  }

  submitWithdrawApi({List<dynamic>? withdrawID}) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "order_id": withdrawID
    };

    print(data);

    var response =
        baseAPI.postAsync(vendorSubmitRequestURL, data, isCustom: true);

    return response;
  }

  historyListVendorApi() async {
    Map data = {"cookie": Session.data.getString('cookie')};
    var response =
        baseAPI.postAsync(vendorListHistoryURL, data, isCustom: true);
    return response;
  }
}
