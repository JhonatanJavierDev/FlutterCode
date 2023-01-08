import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:catalinadev/model/cart/cart_model.dart';
import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/shared.dart';
import 'package:catalinadev/utils/utility.dart';

class CartProvider with ChangeNotifier {
  bool isSelectedAll = false;
  double totalPriceCart = 0;
  int totalSelected = 0;

  List<CartModel> listCart = [];

  Future<int> loadCartCount() async {
    int totalProduct = 0;
    if (Session.data.containsKey('cart')) {
      List carts = await json.decode(Session.data.getString('cart')!);

      listCart = carts.map((cart) => new CartModel.fromJson(cart)).toList();
      listCart.forEach((element) {
        element.products!.forEach((elementProduct) {
          totalProduct += elementProduct.cartQuantity!;
        });
      });
    }
    return totalProduct;
  }

  Future calculatePriceTotal(context, ProductModel product) async {
    print(product.cartQuantity);
    // product.priceTotal = (product.cartQuantity * product.productPrice);
    addCart(context, product);
  }

  /*add to cart*/
  void addCart(context, ProductModel product) async {
    ProductModel productModel = product;
    Vendor? vendor = product.vendor;

    /*check sharedPrefs for cart*/
    if (!Session.data.containsKey('cart')) {
      List<CartModel> listCart = [];
      List<ProductModel> listProduct = [];
      productModel.priceTotal =
          (productModel.cartQuantity! * productModel.productPrice);

      listProduct.add(productModel);

      listCart.add(new CartModel(vendor: vendor, products: listProduct));

      await Session.data.setString('cart', json.encode(listCart));
      List? carts = await json.decode(Session.data.getString('cart')!);
      printLog(carts.toString(), name: "Cart");
    } else {
      List carts = await json.decode(Session.data.getString('cart')!);
      printLog(carts.toString(), name: "Cart Store");

      List<CartModel> listCart =
          carts.map((cart) => new CartModel.fromJson(cart)).toList();

      int index =
          carts.indexWhere((cart) => cart["vendor"]["id"] == vendor!.id);

      if (index != -1) {
        int indexProduct = listCart[index].products!.indexWhere((prod) =>
            prod.id == productModel.id &&
            prod.variantId == productModel.variantId &&
            prod.variationName == productModel.variationName);

        if (indexProduct != -1) {
          productModel.cartQuantity =
              listCart[index].products![indexProduct].cartQuantity! +
                  productModel.cartQuantity!;

          productModel.priceTotal =
              (productModel.cartQuantity! * productModel.productPrice);

          listCart[index].products![indexProduct] = productModel;

          await Session.data.setString('cart', json.encode(listCart));
        } else {
          productModel.priceTotal =
              (productModel.cartQuantity! * productModel.productPrice);
          listCart[index].products!.add(productModel);
          await Session.data.setString('cart', json.encode(listCart));
        }
      } else {
        List<ProductModel> listProduct = [];
        productModel.priceTotal =
            (productModel.cartQuantity! * productModel.productPrice);
        listProduct.add(productModel);

        listCart.add(new CartModel(vendor: vendor, products: listProduct));
        await Session.data.setString('cart', json.encode(listCart));
        printLog(carts.toString(), name: "Cart Product");
      }
    }
    snackBar(context,
        message: AppLocalizations.of(context)!.translate("success_add_cart")!);
  }

  Future loadCartData() async {
    if (Session.data.containsKey('cart')) {
      List carts = await json.decode(Session.data.getString('cart')!);

      listCart = carts.map((cart) => new CartModel.fromJson(cart)).toList();
      selectedAll();
    }
  }

  /*Calculate Total If Item Selected*/
  Future calculateTotal(indexStore, indexProduct) async {
    if (listCart[indexStore].products![indexProduct].isSelected!) {
      totalSelected++;
    } else {
      totalSelected--;
    }
    listCart[indexStore].products!.forEach((element) {
      if (element.isSelected!) {
        listCart[indexStore].isVendorSelected = true;
      }
    });
    listCart[indexStore].products!.forEach((element) {
      if (!element.isSelected!) {
        listCart[indexStore].isVendorSelected = false;
      }
    });
    reCalculateTotalOrder();
    Session.data.setDouble('totalPriceCart', totalPriceCart);
  }

  selectedAll() {
    listCart.forEach((element) {
      if (element.isVendorSelected!) {
        totalPriceCart = 0;

        element.products!.forEach((elementProduct) {
          totalSelected++;
          elementProduct.isSelected = true;
          totalPriceCart += elementProduct.priceTotal;
        });
      } else {
        element.products!.forEach((elementProduct) {
          totalSelected--;
          elementProduct.isSelected = false;
          totalPriceCart -= elementProduct.priceTotal;
        });
      }
    });
    reCalculateTotalOrder();
    Session.data.setDouble('totalPriceCart', totalPriceCart);
  }

  /*ReCalculate Total Order*/
  reCalculateTotalOrder() {
    totalPriceCart = 0;
    totalSelected = 0;
    listCart.forEach((element) {
      element.products!.forEach((elementProduct) {
        if (elementProduct.isSelected!) {
          totalPriceCart += elementProduct.priceTotal;
          totalSelected++;
        }
      });
    });
    // calcDisc();
  }

  /*Refresh Quantity Item*/
  Future refreshQuantity(indexStore, indexProduct) async {
    listCart[indexStore].products![indexProduct].priceTotal =
        (listCart[indexStore].products![indexProduct].cartQuantity! *
            listCart[indexStore].products![indexProduct].productPrice);
    if (listCart[indexStore].products![indexProduct].isSelected!) {
      reCalculateTotalOrder();
    }
    saveData();
  }

  /*Remove Item & Save Cart To ShredPrefs*/
  removeItem(indexStore, indexProduct, context) {
    listCart[indexStore].products!.removeAt(indexProduct);
    if (listCart[indexStore].products!.isEmpty) {
      listCart.removeAt(indexStore);
    }
    reCalculateTotalOrder();
    saveData();
    snackBar(context,
        message:
            AppLocalizations.of(context)!.translate("success_delete_cart")!);
  }

  saveData() async {
    await Session.data.setString('cart', json.encode(listCart));
    printLog(listCart.toString(), name: "Cart Product");
  }

  /*Calculate Discount*/
  /*calcDisc() {
    final coupons = Provider.of<CouponProvider>(context, listen: false);
    if (coupons.couponUsed != null) {
      setState(() {
        totalPriceCart -= double.parse(coupons.couponUsed.amount).toInt();
      });
    }
    if (totalPriceCart < 0) {
      setState(() {
        totalPriceCart = 0;
      });
    }
  }*/
}
