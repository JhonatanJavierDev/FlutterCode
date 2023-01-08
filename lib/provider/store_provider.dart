import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:catalinadev/model/product/attribute_model.dart';
import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/model/product/variant_model.dart';
import 'package:catalinadev/model/store/request_withdrawal_model.dart';
import 'package:catalinadev/model/store/store_model.dart';
import 'package:catalinadev/model/store/withdrawal_history_model.dart';
import 'package:catalinadev/screen/pages.dart';
import 'package:catalinadev/services/product_api.dart';
import 'package:catalinadev/services/rekening_vendor_api.dart';
import 'package:catalinadev/services/store_api.dart';
import 'package:catalinadev/utils/shared.dart';
import 'package:catalinadev/utils/utility.dart';
import 'package:uiblock/uiblock.dart';

class StoreProvider with ChangeNotifier {
  bool loadingAllStore = true;
  bool loadingBestStore = false;
  bool loadingStore = true;
  bool loadingStoreProduct = false;

  bool loadImage = false;
  bool loadInput = false;
  bool loadRemove = false;
  bool loading = false;
  bool loadMore = false;

  List<StoreModel> stores = [];
  List<StoreModel> bestStoreAll = [];

  List<ProductModel> listStoreProducts = [];
  List<ProductModel> listOwnProducts = [];

  List<WidrawalHistoryListModel> withdrawalList = [];
  RequestWithdrawalList? requestWithdrawalList;

  late StoreModel store;
  StoreModel? manageStore;

  Future<void> resetAllStore() async {
    loadingAllStore = true;
    stores.clear();
    //notifyListeners();
  }

  Future<bool> fetchAllStore(context,
      {int? page, String? search, String? orderBy, int? cekReset}) async {
    if (search != "") {
      if (cekReset == 1) {
        await resetAllStore();
      }

      try {
        loadMore = true;
        // notifyListeners();
        // loadingAllStore = true;

        await StoreAPI()
            .allStoreApi(page: page, orderBy: orderBy, search: search)
            .then((data) {
          loadMore = false;
          // stores.clear();
          for (Map item in data) {
            stores.add(new StoreModel.fromJson(item));
          }
          loadingAllStore = false;
          print('Data : ${data.toString()}');
        });
        notifyListeners();
        return true;
      } catch (e) {
        loadingAllStore = false;
        notifyListeners();
        snackBar(context,
            color: Colors.red,
            message: 'Oops, Error when trying load the data');
        return false;
      }
    }

    try {
      loadMore = true;
      // notifyListeners();
      // loadingAllStore = true;

      await StoreAPI()
          .allStoreApi(page: page, orderBy: orderBy, search: search)
          .then((data) {
        loadMore = false;
        // stores.clear();
        for (Map item in data) {
          stores.add(new StoreModel.fromJson(item));
        }
        loadingAllStore = false;
        print('Data : ${data.toString()}');
      });
      notifyListeners();
      return true;
    } catch (e) {
      loadingAllStore = false;
      notifyListeners();
      snackBar(context,
          color: Colors.red, message: 'Oops, Error when trying load the data');
      return false;
    }
  }

  Future<bool> fetchBestStore(context, int perPage) async {
    try {
      loadingBestStore = true;
      await StoreAPI()
          .allStoreApi(orderBy: 'avg_review_rating', perPage: perPage)
          .then((data) {
        bestStoreAll.clear();
        for (Map item in data) {
          bestStoreAll.add(new StoreModel.fromJson(item));
        }
        loadingBestStore = false;
      });
      notifyListeners();
      return true;
    } catch (e) {
      loadingBestStore = false;
      notifyListeners();
      snackBar(context,
          color: Colors.red, message: 'Oops, Error when trying load the data');
      return false;
    }
  }

  Future<bool> fetchDetailStore(context, {int? id}) async {
    try {
      loadingStore = true;
      notifyListeners();
      await StoreAPI().detailStoreApi(id: id).then((data) {
        for (Map item in data) {
          store = new StoreModel.fromJson(item);
        }
        loadingStore = false;
      });
      notifyListeners();
      return true;
    } catch (e) {
      loadingStore = false;
      notifyListeners();
      snackBar(context,
          color: Colors.red, message: 'Oops, Error when trying load the data');
      return false;
    }
  }

  Future<StoreModel?> fetchDetailManageStore(context) async {
    try {
      loadingStore = true;
      //notifyListeners();
      await StoreAPI().detailStoreApiCookie().then((data) {
        for (Map item in data) {
          manageStore = new StoreModel.fromJson(item);
        }
        loadingStore = false;
        printLog(json.encode(manageStore));
      });
      notifyListeners();
      return manageStore;
    } catch (e) {
      print(e);
      loadingStore = false;
      notifyListeners();
      snackBar(context,
          color: Colors.red, message: 'Oops, Error when trying load the data');
      return manageStore;
    }
  }

  Future<void> openCloseFunc(context, {required bool status}) async {
    MessageToko result;
    try {
      UIBlock.block(context);
      await StoreAPI().closeOpenStoreAPI(status: !status).then((data) {
        if (data != null) {
          printLog(data.toString());
          UIBlock.unblock(context);
          result = MessageToko.fromJson(data);
          if (result.status == "success") {
            if (result.message == 'toko buka') {
              manageStore!.isClose = false;
            } else {
              manageStore!.isClose = true;
            }
            snackBar(context,
                message:
                    manageStore!.isClose! ? 'Store Closed' : 'Store Opened',
                color: manageStore!.isClose! ? Colors.redAccent : Colors.green);
          }
          notifyListeners();
        }
      });
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<bool> storeProducts(
      String search, int? vendorId, int page, String category) async {
    try {
      loadingStoreProduct = true;
      notifyListeners();
      await ProductAPI()
          .fetchProduct(
              search: search,
              page: page,
              vendorId: vendorId,
              category: category)
          .then((data) {
        if (page == 1) {
          listStoreProducts.clear();
        }

        for (Map item in data) {
          listStoreProducts.add(ProductModel.fromJson(item));
        }
        loadingStoreProduct = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadingStoreProduct = false;
      notifyListeners();
      return false;
    }
  }

  Future<ProductImage> uploadImgProduct(context,
      {String? title, required media}) async {
    ProductImage image = new ProductImage();
    try {
      loadImage = true;
      await StoreAPI()
          .uploadImageApi(title: title, mediaAttachment: media)
          .then((data) {
        if (data != null) image = ProductImage.fromJson(data);
        loadImage = false;
      });
      notifyListeners();
      return image;
    } catch (e) {
      loadImage = false;
      notifyListeners();
      snackBar(context,
          color: Colors.red, message: 'Oops, cannot upload image');
      return image;
    }
  }

  Future<bool> inputProduct(context,
      {List<ProductImage>? images,
      String? title,
      regularPrice,
      salePrice,
      content,
      categories,
      productType,
      status,
      int? length,
      int? width,
      int? height,
      double? weight,
      int? id,
      String? stockStatus,
      bool? manageStock,
      int? stockQuantity}) async {
    try {
      loadInput = true;
      await StoreAPI()
          .inputProductApi(
              title: title,
              regularPrice: regularPrice,
              salePrice: salePrice,
              content: content,
              categories: categories,
              productType: productType,
              status: status,
              image: images,
              length: length,
              width: width,
              height: height,
              weight: weight,
              id: id,
              stockQuantity: stockQuantity,
              manageStock: manageStock,
              stockStatus: stockStatus)
          .then((data) {
        if (data['id'] != null) {
          loadInput = false;
          if (id != null) {
            snackBar(context,
                color: Colors.green,
                message: AppLocalizations.of(context)!
                    .translate("product_updated")!);
          } else {
            snackBar(context,
                color: Colors.green,
                message: AppLocalizations.of(context)!
                    .translate("product_created")!);
          }
          Navigator.pop(context, "200");
          Navigator.pop(context, "200");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageProductScreen(),
            ),
          );
        } else {
          loadInput = false;
          snackBar(context,
              color: Colors.red,
              message:
                  AppLocalizations.of(context)!.translate("error_occurred")!);
        }
      });
      notifyListeners();
      return true;
    } catch (e) {
      printLog(e.toString(), name: "Error");
      loadInput = false;
      notifyListeners();
      snackBar(context, color: Colors.red, message: 'Oops, cannot add product');
      return false;
    }
  }

  Future<bool> inputProductVariant(
    context, {
    List<ProductImage>? images,
    String? title,
    content,
    categories,
    productType,
    status,
    int? id,
    List<ProductAtributeModel>? productAttribute,
    List<VariantModel>? variationData,
  }) async {
    try {
      loadInput = true;
      await StoreAPI()
          .inputProductVariantApi(
              title: title,
              content: content,
              categories: categories,
              productType: productType,
              status: status,
              image: images,
              id: id,
              productAttribute: productAttribute,
              variationData: variationData)
          .then((data) {
        if (data['id'] != null) {
          loadInput = false;
          if (id != null) {
            snackBar(context,
                color: Colors.green,
                message: AppLocalizations.of(context)!
                    .translate("product_updated")!);
          } else {
            snackBar(context,
                color: Colors.green,
                message: AppLocalizations.of(context)!
                    .translate("product_created")!);
          }
          Navigator.pop(context, "200");
          Navigator.pop(context, "200");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageProductScreen(),
            ),
          );
        } else {
          loadInput = false;
          snackBar(context,
              color: Colors.red,
              message:
                  AppLocalizations.of(context)!.translate("error_occurred")!);
        }
      });
      notifyListeners();
      return true;
    } catch (e) {
      printLog(e.toString(), name: "Error");
      loadInput = false;
      notifyListeners();
      snackBar(context, color: Colors.red, message: 'Oops, cannot add product');
      return false;
    }
  }

  Future<bool> fetchOwnProducts(int page) async {
    try {
      loadingStoreProduct = true;
      await ProductAPI().fetchProduct(page: page, cookie: true).then((data) {
        if (page == 1) {
          listOwnProducts.clear();
        }

        for (Map item in data) {
          listOwnProducts.add(ProductModel.fromJson(item));
        }
        loadingStoreProduct = false;
        notifyListeners();
      });
      return true;
    } catch (e) {
      loadingStoreProduct = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeProduct(context, int? id) async {
    try {
      loadRemove = true;
      await StoreAPI().removeProductApi(id).then((data) {
        if (data['status'] == 'success') {
          loadRemove = false;
          snackBar(context,
              color: Colors.green, message: 'Product removed successfully');
          notifyListeners();
          return true;
        } else {
          loadRemove = false;
          snackBar(context,
              color: Colors.red,
              message: 'Oops, something wrong. Contact the developer.');
          notifyListeners();
          return false;
        }
      });
      notifyListeners();
      return true;
    } catch (e) {
      loadRemove = false;
      notifyListeners();
      snackBar(context, color: Colors.red, message: 'Oops, cannot add product');
      return false;
    }
  }

  //-------------------------------------------------------------------------------------------- VENDOR

  Future<BankAccount?> sendRekeningVendor(context,
      {String? acName, bankName, bankAddress, acNumber, routingNumber}) async {
    BankAccount? result;
    try {
      FocusScope.of(context).unfocus();
      UIBlock.block(context);
      RekeningVendorAPI()
          .sendRekeningVendorAPI(
        acName: acName,
        acNumber: acNumber,
        bankAddress: bankAddress,
        bankName: bankName,
        routingNumber: routingNumber,
      )
          .then((data) {
        // print(data['payment']['bank']);
        if (data != null) {
          result = BankAccount.fromJson(data['payment']['bank']);
          manageStore!.bankAccount = result;
          UIBlock.unblock(context);
          snackBar(context,
              message: "Success update your bank account",
              color: Colors.green[400]);
          notifyListeners();
        }
      });
    } catch (e) {
      notifyListeners();
    }
    return result;
  }

  Future<void> getListWithdrawRequest() async {
    loading = true;
    notifyListeners();
    StoreAPI().requestWidrawalApi().then(
      (data) {
        print(data);
        if (data != null) {
          requestWithdrawalList = RequestWithdrawalList.fromJson(data);
          loading = false;
          notifyListeners();
        }
        print(json.encode(requestWithdrawalList));
      },
    );
    try {} catch (e) {
      print(e);
    }
    notifyListeners();
  }

  submitWithdrawRequest(context, {List<dynamic>? data}) async {
    UIBlock.block(context);
    StoreAPI().submitWithdrawApi(withdrawID: data).then(
      (data) {
        print(data);
        if (data["message"] != null) {
          snackBar(context, message: data["message"]);
          getListWithdrawRequest();
        }
        UIBlock.unblock(context);
      },
    );
  }

  Future<void> getListHistoryWithdrawal() async {
    try {
      loading = true;
      withdrawalList = [];
      notifyListeners();
      StoreAPI().historyListVendorApi().then(
        (data) {
          if (data != null) {
            for (var item in data) {
              withdrawalList.add(WidrawalHistoryListModel.fromJson(item));
            }
            print(json.encode(withdrawalList));
            loading = false;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }
}
