import 'package:flutter/material.dart';
import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/services/product_api.dart';
import 'package:catalinadev/utils/utility.dart';

class SearchProvider with ChangeNotifier {
  bool loadingSearch = false;
  bool loadingQr = false;

  String? message;

  List<ProductModel> listSearchProducts = [];

  String? productWishlist;

  Future<bool> searchProducts(
      String search, String order, String orderBy, int page) async {
    try {
      loadingSearch = true;
      await ProductAPI()
          .fetchProduct(
              search: search, order: order, orderBy: orderBy, page: page)
          .then((data) {
        if (page == 1) {
          listSearchProducts.clear();
        }

        for (Map item in data) {
          listSearchProducts.add(ProductModel.fromJson(item));
        }
        loadingSearch = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadingSearch = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> scanProduct(String code, context) async {
    loadingQr = true;
    await ProductAPI().scanProductAPI(code).then((data) {
      if (data['id'] != null) {
        loadingQr = false;
        Navigator.pop(context);
        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                  productId: data['id'].toString(),
                )));*/
      } else if (data['status'] == 'error') {
        loadingQr = false;
        Navigator.pop(context);
        snackBar(context, message: "Product not found", color: Colors.red);
      }
      loadingQr = false;
      notifyListeners();
    });
    return true;
  }
}
