import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catalinadev/model/cart/checkout_model.dart';
import 'package:catalinadev/model/order/order_model.dart';
import 'package:catalinadev/model/product/product_model.dart';
import 'package:catalinadev/provider/cart_provider.dart';
import 'package:catalinadev/services/order_api.dart';
import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/shared.dart';
import 'package:catalinadev/utils/utility.dart';
import 'package:catalinadev/widget/webview/checkout_webview.dart';

class OrderProvider with ChangeNotifier {
  ProductModel? productDetail;
  String? status;
  String? search;

  bool isLoading = false;
  bool isLoadingStatus = false;

  bool loadDataOrder = false;

  List<OrderModel> listOrder = [];
  List<OrderModel> listOrderVendor = [];

  List<ProductModel> listProductOrder = [];

  OrderModel? detailOrder;

  Future checkout(order) async {
    var result;
    try {
      await OrderAPI().checkoutOrder(order).then((data) {
        printLog(data, name: 'Link Order From API');
        result = data;
      });
      return result;
    } catch (e) {
      return result;
    }
  }

  Future<List?> fetchOrders({status, search}) async {
    var result;
    isLoading = true;
    await OrderAPI().listMyOrder(status, search).then((data) {
      result = data;
      listOrder.clear();

      printLog(result.toString());

      for (Map item in result) {
        listOrder.add(OrderModel.fromJson(item));
      }

      listOrder.forEach((element) {
        List<MyOrder> listMyOrder = [];
        element.productItems!.forEach((elementProduct) {
          int index = listMyOrder.indexWhere(
              (store) => store.vendor!.id == elementProduct.vendor!.id);

          if (index != -1) {
            listMyOrder[index].lineItems!.add(elementProduct);
          } else {
            List<ProductItems> _list = [];
            _list.add(elementProduct);
            listMyOrder.add(
                new MyOrder(vendor: elementProduct.vendor, lineItems: _list));
          }
          element.orders = listMyOrder;
        });
        printLog(element.orders!.length.toString(), name: "Length");
      });

      isLoading = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<List?> fetchOrdersVendor({page}) async {
    var result;
    try {
      isLoading = true;
      await OrderAPI().listOrderVendor(page).then((data) {
        result = data;

        if (page == 1) {
          listOrderVendor.clear();
        }

        // printLog(result.toString());

        for (Map item in result) {
          listOrderVendor.add(OrderModel.fromJson(item));
        }

        isLoading = false;
        notifyListeners();
        printLog(json.encode(listOrderVendor));
      });
      return result;
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
      return result;
    }
  }

  Future<List?> fetchDetailOrder(orderId) async {
    var result;
    isLoading = true;
    notifyListeners();
    try {
      await OrderAPI().detailOrder(orderId).then((data) {
        result = data;
        printLog(result.toString());

        for (Map item in result) {
          detailOrder = OrderModel.fromJson(item);
        }

        List<MyOrder> listMyOrder = [];
        detailOrder!.productItems!.forEach((elementProduct) {
          int index = listMyOrder.indexWhere(
              (store) => store.vendor!.id == elementProduct.vendor!.id);

          if (index != -1) {
            listMyOrder[index].lineItems!.add(elementProduct);
          } else {
            List<ProductItems> _list = [];
            _list.add(elementProduct);
            listMyOrder.add(
                new MyOrder(vendor: elementProduct.vendor, lineItems: _list));
          }
          detailOrder!.orders = listMyOrder;
        });

        isLoading = false;
        notifyListeners();
        printLog(result.toString());
      });
      return result;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return result;
    }
  }

  Future<bool> updateStatusOrderVendor(context, {orderId, status}) async {
    var result;
    try {
      isLoadingStatus = true;
      await OrderAPI().updateOrderStatus(orderId, status).then((data) {
        result = data;

        if (result['status'] == 'success') {
          Navigator.pop(context, '200');
          snackBar(context,
              message: 'Successfully updated order status',
              color: Colors.green);
        } else {
          snackBar(context,
              message: 'Failed to update order status', color: Colors.red);
        }
        isLoadingStatus = false;
        notifyListeners();
        printLog(result.toString());
      });
      return true;
    } catch (e) {
      isLoadingStatus = false;
      notifyListeners();
      snackBar(context,
          message: 'Failed to update order status, contact the developer.',
          color: Colors.red);
      return false;
    }
  }

  Future<int> loadCartCount() async {
    List<ProductModel> productCart = [];
    int _count = 0;

    if (Session.data.containsKey('cart')) {
      List listCart = await json.decode(Session.data.getString('cart')!);

      productCart = listCart
          .map((product) => new ProductModel.fromJson(product))
          .toList();

      productCart.forEach((element) {
        _count += element.cartQuantity!;
      });
    }
    return _count;
  }

  Future checkOutOrder(context,
      {Future<dynamic> Function()? removeOrderedItems}) async {
    // final coupons = Provider.of<CouponProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (cartProvider.totalSelected == 0) {
      snackBar(context, message: "Please select the product first.");
    } else {
      if (Session.data.getBool('isLogin')!) {
        CheckoutModel cart = new CheckoutModel();
        cart.listItem = [];

        cartProvider.listCart.forEach((element) {
          element.products!.forEach((elementProduct) {
            if (elementProduct.isSelected!) {
              var variation = {};
              if (elementProduct.selectedVariation!.isNotEmpty) {
                elementProduct.selectedVariation!.forEach((elementVar) {
                  variation['attribute_${elementVar.columnName}'] =
                      "${elementVar.value}";
                });
              }
              cart.listItem!.add(new CheckoutProductItem(
                  productId: elementProduct.id,
                  quantity: elementProduct.cartQuantity,
                  variationId: elementProduct.variantId,
                  variation: [variation]));
              // print(map2);
              // print(variation);
            }
          });
        });

        //init list coupon
        cart.listCoupon = [];
        //check coupon
        // if (coupons.couponUsed != null) {
        //   cart.listCoupon.add(new CheckoutCoupon(code: coupons.couponUsed.code));
        // }

        //add to cart model
        cart.paymentMethod = "xendit_bniva";
        cart.paymentMethodTitle = "Bank Transfer - BNI";
        cart.setPaid = true;
        cart.customerId = Session.data.getInt('id');
        cart.status = 'completed';
        cart.token = Session.data.getString('cookie');

        //Encode Json
        final jsonOrder = json.encode(cart);
        printLog(jsonOrder, name: 'Json Order');

        //Convert Json to bytes
        var bytes = utf8.encode(jsonOrder);

        //Convert bytes to base64
        var order = base64.encode(bytes);

        //Generate link WebView checkout
        await this.checkout(order).then((value) async {
          printLog(value, name: 'Link Order');
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckoutWebView(
                        url: value,
                        onFinish: removeOrderedItems,
                      )));
        });
      } else {
        snackBar(context,
            message: AppLocalizations.of(context)!.translate("login_first")!);
      }
    }
  }

  Future buyNow(context, ProductModel product,
      Future<dynamic> Function() onFinishBuyNow) async {
    if (Session.data.getBool('isLogin')!) {
      CheckoutModel cart = new CheckoutModel();
      cart.listItem = [];
      cart.listItem!.add(new CheckoutProductItem(
          productId: product.id,
          quantity: product.cartQuantity,
          variationId: product.variantId));

      //init list coupon
      cart.listCoupon = [];

      //add to cart model
      cart.paymentMethod = "xendit_bniva";
      cart.paymentMethodTitle = "Bank Transfer - BNI";
      cart.setPaid = true;
      cart.customerId = Session.data.getInt('id');
      cart.status = 'completed';
      cart.token = Session.data.getString('cookie');

      //Encode Json
      final jsonOrder = json.encode(cart);
      printLog(jsonOrder, name: 'Json Order');

      //Convert Json to bytes
      var bytes = utf8.encode(jsonOrder);

      //Convert bytes to base64
      var order = base64.encode(bytes);

      //Generate link WebView checkout
      await Provider.of<OrderProvider>(context, listen: false)
          .checkout(order)
          .then((value) async {
        printLog(value, name: 'Link Order');
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutWebView(
              url: value,
              onFinish: onFinishBuyNow,
            ),
          ),
        );
      });
    } else {
      snackBar(context, message: "You should login first.");
    }
  }

  Future loadItemOrder(context) async {
    loadDataOrder = true;
    if (detailOrder != null) {
      listProductOrder.clear();
      detailOrder!.productItems!.forEach((element) async {
        /*await Provider.of<ProductProvider>(context, listen: false)
            .fetchProductDetail(element.productId.toString())
            .then((value) {
          listProductOrder.add(value);
        });*/
      });
      loadDataOrder = false;
    }
  }

  Future<void> actionBuyAgain(context) async {
    detailOrder!.productItems!.forEach((elementOrder) {
      listProductOrder.forEach((element) {
        if (element.id == elementOrder.productId) {
          element.cartQuantity = elementOrder.quantity;
          element.variantId = elementOrder.variationId;
          element.priceTotal = element.productPrice * element.cartQuantity;
          element.attributes!.forEach((elementAttr) {
            elementOrder.metaData!.forEach((elementMeta) {
              if (elementAttr.name!.toLowerCase().replaceAll(" ", "-") ==
                  elementMeta.key) {
                elementAttr.selectedVariant = elementMeta.value;
              }
            });
          });
        }
      });
    });
    for (int i = 0; i < listProductOrder.length; i++) {
      await addCart(listProductOrder[i], context);
    }
    snackBar(context, message: 'Successfully added to your cart');
  }

  /*add to cart*/
  Future addCart(ProductModel product, context) async {
    /*check sharedprefs for cart*/
    if (!Session.data.containsKey('cart')) {
      List<ProductModel> listCart = [];

      listCart.add(product);

      await Session.data.setString('cart', json.encode(listCart));
    } else {
      List products = await json.decode(Session.data.getString('cart')!);

      printLog(products.length.toString());
      printLog(products.toString(), name: 'Cart Product');

      List<ProductModel> listCart =
          products.map((product) => ProductModel.fromJson(product)).toList();

      printLog(listCart.toString(), name: 'List Cart');

      int index = products.indexWhere((prod) =>
          prod["id"] == product.id && prod["variant_id"] == product.variantId);

      if (index != -1) {
        product.cartQuantity =
            listCart[index].cartQuantity! + product.cartQuantity!;

        listCart[index] = product;

        await Session.data.setString('cart', json.encode(listCart));
      } else {
        listCart.add(product);
        await Session.data.setString('cart', json.encode(listCart));
      }
    }
  }
}
