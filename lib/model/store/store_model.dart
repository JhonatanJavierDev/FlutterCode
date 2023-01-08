import 'dart:io';

class StoreModel {
  int? id;
  var averageRating, ratingCount;
  String? name, icon, banner, address, description, latitude, longitude;
  int? bannerID, iconID;
  bool? isClose;
  Sales? sales;
  AddressDetail? addressDetail;
  List<CategoriesStore>? categories;
  BankAccount? bankAccount;

  StoreModel({
    this.id,
    this.averageRating,
    this.ratingCount,
    this.name,
    this.icon,
    this.banner,
    this.bannerID,
    this.iconID,
    this.address,
    this.description,
    this.latitude,
    this.longitude,
    this.isClose,
    this.sales,
    this.addressDetail,
    this.categories,
    this.bankAccount,
  });

  Map toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'banner': banner,
        'banner_id': bannerID,
        'icon_id': iconID,
        'address': address,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'average_rating': averageRating,
        'rating_count': ratingCount,
        'is_close': isClose,
        'sales': sales,
        'address_detail': addressDetail,
        'categories': categories,
        'bank_account': bankAccount,
      };

  StoreModel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    banner = json['banner'];
    bannerID = json['banner_id'];
    iconID = json['icon_id'];
    address = json['address'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    averageRating = json['average_rating'];
    ratingCount = json['rating_count'];
    sales = Sales.fromJson(json['sales']);
    if (json['address_detail'] != null) {
      addressDetail = AddressDetail.fromJson(json['address_detail']);
    }
    isClose = json['is_close'];
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories!.add(new CategoriesStore.fromJson(v));
      });
    }

    if (json["bank_account"] != null) {
      bankAccount = BankAccount.fromJson(json['bank_account']);
    }
  }
}

class BankAccount {
  String? acName;
  String? acNumber;
  String? bankName;
  String? bankAddr;
  String? routingNumber;

  BankAccount(
      {this.acName,
      this.acNumber,
      this.bankName,
      this.bankAddr,
      this.routingNumber});

  BankAccount.fromJson(Map<String, dynamic> json) {
    acName = json['ac_name'];
    acNumber = json['ac_number'];
    bankName = json['bank_name'];
    bankAddr = json['bank_addr'];
    routingNumber = json['routing_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ac_name'] = this.acName;
    data['ac_number'] = this.acNumber;
    data['bank_name'] = this.bankName;
    data['bank_addr'] = this.bankAddr;
    data['routing_number'] = this.routingNumber;
    return data;
  }
}

class CategoriesStore {
  int? id, totalProduct;
  String? name, slug;

  CategoriesStore({this.id, this.totalProduct, this.name, this.slug});

  Map toJson() =>
      {'id': id, 'name': name, 'slug': slug, 'total_product': totalProduct};

  CategoriesStore.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    totalProduct = json['total_product'];
  }
}

class AddressDetail {
  String? street1;
  String? city;
  var zip;
  String? country;
  String? state;
  String? storeSlug;

  AddressDetail(
      {this.street1,
      this.city,
      this.zip,
      this.country,
      this.state,
      this.storeSlug});

  AddressDetail.fromJson(Map<String, dynamic> json) {
    street1 = json['street_1'];
    city = json['city'];
    zip = json['zip'].toString();
    country = json['country'];
    state = json['state'];
    storeSlug = json['store_slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street_1'] = this.street1;
    data['city'] = this.city;
    data['zip'] = this.zip;
    data['country'] = this.country;
    data['state'] = this.state;
    data['store_slug'] = this.storeSlug;
    return data;
  }
}

class Sales {
  int? amountSales, adminCharge, productSales, approvedSales;
  Sales(
      {this.amountSales,
      this.adminCharge,
      this.productSales,
      this.approvedSales});

  Map toJson() => {
        'amount_sales': amountSales,
        'admin_charge': adminCharge,
        'product_sales': productSales,
        'approved_sales': approvedSales
      };
  Sales.fromJson(Map json) {
    amountSales = json['amount_sales'];
    adminCharge = json['admin_charge'];
    productSales = json['product_sales'];
    approvedSales = json['approved_sales'];
  }
}

class ProductImage {
  int? id;
  String? image;
  File? imgFile;

  ProductImage({this.id, this.image, this.imgFile});

  Map toJson() => {'id': id, 'image': image};

  ProductImage.fromJson(Map json) {
    id = json['id'];
    image = json['image'];
  }

  @override
  String toString() {
    return 'ProductImage{id: $id, image: $image}';
  }
}

class MessageToko {
  String? status;
  String? message;

  MessageToko({this.status, this.message});

  MessageToko.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
