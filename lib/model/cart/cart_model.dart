import 'package:catalinadev/model/product/product_model.dart';

class CartModel {
  Vendor? vendor;
  bool? isVendorSelected = true;
  List<ProductModel>? products;

  CartModel({this.vendor, this.products, this.isVendorSelected});

  Map toJson() => {
        'vendor': vendor,
        'products': products,
        'is_vendor_selected': isVendorSelected
      };

  CartModel.fromJson(Map json) {
    vendor = new Vendor.fromJson(json['vendor']);
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(new ProductModel.fromJson(v));
      });
    }
  }
}
