import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/services/wishlist_api.dart';
import 'package:catalinadev/utils/utility.dart';

class WishlistProvider with ChangeNotifier {
  List<ProductModel> listWishList = [];
  String? productWishlist;
  bool? loadingWL = false;
  bool? loadingWLProduct = false;

  Future<bool> getProductWishlist() async {
    loadingWL = true;
    await WishListAPI().productWishlist().then((data) {
      try {
        productWishlist = data['products'];
        notifyListeners();
        getListWishlist(1);
        return true;
      } catch (e) {
        loadingWL = false;
        printLog(e.toString(), name: "Error Get Product Wishlist");
        notifyListeners();
      }
    });
    return false;
  }

  Future<bool> getListWishlist(int? page) async {
    await WishListAPI().listWishList(productWishlist, page).then((data) {
      loadingWLProduct = true;
      try {
        if (page == 1) {
          listWishList = [];
        }
        for (Map item in data) {
          if (item["is_wistlist"] == true) {
            listWishList.add(ProductModel.fromJson(item));
          }
        }
        print(json.encode(listWishList));
        loadingWL = false;
        loadingWLProduct = false;
        notifyListeners();
        return true;
      } catch (e) {
        loadingWL = false;
        loadingWLProduct = false;
        notifyListeners();
      }
    });
    return false;
  }

  Future<bool?> removeWhistList({id}) async {
    bool? remove;
    await WishListAPI().whistlistToggle(id).then((data) {
      try {
        if (data["message"] == "success") {
          notifyListeners();
          if (data["type"] == "add") {
            remove = true;
          } else {
            remove = false;
          }
        }
      } catch (e) {
        notifyListeners();
        remove = false;
      }
    });
    return remove;
  }
}
