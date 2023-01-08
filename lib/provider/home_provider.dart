import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:catalinadev/model/categories/category_home_model.dart';
import 'package:catalinadev/model/flash_sale/flash_sale_model.dart';
import 'package:catalinadev/model/general_settings/general_settings_model.dart';
import 'package:catalinadev/model/mini_banner/mini_banner_model.dart';
import 'package:catalinadev/model/product/product_extend_model.dart';
import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/model/slider/slider_model.dart';
import 'package:catalinadev/model/store/store_model.dart';
import 'package:catalinadev/services/home_api.dart';
import 'package:catalinadev/services/product_api.dart';
import 'package:catalinadev/services/store_api.dart';

class HomeProvider with ChangeNotifier {
  bool loadingSlider = false;
  bool loadingCategories = false;
  bool loadingBestStore = false;
  bool loadingMiniBanner = false;
  bool loadingFeatured = false;
  bool loadingSplash = true;
  bool loading = false;

  bool loadingRecommendation = false;
  bool loadingSpecial = false;
  bool loadingBest = false;
  bool loadingFlash = false;

  bool loadingHomeProduct = false;
  bool? epekenActive = false;
  String? termCondition;
  String? policy;

  List<FlashSale> flashSaleBanner = [];

  List<SliderModel> banners = [];
  List<CategoryHomeModel> categories = [];
  List<StoreModel> bestStoreHome = [];

  List<MiniBannerModel> firstBanners = [];
  List<MiniBannerModel> secondBanners = [];

  List<ProductModel> listFeaturedProduct = [];
  List<ProductModel> listSpecialProduct = [];
  List<ProductModel> listBestProduct = [];
  List<ProductModel> listRecommendationProduct = [];
  List<ProductModel> listFlashSale = [];

  NewProductExtendModel? productSpecial;
  late NewProductExtendModel productBest;
  late NewProductExtendModel productRecommendation;
  ListFlashSale? productFlash;

  List<GeneralSettingsModel> intro = [];

  var arrayBestOur = [];

  GeneralSettingsModel splashscreen = new GeneralSettingsModel();
  GeneralSettingsModel logo = new GeneralSettingsModel();
  GeneralSettingsModel currency = new GeneralSettingsModel();
  GeneralSettingsModel formatCurrency = new GeneralSettingsModel();
  GeneralSettingsModel about = new GeneralSettingsModel();

  PackageInfo? packageInfo;

  HomeProvider() {
    // fetchHomeBanner();
    // fetchHomeCategories();
    // fetchFlashSale();
    // fetchExtendProducts('our_best_seller').then((value) {
    //   if (productBest.products.isNotEmpty) {
    //     fetchHomeProducts(productBest.products, loadingBest)
    //         .then((value) => listBestProduct = value);
    //   }
    // });
    // fetchExtendProducts('special').then((value) {
    //   if (productSpecial.products.isNotEmpty) {
    //     fetchHomeProducts(productSpecial.products, loadingSpecial)
    //         .then((value) => listSpecialProduct = value);
    //   }
    // });
    // fetchExtendProducts('recomendation').then((value) {
    //   if (productRecommendation.products.isNotEmpty) {
    //     fetchHomeProducts(productRecommendation.products, loadingRecommendation)
    //         .then((value) => listRecommendationProduct = value);
    //   }
    // });
    fetchFeaturedProducts();
    fetchBestStore();
    // fetchMiniBanner();
  }

  Future<bool> getNewHome() async {
    try {
      loading = true;
      await HomeAPI().newHomeApi().then((data) {
        var decode = json.decode(data.body);
        if (data.statusCode == 200) {
          //------------------------------------------------------ SPLASH SCREEN

          splashscreen = GeneralSettingsModel.fromJson(decode['splashscreen']);
          for (Map item in decode['intro']) {
            intro.add(GeneralSettingsModel.fromJson(item));
          }
          print(json.encode(intro));
          notifyListeners();

          //-------------------------------------------------------- MAIN SLIDER

          for (var item in decode["main_slider"]) {
            banners.add(SliderModel.fromJson(item));
          }
          notifyListeners();
          //------------------------------------------------------ CATEGORIES
          for (var item in decode["mini_categories"]) {
            categories.add(CategoryHomeModel.fromJson(item));
          }
          categories.add(new CategoryHomeModel(
              image: 'assets/images/home/viewall.png',
              categories: null,
              id: null,
              titleCategories: 'View More'));
          notifyListeners();

          //----------------------------------------------------- FLASH SALE
          for (var item in decode["products_flash_sale"]) {
            flashSaleBanner.add(FlashSale.fromJson(item));
          }
          notifyListeners();

          //----------------------------------------------------- MINI BANNER
          for (var item in decode["mini_banner"]) {
            if (item['type'] == 'Special Promo') {
              firstBanners.add(MiniBannerModel.fromJson(item));
            } else if (item['type'] == 'Love These Items') {
              secondBanners.add(MiniBannerModel.fromJson(item));
            }
          }
          notifyListeners();

          //----------------------------------------------------- OUR BEST SELLER
          // print("---------------------------------------BEST SELLER");
          for (var item in decode["products_our_best_seller"]) {
            // printLog(item);
            arrayBestOur = [];
            productBest = NewProductExtendModel.fromJson(item);
            for (var product in item['products']) {
              listBestProduct.add(ProductModel.fromJson(product));
              arrayBestOur.add(product['id']);
            }
            // print(arrayBestOur.join(""));
            notifyListeners();
            // print(listBestProduct);
          }
          // print("---------------------------------------BEST SELLER END");

          // print("----------------------------------------------- RECOMENDATION");
          productRecommendation = NewProductExtendModel.fromJson(
              decode["products_recomendation"][0]);
          for (var item in decode["products_recomendation"][0]['products']) {
            listRecommendationProduct.add(ProductModel.fromJson(item));
          }
          notifyListeners();

          // print("----------------------------------------------- RECOMENDATION END");

          // print("----------------------------------------------- SPECIAL");
          productSpecial =
              NewProductExtendModel.fromJson(decode["products_special"][0]);
          for (var item in decode["products_special"][0]['products']) {
            listSpecialProduct.add(ProductModel.fromJson(item));
          }
          // print(listSpecialProduct);
          notifyListeners();
          // print("----------------------------------------------- SPECIAL END");

          termCondition =
              decode["general_settings"]["term_condition"]["description"];
          policy = decode["general_settings"]["privacy_policy"]["description"];

          logo =
              GeneralSettingsModel.fromJson(decode["general_settings"]["logo"]);
          currency = GeneralSettingsModel.fromJson(
              decode["general_settings"]["currency"]);
          formatCurrency = GeneralSettingsModel.fromJson(
              decode["general_settings"]["format_currency"]);
          about = GeneralSettingsModel.fromJson(
              decode["general_settings"]["about"]);
          notifyListeners();

          epekenActive = decode['epeken_activated'];

          print(json.encode(termCondition));
        }
        loading = false;
      });
      return true;
    } catch (e) {
      print(e);
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<ListFlashSale?> fetchFlashSale() async {
    ListFlashSale? result;
    try {
      await HomeAPI().homeFlashSale().then((data) {
        if (data.statusCode == 200) {
          final ress = json.decode(data.body);
          productFlash = ListFlashSale.fromJson(ress[0]);
          result = productFlash;
          fetchFlashSaleProducts(ress[0]["products"])
              .then((value) => listFlashSale = value);
        }
      });
      loadingSlider = false;

      notifyListeners();
      return result;
    } catch (e) {
      loadingSlider = false;
      notifyListeners();
      return result;
    }
  }

  Future<bool> fetchHomeBanner() async {
    try {
      loadingSlider = true;
      await HomeAPI().homeSliderApi().then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);
          for (Map item in responseJson) {
            banners.add(SliderModel.fromJson(item));
          }
          loadingSlider = false;
          notifyListeners();
          return true;
        } else {
          loadingSlider = false;
          notifyListeners();
          return false;
        }
      });
    } catch (e) {
      loadingSlider = false;
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<bool> fetchHomeCategories() async {
    try {
      loadingCategories = true;
      await HomeAPI().homeCategoriesApi().then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);
          for (Map item in responseJson) {
            categories.add(CategoryHomeModel.fromJson(item));
          }
          categories.add(new CategoryHomeModel(
              image: 'assets/images/home/viewall.png',
              categories: null,
              id: null,
              titleCategories: 'View More'));

          loadingCategories = false;
          notifyListeners();
        } else {
          loadingCategories = false;
          notifyListeners();
        }
      });
    } catch (e) {
      loadingCategories = false;
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<bool> fetchBestStore() async {
    try {
      loadingBestStore = true;
      await StoreAPI().allStoreApi(orderBy: 'avg_review_rating').then((data) {
        for (Map item in data) {
          bestStoreHome.add(new StoreModel.fromJson(item));
        }
        loadingBestStore = false;
      });
      notifyListeners();
      return true;
    } catch (e) {
      loadingBestStore = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<ProductModel>> fetchFlashSaleProducts(String? productId) async {
    List<ProductModel> listProduct = [];

    try {
      await ProductAPI().fetchProduct(include: productId).then((data) {
        // print(data);
        for (Map item in data) {
          listProduct.add(ProductModel.fromJson(item));
        }
        // print(listProduct);
        notifyListeners();
      });
      return listProduct;
    } catch (e) {
      notifyListeners();
      return listProduct;
    }
  }

  Future<List<ProductModel>> fetchHomeProducts(
      String productId, bool load) async {
    List<ProductModel> listProduct = [];
    try {
      load = true;
      await ProductAPI().fetchProduct(include: productId).then((data) {
        for (Map item in data) {
          listProduct.add(ProductModel.fromJson(item));
        }
        load = false;
        notifyListeners();
      });
      return listProduct;
    } catch (e) {
      load = false;
      notifyListeners();
      return listProduct;
    }
  }

  Future<bool> fetchFeaturedProducts({int page = 1}) async {
    try {
      loadingFeatured = true;
      await ProductAPI().fetchProduct(featured: true, page: page).then((data) {
        listFeaturedProduct.clear();
        // printLog(data.toString(), name: "Data Featured");
        for (Map item in data) {
          listFeaturedProduct.add(ProductModel.fromJson(item));
        }
        // printLog(listFeaturedProduct.length.toString(), name: "Featured Product Length");
        loadingFeatured = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadingFeatured = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchMiniBanner() async {
    try {
      loadingMiniBanner = true;
      await HomeAPI().homeMiniBannerApi().then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);
          for (Map item in responseJson) {
            if (item['type'] == 'Special Promo') {
              firstBanners.add(MiniBannerModel.fromJson(item));
            } else if (item['type'] == 'Love These Items') {
              secondBanners.add(MiniBannerModel.fromJson(item));
            }
          }
          loadingMiniBanner = false;
          notifyListeners();
          return true;
        } else {
          loadingMiniBanner = false;
          notifyListeners();
          return false;
        }
      });
    } catch (e) {
      loadingMiniBanner = false;
      notifyListeners();
      return false;
    }
    return true;
  }

  setPackageInfo(value) {
    packageInfo = value;
    notifyListeners();
  }
}
