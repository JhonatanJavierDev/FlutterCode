class CheckoutModel {
  // Model
  int? customerId;
  String? paymentMethod;
  String? paymentMethodTitle;
  bool? setPaid;
  String? status;
  String? token;
  List<CheckoutProductItem>? listItem = [];
  List<CheckoutCoupon>? listCoupon = [];

  CheckoutModel(
      {this.customerId,
        this.paymentMethod,
        this.paymentMethodTitle,
        this.setPaid,
        this.status,
        this.token,
        this.listItem,
        this.listCoupon});

  Map toJson() => {
    'payment_method': paymentMethod,
    'payment_method_title': paymentMethodTitle,
    'set_paid': setPaid,
    'customer_id': customerId,
    'status': status,
    'token': token,
    'line_items': listItem,
    'coupon_lines': listCoupon,
  };
}

class CheckoutProductItem {
  final int? productId;
  final int? quantity;
  final int? variationId;
  List<dynamic>? variation = [];

  CheckoutProductItem({this.productId, this.quantity, this.variationId, this.variation});

  Map toJson() => {
    'product_id': productId,
    'quantity': quantity,
    'variation_id': variationId,
    'variation': variation
  };
}

class CheckoutCoupon {
  final String? code;

  CheckoutCoupon({this.code});

  Map toJson() => {
    'code': code,
  };
}
