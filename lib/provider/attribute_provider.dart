import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:catalinadev/model/product/attribute_model.dart';
import 'package:catalinadev/model/product/variant_model.dart';
import 'package:catalinadev/services/product_api.dart';
import 'package:catalinadev/utils/utility.dart';

class AttributeProvider with ChangeNotifier {
  List<AttributeModel> listAttribute = [];
  List<AttributeModel> tempListAttr = [];
  List<ProductAtributeModel> listProductAttribute = [];
  List<VariantModel> listVariant = [];
  bool loadingAttribute = false;

  Future<bool> fetchAttribute() async {
    try {
      await ProductAPI().fetchAttribute().then((data) {
        //final response = json.decode(data.body);
        listAttribute.clear();
        print(data);

        for (Map item in data) {
          listAttribute.add(AttributeModel.fromJson(item));
        }
        for (int i = 0; i < listAttribute.length; i++) {
          listAttribute[i].term!.add(new AttributeTermModel(
              idTerm: 0,
              name: "All",
              slug: "All",
              taxonomy: listAttribute[i].term![0].taxonomy,
              selected: true));
        }

        loadingAttribute = true;
      });
      listVariant.clear();
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  submitVariant(
      {String? regPrice,
      String? salePrice = "",
      String? weight = "",
      String? width = "",
      String? length = "",
      String? height = "",
      String? stockStatus,
      String? manageStock,
      String? stock = "",
      List<VariationAttributesModel>? listVariantAttr}) {
    VariantModel varModel = new VariantModel(
        varRegularPrice: regPrice,
        varSalePrice: salePrice,
        weight: weight,
        width: width,
        length: length,
        height: height,
        varStockStatus: stockStatus,
        varManageStock: manageStock,
        varStock: stock,
        listVariationAttr: listVariantAttr);
    listVariant.add(varModel);
    notifyListeners();
  }

  getListVariantForUpdate({List<VariantModel>? listVar}) {
    if (listVar!.length > 0) {
      listVariant = listVar;
      printLog("listVariant ID: ${listVariant[0].variableProductId}");
    }
    notifyListeners();
  }

  getListAttrForUpdate({List<AttributeModel>? listAttr}) {
    printLog(json.encode(listAttr), name: "List Attribute EDIT");
    if (listAttr!.length > 0) {
      printLog("Condition 1");
      for (int i = 0; i < listAttribute.length; i++) {
        for (int j = 0; j < listAttr.length; j++) {
          if (listAttribute[i].id == listAttr[j].id) {
            printLog("Condition 2");
            listAttribute[i].selected = true;
            listAttr[j].selected = true;
            for (int k = 0; k < listAttribute[i].term!.length; k++) {
              for (int l = 0; l < listAttr[j].term!.length; l++) {
                if (listAttr[j].term![l].idTerm ==
                    listAttribute[i].term![k].idTerm) {
                  printLog("masuk list attribute term");
                  listAttribute[i].term![k].selected = true;
                }
              }
            }
          }
        }
      }
    }
    printLog("tempListAttr length : ${listAttr[0].term!.length}");
    printLog("temp list: ${json.encode(listAttr)}");
    notifyListeners();
  }

  getProdAttribute() {
    String? taxonomyName;
    List<String> options = [];
    for (int i = 0; i < listAttribute.length; i++) {
      if (listAttribute[i].selected!) {
        for (int j = 0; j < listAttribute[i].term!.length; j++) {
          print("${listAttribute[i].selected}");
          String slug = listAttribute[i].term![j].slug!;
          taxonomyName = listAttribute[i].term![j].taxonomy;

          print(
              "slug ${i.toString()} - ${j.toString()}: ${listAttribute[i].term![j].slug!} + length : ${listAttribute[i].term!.length}");
          if (slug != "All" && slug != "all") {
            if (listAttribute[i].term![j].selected!) {
              options.add(slug);
            }
          }
        }
      }
    }
    ProductAtributeModel prodAttribute = new ProductAtributeModel(
        taxonomyName: taxonomyName,
        variation: true,
        visible: true,
        options: options);
    listProductAttribute.add(prodAttribute);
    notifyListeners();
  }

  updateVariant(
      {String? regPrice,
      String? salePrice = "",
      String? weight = "",
      String? width = "",
      String? length = "",
      String? height = "",
      String? stockStatus,
      String? manageStock,
      String? stock = "",
      int? index,
      String? id,
      List<VariationAttributesModel>? listVariantAttr}) {
    VariantModel varModel = new VariantModel(
        varRegularPrice: regPrice,
        varSalePrice: salePrice,
        weight: weight,
        width: width,
        variableProductId: id,
        length: length,
        height: height,
        varStockStatus: stockStatus,
        varManageStock: manageStock,
        varStock: stock,
        listVariationAttr: listVariantAttr);
    listVariant[index!] = varModel;
    notifyListeners();
  }

  Future<void> changeValueAttribute(
      {int? index, String? name, bool? selected}) async {
    listAttribute[index!].selected = selected;
    notifyListeners();
  }

  Future<void> changeTermAttribute(
      {int? index, int? indexj, String? name, bool? selected}) async {
    listAttribute[index!].term![indexj!].selected = selected;
    notifyListeners();
  }

  Future<void> clearList() async {
    listAttribute.clear();
    listVariant.clear();
    notifyListeners();
  }

  Future<void> deleteVariant(int? index) async {
    listVariant[index!].deleteProductVariant = "yes";
    //listVariant.removeAt(index);
    notifyListeners();
  }
}
