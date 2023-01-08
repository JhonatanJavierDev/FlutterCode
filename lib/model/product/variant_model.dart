import 'package:catalinadev/model/product/attribute_model.dart';

class VariantModel {
  String? varStockStatus,
      deleteProductVariant,
      variableProductId,
      varManageStock;
  List<AttributeModel>? listAttr;
  List<VariationAttributesModel>? listVariationAttr;
  String? width, length, height, weight;
  String? varRegularPrice, varSalePrice, varStock;

  VariantModel(
      {this.listAttr,
      this.listVariationAttr,
      this.varStockStatus,
      this.varRegularPrice,
      this.varSalePrice,
      this.deleteProductVariant,
      this.varManageStock,
      this.varStock,
      this.variableProductId,
      this.weight,
      this.width,
      this.length,
      this.height});

  Map toJson() => {
        "delete_product_variant": deleteProductVariant,
        "variable_product_id": variableProductId,
        "variable_regular_price": varRegularPrice,
        "variable_sale_price": varSalePrice,
        "variable_stock_status": varStockStatus,
        "variable_manage_stock": varManageStock,
        "variable_stock": varStock,
        "variable_weight": weight,
        "variable_length": length,
        "variable_width": width,
        "variable_height": height,
        "variation_attributes": listVariationAttr
      };

  VariantModel.fromJson(Map json) {
    varRegularPrice = json['variable_regular_price'];
    varSalePrice = json['variable_sale_price'];
    varStockStatus = json['variable_stock_status'];
    varManageStock = json['variable_manage_stock'];
    varStock = json['variable_stock'];
    weight = json['variable_weight'];
    length = json['variable_length'];
    width = json['variable_width'];
    height = json['variable_height'];
    if (json['variation_attributes'] != null) {
      listVariationAttr = [];
      json['variation_attributes'].forEach((v) {
        listVariationAttr!.add(new VariationAttributesModel.fromJson(v));
      });
    }
  }
}

class VariationAttributesModel {
  int? id;
  String? attributeName, option;

  VariationAttributesModel({this.id, this.attributeName, this.option});

  Map toJson() => {"id": id, "attribute_name": attributeName, "option": option};

  VariationAttributesModel.fromJson(Map json) {
    id = json['id'];
    attributeName = json['attribute_name'];
    option = json['option'];
  }
}
