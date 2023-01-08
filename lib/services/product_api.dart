import 'dart:convert';

import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';
import 'package:catalinadev/utils/utility.dart';

class ProductAPI {
  fetchProduct(
      {String? include = '',
      bool featured = false,
      int page = 1,
      int? id,
      int perPage = 8,
      String parent = '',
      String search = '',
      String? category = '',
      String? order = 'DESC',
      String? orderBy = 'date',
      int? vendorId,
      bool cookie = false,
      bool ownProduct = false}) async {
    Map data = {
      if (cookie) "cookie": Session.data.getString('cookie'),
      "include": include,
      if (featured == true) "featured": featured,
      "page": page,
      "id": id,
      "limit": perPage,
      if (search.isNotEmpty) "search": search,
      if (order != null) "order": order,
      if (category != null) "categories": category,
      if (orderBy != null) "orderby": orderBy,
      if (vendorId != null) "vendor": vendorId,
      "user_id": Session.data.getInt('id').toString()
      // if (ownProduct) "cookie": Session.data.getString('cookie')
      // "cookie": Session.data.getString('cookie')
    };
    // printLog(json.encode(data), name: "walalal");
    // print("aidi" + Session.data.getString('id'));
    var response = await baseAPI.postAsync(product, data, isCustom: true);
    // printLog(json.encode(response), name: "list");
    return response;
  }

  fetchAttribute() async {
    Map data = {"cookie": Session.data.getString('cookie')};
    var response = await baseAPI.postAsync(attribute, data, isCustom: true);
    return response;
  }

  fetchDetailProductSlug({String? slug}) async {
    Map data = {if (slug != null) "slug": slug};
    var response = await baseAPI.postAsync(product, data, isCustom: true);
    return response;
  }

  fetchExtendProduct(String type) async {
    var response =
        await baseAPI.getAsync('$extendProducts?type=$type', isCustom: true);
    return response;
  }

  fetchRecentViewProducts() async {
    var response = await baseAPI.getAsync(
        '$recentProducts?cookie=${Session.data.getString('cookie')}',
        isCustom: true);
    printLog(Session.data.getString('cookie')!);
    return response;
  }

  hitViewProductsAPI(productId) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "product_id": productId,
      "ip_address": Session.data.getString('ip')
    };
    var response =
        await baseAPI.postAsync('$hitViewedProducts', data, isCustom: true);
    printLog(Session.data.getString('cookie')!);
    return response;
  }

  fetchDetailProduct(String id) async {
    Map data = {"id": id};
    var response = await baseAPI.postAsync(product, data, isCustom: true);
    print(response);
    return response;
  }

  searchProduct(
      {String include = '',
      bool featured = false,
      String parent = '',
      String search = '',
      String category = ''}) async {
    var response = await baseAPI.getAsync(
        '$product?include=$include&search=$search&parent=$parent&featured=$featured&category=$category');
    return response;
  }

  /*checkVariationProduct(int productId, List<ProductVariation> list) async {
    Map data = {"product_id": productId, "variation": list};
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$checkVariations',
      data,
      isCustom: true,
    );
    return response;
  }*/

  fetchBrandProduct(
      {int page = 1,
      int perPage = 8,
      String search = '',
      String category = '',
      String order = 'desc',
      String orderBy = 'popularity'}) async {
    var response = await baseAPI.getAsync(
        '$product?page=$page&per_page=$perPage&category=$category&order=$order&orderby=$orderBy');
    return response;
  }

  reviewProduct({String productId = ''}) async {
    var response =
        await baseAPI.getAsync('$reviewProductUrl?product=$productId');
    return response;
  }

  reviewProductLimit({String productId = ''}) async {
    var response = await baseAPI
        .getAsync('$reviewProductUrl?product=$productId&per_page=1&page=1');
    return response;
  }

  fetchMoreProduct({
    String? include = '',
    bool? featured = false,
    bool? rating = false,
    int? page = 1,
    int perPage = 8,
    String parent = '',
    String search = '',
    String category = '',
    String? order = 'DESC',
    String? orderBy = 'date',
    int? vendorId,
  }) async {
    Map data = {
      "include": include,
      if (featured == true) "featured": featured,
      if (rating == true) "rating": rating,
      "page": page,
      "limit": perPage,
      if (search.isNotEmpty) "search": search,
      if (order != null) "order": order,
      if (category.isNotEmpty) "categories": category,
      "orderby": orderBy,
      "vendor": vendorId
    };
    var response = await baseAPI.postAsync(product, data, isCustom: true);
    print("----data----");
    print(data);
    // print(response);
    return response;
  }

  scanProductAPI(String code) async {
    Map data = {"code": code};
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$getBarcodeUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  checkVariationProduct(int? productId, List<ProductVariation>? list) async {
    Map data = {"product_id": productId, "variation": list};
    printLog(json.encode(data));
    var response = await baseAPI.postAsync(
      '$checkVariations',
      data,
      isCustom: true,
    );
    return response;
  }
}
