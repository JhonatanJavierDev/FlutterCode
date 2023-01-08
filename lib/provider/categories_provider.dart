import 'package:flutter/foundation.dart';
import 'package:catalinadev/model/categories/categories_model.dart';
import 'dart:convert';

import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/services/categories_api.dart';
import 'package:catalinadev/services/product_api.dart';
import 'package:catalinadev/utils/utility.dart';

class CategoryProvider with ChangeNotifier {
  CategoriesModel? category;
  bool loading = true;
  bool loadingAll = true;

  bool loadingSub = false;

  List<CategoriesModel> categories = [];
  List<ProductCategoryModel> productCategories = [];
  List<ProductCategoryModel> subProductCategories = [];

  List<AllCategoriesModel> allCategories = [];
  List<ProductCategoryModel> subCategories = [];
  List<PopularCategoriesModel> popularCategories = [];
  int? currentSelectedCategory;
  int? currentSelectedCountSub;

  List<ProductModel> listProductCategory = [];
  List<NewAllCategoriesModel> listCategories = [];
  List<CategoriesSelectedClass> categoriesSelected = [];

  CategoryProvider() {
    fetchProductCategories();
  }

  Future<List<NewAllCategoriesModel>> fetchNewProductCategories(
      {bool? isEdit, ProductModel? product}) async {
    try {
      loading = true;
      listCategories = [];
      categoriesSelected = [];
      notifyListeners();
      await CategoriesAPI().fetchNewProductCategories().then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);
          for (var item in responseJson) {
            listCategories.add(NewAllCategoriesModel.fromJson(item));
          }
          printLog(json.encode(listCategories));
          if (isEdit!) getStatusEditCategories(product: product);
        }
      });
      loading = false;
      notifyListeners();
      return listCategories;
    } catch (e) {
      print(e);
      loading = false;
      notifyListeners();
      return listCategories;
    }
  }

  Future<void> getStatusEditCategories({ProductModel? product}) async {
    notifyListeners();
    for (var item in listCategories) {
      int index = product!.categories!.indexWhere((cat) => cat.id == item.id);
      if (index != -1) {
        categoriesSelected
            .add(CategoriesSelectedClass(id: item.id, name: item.name));
        item.isSelected = true;
      }

      if (item.subCategories != null) {
        for (var item2 in item.subCategories!) {
          int index =
              product.categories!.indexWhere((cat) => cat.id == item2.id);
          if (index != -1) {
            categoriesSelected
                .add(CategoriesSelectedClass(id: item2.id, name: item2.name));
            item2.isSelected = true;
          }

          if (item2.subCategories != null) {
            for (var item3 in item2.subCategories!) {
              int index =
                  product.categories!.indexWhere((cat) => cat.id == item3.id);
              if (index != -1) {
                categoriesSelected.add(
                    CategoriesSelectedClass(id: item3.id, name: item3.name));
                item3.isSelected = true;
              }
            }
          }
        }
      }
    }
    // print(json.encode(categoriesSelected));
    notifyListeners();
  }

  Future<void> changeStatusCategories({int? newValue}) async {
    for (var item in listCategories) {
      if (item.subCategories != null) {
        if (item.id == newValue) {
          item.isSelected = item.isSelected! ? false : true;
          if (item.isSelected == true) {
            categoriesSelected
                .add(CategoriesSelectedClass(id: item.id, name: item.name));
          } else {
            categoriesSelected.removeWhere((element) => element.id == item.id);
          }
        }
        for (var item2 in item.subCategories!) {
          if (item2.id == newValue) {
            item2.isSelected = item2.isSelected! ? false : true;
            if (item2.isSelected == true) {
              categoriesSelected
                  .add(CategoriesSelectedClass(id: item2.id, name: item2.name));
            } else {
              categoriesSelected
                  .removeWhere((element) => element.id == item2.id);
            }
          }
          if (item2.subCategories != null) {
            for (var item3 in item2.subCategories!) {
              if (item3.id == newValue) {
                item3.isSelected = item3.isSelected! ? false : true;
                if (item3.isSelected == true) {
                  categoriesSelected.add(
                      CategoriesSelectedClass(id: item3.id, name: item3.name));
                } else {
                  categoriesSelected
                      .removeWhere((element) => element.id == item3.id);
                }
              }
            }
          }
        }
      }
    }
    // print(json.encode(categoriesSelected));
    notifyListeners();
  }

  Future<bool> fetchProductCategories() async {
    try {
      await CategoriesAPI().fetchProductCategories().then((data) {
        print(data);
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);
          print(responseJson);
          for (Map item in responseJson) {
            productCategories.add(ProductCategoryModel.fromJson(item));
          }
          loading = false;
          notifyListeners();
        } else {
          loading = false;
          notifyListeners();
        }
      });
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  // /*Future<bool> fetchAllCategories() async {
  //   var result;
  //   await CategoriesAPI().fetchAllCategories().then((data) {
  //     result = data;
  //     printLog(result.toString());
  //     for (Map item in result) {
  //       allCategories.add(AllCategoriesModel.fromJson(item));
  //     }
  //     loadingAll = false;
  //     notifyListeners();
  //   });
  //   return true;
  // }*/

  Future<List<ProductCategoryModel>> fetchSubCategories(int parent) async {
    try {
      loadingSub = true;
      await CategoriesAPI().fetchProductCategories().then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);

          subCategories.clear();
          for (Map item in responseJson) {
            subCategories.add(ProductCategoryModel.fromJson(item));
          }
          loadingSub = false;
          notifyListeners();
        } else {
          loadingSub = false;
          notifyListeners();
        }
      });
      return subCategories;
    } catch (e) {
      loadingSub = false;
      notifyListeners();
      return subCategories;
    }
  }

  /*Future<bool> fetchPopularCategories() async {
    loadingSub = true;
    await CategoriesAPI().fetchPopularCategories().then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        popularCategories.clear();
        for (Map item in responseJson) {
          popularCategories.add(PopularCategoriesModel.fromJson(item));
        }
        loadingSub = false;
        notifyListeners();
      } else {
        loadingSub = false;
        notifyListeners();
      }
    });
    return true;
  }*/

  Future<bool> fetchProductsCategory(String category, {int page = 1}) async {
    try {
      loadingSub = true;
      await ProductAPI()
          .fetchProduct(category: category, page: page, perPage: 5)
          .then((data) {
        if (page == 1) {
          listProductCategory.clear();
        }

        int count = 0;

        for (Map item in data) {
          listProductCategory.add(ProductModel.fromJson(item));
          count++;
        }

        if (count >= 5) {
          listProductCategory.add(ProductModel());
        }

        loadingSub = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadingSub = false;
      notifyListeners();
      return false;
    }
  }
}
