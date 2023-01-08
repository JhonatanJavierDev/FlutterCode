import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/model/product/product_review_model.dart';
import 'package:catalinadev/services/product_api.dart';
import 'package:catalinadev/services/review_api.dart';
import 'package:catalinadev/utils/utility.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> listSearchProducts = [];

  List<ProductModel> listNewProduct = [];
  List<ProductModel> listMoreNewProduct = [];
  List<ProductModel> listRelatedProduct = [];
  List<ProductModel> listProductCategory = [];
  List<ProductModel> listMoreExtendProduct = [];
  List<ProductModel> listRecentProduct = [];

  List<ProductReviewModel> listReview = [];
  List<ProductReviewModel> listReviewAllStar = [];
  List<ProductReviewModel> listReviewFiveStar = [];
  List<ProductReviewModel> listReviewFourStar = [];
  List<ProductReviewModel> listReviewThreeStar = [];
  List<ProductReviewModel> listReviewTwoStar = [];
  List<ProductReviewModel> listReviewOneStar = [];

  bool loadingSearch = false;
  bool loadingNew = false;
  bool loadingRelated = false;
  bool loadingCategory = false;
  bool loadMore = false;
  bool loadDetail = false;
  bool loadAddReview = false;
  bool loadReview = false;
  bool isLoadingReview = false;

  ProductModel? productDetail;

  String? productRecent;

  Future<bool> fetchFeaturedProducts({int page = 1}) async {
    try {
      loadingSearch = true;
      await ProductAPI().fetchProduct(featured: true, page: page).then((data) {
        final responseJson = json.decode(data.body);
        listSearchProducts.clear();
        for (Map item in responseJson) {
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

  Future<bool> fetchNewProducts(String? category, {int page = 1}) async {
    try {
      loadingNew = true;
      await ProductAPI()
          .fetchProduct(category: category, page: page)
          .then((data) {
        if (page == 1) {
          listNewProduct.clear();
          listMoreNewProduct.clear();
        }
        for (Map item in data) {
          if (page == 1) {
            listNewProduct.add(ProductModel.fromJson(item));
            listMoreNewProduct.add(ProductModel.fromJson(item));
          } else {
            listMoreNewProduct.add(ProductModel.fromJson(item));
          }
        }
        loadingNew = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadingNew = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchRelatedProducts(String? productId) async {
    try {
      loadingRelated = true;
      await ProductAPI().fetchProduct(include: productId).then((data) {
        listRelatedProduct.clear();
        for (Map item in data) {
          listRelatedProduct.add(ProductModel.fromJson(item));
        }
        loadingRelated = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadingRelated = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchProductByCategory(String? category,
      {int page = 1, String? order, String? orderBy}) async {
    try {
      loadingCategory = true;
      await ProductAPI()
          .fetchProduct(
              category: category, page: page, orderBy: orderBy, order: order)
          .then((data) {
        if (page == 1) {
          listProductCategory.clear();
        }
        for (Map item in data) {
          listProductCategory.add(ProductModel.fromJson(item));
        }
        loadingCategory = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadingCategory = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchMoreExtendProduct(String? productId,
      {int? page,
      String? order,
      String? orderBy,
      bool? featured,
      bool? rating}) async {
    try {
      loadMore = true;
      await ProductAPI()
          .fetchMoreProduct(
        include: productId,
        page: page,
        order: order,
        orderBy: orderBy,
        featured: featured,
        rating: rating,
      )
          .then((data) {
        if (page == 1) {
          listMoreExtendProduct.clear();
        }

        for (Map item in data) {
          listMoreExtendProduct.add(ProductModel.fromJson(item));
        }
        loadMore = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadMore = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<ProductModel>> fetchMoreExtendProductFlash(String? productId,
      {int? page, String? order, String? orderBy, bool? featured}) async {
    List<ProductModel> result = [];
    loadMore = true;
    await ProductAPI()
        .fetchMoreProduct(
            include: productId,
            order: order,
            orderBy: orderBy,
            featured: featured)
        .then((data) {
      // if (page == 1) {
      //   result.clear();
      // }

      for (Map item in data) {
        result.add(ProductModel.fromJson(item));
      }
      loadMore = false;
      notifyListeners();
    });
    return result;
    // try {} catch (e) {
    //   loadMore = false;
    //   notifyListeners();
    //   return result;
    // }
  }

  Future<ProductModel> fetchDetailProduct(String productId, context) async {
    ProductModel product = new ProductModel();
    try {
      loadDetail = true;
      await ProductAPI().fetchProduct(id: int.parse(productId)).then((data) {
        if (data.isNotEmpty) {
          for (Map item in data) {
            product = ProductModel.fromJson(item);
          }
          printLog(data.toString());
          loadDetail = false;
          notifyListeners();
        } else {
          loadDetail = false;
          notifyListeners();
          Navigator.pop(context);
          snackBar(context, color: Colors.red, message: "Product not found");
        }
      });
      return product;
    } catch (e) {
      print(e);
      loadDetail = false;
      notifyListeners();
      return product;
    }
  }

  Future<Map<String, dynamic>?> addReview(context,
      {productId, review, rating}) async {
    loadAddReview = true;
    var result;

    try {
      await ReviewAPI().inputReview(productId, review, rating).then((data) {
        result = data;
        printLog(result.toString());

        if (result['id'] != null) {
          loadAddReview = false;

          snackBar(context,
              message: 'Successfully added your review in this product');
        } else {
          loadAddReview = false;

          snackBar(context, message: 'Error, ${result['message']}');
        }

        notifyListeners();
        printLog(result.toString());
      });
    } catch (e) {
      loadAddReview = false;
      snackBar(context, message: 'Error, $e');
      notifyListeners();
    }
    return result;
  }

  Future<bool> loadReviewProduct(String productId,
      {int? page, int? perPage}) async {
    loadReview = true;
    try {
      await ReviewAPI()
          .listReview(page: page, perPage: perPage, product: productId)
          .then((data) {
        final responseJson = json.decode(data.body);
        printLog('responseReview : ${responseJson.toString()}');
        if (page == 1) {
          listReview.clear();
        }

        for (Map item in responseJson) {
          listReview.add(ProductReviewModel.fromJson(item));
        }
        loadReview = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadReview = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> hitViewProducts(productId) async {
    await ProductAPI().hitViewProductsAPI(productId).then((data) {
      notifyListeners();
    });
    return true;
  }

  Future<bool> fetchRecentProducts() async {
    await ProductAPI().fetchRecentViewProducts().then((data) {
      if (data["products"].toString().isNotEmpty) {
        productRecent = data['products'];
        this.fetchListRecentProducts(productRecent);
      }
      notifyListeners();
    });
    return true;
  }

  Future<bool> fetchListRecentProducts(productId) async {
    await ProductAPI()
        .fetchMoreProduct(
            include: productId, order: 'desc', orderBy: 'popularity')
        .then((data) {
      if (data != null) {
        final responseJson = data;

        listRecentProduct.clear();
        for (Map item in responseJson) {
          listRecentProduct.add(ProductModel.fromJson(item));
        }
        notifyListeners();
      } else {
        print("Load Recent Failed");
        notifyListeners();
      }
    });
    return true;
  }

  Future<ProductModel?> fetchProductDetailSlug(String? slug) async {
    loadDetail = true;
    await ProductAPI().fetchDetailProductSlug(slug: slug).then((data) {
      if (data != null) {
        // printLog("responseJson : ${data.toString()}");
        final responseJson = data;

        for (Map item in responseJson) {
          productDetail = ProductModel.fromJson(item);
        }
        notifyListeners();
      } else {
        print("Load Failed");
        notifyListeners();
      }
      loadDetail = false;
    });
    return productDetail;
  }

  Future<Map<String, dynamic>?> checkVariation({productId, list}) async {
    var result;
    try {
      await ProductAPI().checkVariationProduct(productId, list).then((data) {
        result = data;
        printLog(json.encode(data));
        notifyListeners();
        printLog(result.toString());
      });
      return result;
    } catch (e) {
      notifyListeners();
      return result;
    }
  }

  Future<bool> loadAllReviewProduct(String? productId,
      {int? page, int? perPage}) async {
    loadReview = true;
    try {
      await ReviewAPI()
          .listReview(page: page, perPage: perPage, product: productId)
          .then((data) {
        final responseJson = json.decode(data.body);
        listReviewAllStar.clear();

        for (Map item in responseJson) {
          listReviewAllStar.add(ProductReviewModel.fromJson(item));
        }

        listReviewAllStar.forEach((element) {
          if (element.rating == 5) {
            listReviewFiveStar.add(element);
          } else if (element.rating == 4) {
            listReviewFourStar.add(element);
          } else if (element.rating == 3) {
            listReviewThreeStar.add(element);
          } else if (element.rating == 2) {
            listReviewTwoStar.add(element);
          } else if (element.rating == 1) {
            listReviewOneStar.add(element);
          }
        });
        loadReview = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadReview = false;
      notifyListeners();
      return false;
    }
  }
}
