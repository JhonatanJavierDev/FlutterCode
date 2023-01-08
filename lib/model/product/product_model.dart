import 'package:catalinadev/model/product/attribute_model.dart';
import 'package:catalinadev/model/product/product_dimensions_model.dart';
import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/utility.dart';

class ProductModel {
  int? id,
      totalSales,
      productStock,
      ratingCount,
      cartQuantity,
      variantId,
      productStockManage;
  double? discProduct;
  ProductDimensionsModel? dimensions;
  var priceTotal, productPrice, productRegPrice, productSalePrice;
  String? productName,
      productSlug,
      productDescription,
      productShortDesc,
      productSku,
      formattedPrice,
      formattedSalePrice,
      avgRating,
      link,
      type,
      relatedProductsId = '',
      stockStatus;
  bool? isSelected = false;
  bool isProductWholeSale = false;
  List<ProductImageModel>? images;
  List<ProductCategoryModel>? categories;
  List<ProductAttributeModel>? attributes;
  List<ProductMetaData>? metaData;
  List<ProductVideo>? videos;
  List<AttributeModel>? listAttr;
  List<dynamic>? relatedIds;
  bool? isWishList;
  Vendor? vendor;
  List<dynamic>? availableVariations;
  List<ProductVariation>? selectedVariation = [];
  String? variationName;
  List<double?>? variationPrices = [];
  List<double?>? variationRegPrices = [];
  List<int>? discVariation = [];
  bool? isVariationDiscount = false;

  ProductModel(
      {this.id,
      this.totalSales,
      this.productStock,
      this.productName,
      this.productSlug,
      this.productDescription,
      this.productShortDesc,
      this.productSku,
      this.productPrice,
      this.productRegPrice,
      this.productSalePrice,
      this.formattedPrice,
      this.formattedSalePrice,
      this.listAttr,
      this.dimensions,
      this.images,
      this.categories,
      this.ratingCount,
      this.avgRating,
      this.discProduct,
      this.attributes,
      this.cartQuantity,
      this.isSelected,
      this.priceTotal,
      this.variantId,
      this.link,
      this.metaData,
      this.videos,
      this.vendor,
      this.relatedIds,
      this.relatedProductsId,
      this.type,
      this.isWishList,
      this.stockStatus,
      this.availableVariations,
      this.selectedVariation,
      this.variationName,
      this.variationPrices,
      this.variationRegPrices,
      this.isVariationDiscount,
      this.discVariation,
      this.productStockManage});

  Map toJson() => {
        'id': id,
        'total_sales': totalSales,
        'stock_quantity': productStock,
        'name': productName,
        'slug': productSlug,
        'description': productDescription,
        'short_description': productShortDesc,
        'sku': productSku,
        'price': productPrice,
        'regular_price': productRegPrice,
        'sale_price': productSalePrice,
        'formated_price': formattedPrice,
        'formated_sales_price': formattedSalePrice,
        'type': type,
        'images': images,
        'categories': categories,
        'average_rating': avgRating,
        'rating_count': ratingCount,
        'attributes': listAttr,
        'disc': discProduct,
        'cart_quantity': cartQuantity,
        'is_selected': isSelected,
        'price_total': priceTotal,
        'variant_id': variantId,
        'permalink': link,
        'meta_data': metaData,
        'videos': videos,
        'vendor': vendor,
        'related_ids': relatedIds,
        'related_id_product': relatedProductsId,
        'is_wistlist': isWishList,
        'stock_status': stockStatus,
        'availabelVariations': availableVariations,
        'selected_variation': selectedVariation,
        'variation_name': variationName,
        'variation_prices': variationPrices,
        'variation_reg_prices': variationRegPrices,
        'dimensions': dimensions!.toJson(),
        'product_stock_manage': productStockManage
      };

  ProductModel.fromJson(Map json) {
    id = json['id'];
    totalSales = json['total_sales'];
    productStock =
        json['stock_status'] == 'instock' && json['stock_quantity'] == null ||
                json['stock_quantity'] == 0
            ? 999
            : json['stock_quantity'];
    productName = json['name'];
    productSlug = json['slug'];
    productDescription = json['description'];
    productShortDesc = json['short_description'];
    productSku = json['sku'];
    type = json['type'];
    link = json['permalink'];
    stockStatus = json['stock_status'];
    productPrice =
        json['price'] != null && json['price'] != '' ? json['price'] : '0';
    productRegPrice =
        json['regular_price'] != null && json['regular_price'] != ''
            ? json['regular_price']
            : '0';
    productSalePrice = json['sale_price'];
    avgRating = json['average_rating'];
    ratingCount = json['rating_count'];
    formattedPrice = convertHtmlUnescape(json['formated_price']);
    if (json['formated_sales_price'] != null) {
      formattedSalePrice = convertHtmlUnescape(json['formated_sales_price']);
    }

    if (json['dimensions'] != null) {
      dimensions = ProductDimensionsModel.fromJson(json['dimensions']);
    }

    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images!.add(new ProductImageModel.fromJson(v));
      });
    }
    if (json['categories'] != null && json['categories'] != false) {
      categories = [];
      json['categories'].forEach((v) {
        categories!.add(new ProductCategoryModel.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = [];
      listAttr = [];
      json['attributes'].forEach((v) {
        //listAttr!.add(new AttributeModel.fromJson(v));
        attributes!.add(new ProductAttributeModel.fromJson(v));
      });
    }
    cartQuantity = json['cart_quantity'];
    discProduct = productRegPrice != 0
        ? discProduct =
            ((productRegPrice.toDouble() - productPrice.toDouble()) /
                    productRegPrice.toDouble()) *
                100
        : discProduct = 0;
    isSelected = json['is_selected'];
    priceTotal = json['price_total'];
    variantId = json['variant_id'];
    isWishList = json['is_wistlist'];
    if (json['meta_data'] != null) {
      metaData = [];
      videos = [];
      json['meta_data'].forEach((v) {
        metaData!.add(new ProductMetaData.fromJson(v));
        if (v['key'] == 'wholesale_customer_have_wholesale_price' &&
            v['value'] == 'yes') {
          isProductWholeSale = true;
        }
        if (v['key'] == '_ywcfav_video') {
          v['value'].forEach((valVideo) {
            videos!.add(new ProductVideo.fromJson(valVideo));
          });
        }
      });
    }
    if (isProductWholeSale &&
        Session.data.getString('role') == 'wholesale_customer') {
      metaData!.forEach((element) {
        if (element.key == 'wholesale_customer_wholesale_price') {
          discProduct = 0;
          productSalePrice = 0;
          productRegPrice = 0;
          productPrice = element.value;
        }
      });
    }
    if (json['related_ids'] != null) {
      relatedIds = [];
      json['related_ids'].forEach((v) {
        relatedIds!.add(v);
      });
      if (relatedIds!.isNotEmpty) {
        relatedProductsId = relatedIds!.join(",");
      }
    }
    vendor = new Vendor.fromJson(json['vendor']);
    if (json['availableVariations'] != null) {
      availableVariations = json['availableVariations'];
      json['availableVariations'].forEach((v) {
        variationPrices!.add(v['display_price'].toDouble());
        variationRegPrices!.add(v['display_regular_price'].toDouble());
        if (v['display_price'] != v['display_regular_price']) {
          isVariationDiscount = true;
          double disc = ((v['display_regular_price'].toDouble() -
                      v['display_price'].toDouble()) /
                  v['display_regular_price'].toDouble()) *
              100;
          discVariation!.add(disc.toInt());
        }
      });
      print(variationRegPrices);
      variationPrices!.sort((a, b) => a!.compareTo(b!));
      variationRegPrices!.sort((a, b) => a!.compareTo(b!));
      discVariation!.sort((a, b) => a.compareTo(b));
    }
    if (json['selected_variation'] != null) {
      selectedVariation = [];
      json['selected_variation'].forEach((v) {
        selectedVariation!.add(new ProductVariation.fromJson(v));
      });
    }
    if (json['variation_name'] != null) {
      variationName = json['variation_name'];
    }
    productStockManage = json['stock_quantity'];
  }

  @override
  String toString() {
    return 'ProductModel{id: $id, totalSales: $totalSales, productStock: $productStock, ratingCount: $ratingCount, cartQuantity: $cartQuantity, priceTotal: $priceTotal, variantId: $variantId, discProduct: $discProduct, productName: $productName, productSlug: $productSlug, productDescription: $productDescription, productShortDesc: $productShortDesc, productSku: $productSku, productPrice: $productPrice, productRegPrice: $productRegPrice, productSalePrice: $productSalePrice, avgRating: $avgRating, link: $link, isSelected: $isSelected, images: $images, categories: $categories, attributes: $attributes}';
  }
}

class ProductImageModel {
  int? id;
  String? dateCreated, dateModified, src, name, alt;

  ProductImageModel(
      {this.dateCreated,
      this.dateModified,
      this.src,
      this.name,
      this.alt,
      this.id});

  Map toJson() => {
        'id': id,
        'date_created': dateCreated,
        'date_modified': dateModified,
        'src': src,
        'name': name,
        'alt': alt,
      };

  ProductImageModel.fromJson(Map json)
      : id = json['id'],
        dateCreated = json['date_created'],
        dateModified = json['date_modified'],
        src = json['src'],
        name = json['name'],
        alt = json['alt'];
}

class ProductCategoryModel {
  int? id;
  String? name, slug, description;
  var image;
  List<ProductCategoryModel>? subCategories;

  ProductCategoryModel(
      {this.slug, this.name, this.id, this.image, this.description});

  Map toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'image': image,
        'description': description,
        'sub_categories': subCategories
      };

  ProductCategoryModel.fromJson(Map json) {
    id = json['id'] ?? json['term_id'];
    name = convertHtmlUnescape(json['name']);
    slug = json['slug'];
    description = json["description"];
    if (json['image'] != null && json['image'] != '') {
      if (json['image'] != false) {
        image = json['image'];
      }
    }
    if (json['sub_categories'] != null) {
      subCategories = [];
      json['sub_categories'].forEach((v) {
        subCategories!.add(new ProductCategoryModel.fromJson(v));
      });
    }
  }
}

class ProductAttributeModel {
  int? id, position;
  String? name, selectedVariant;
  bool? visible, variation;
  List<dynamic>? options;

  ProductAttributeModel(
      {this.id,
      this.position,
      this.name,
      this.visible,
      this.variation,
      this.options,
      this.selectedVariant});

  Map toJson() => {
        'id': id,
        'position': position,
        'name': name,
        'visible': visible,
        'variation': variation,
        'options': options,
        'selected_variant': selectedVariant
      };

  ProductAttributeModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        position = json['position'],
        visible = json['visible'],
        variation = json['variation'],
        options = json['options'],
        selectedVariant = json['selected_variant'];
}

class ProductVariation {
  int? id;
  String? columnName;
  String? value;

  ProductVariation({this.id, this.value, this.columnName});

  Map toJson() => {
        'id': id,
        'column_name': columnName!.toLowerCase(),
        'value': value,
      };

  ProductVariation.fromJson(Map json)
      : id = json['id'],
        columnName = json['column_name'],
        value = json['value'];

  @override
  String toString() {
    return 'ProductVariation{id: $id ,columnName: $columnName, value: $value}';
  }
}

class ProductMetaData {
  int? id;
  String? key;
  var value;

  ProductMetaData({this.id, this.key, this.value});

  Map toJson() => {
        'id': id,
        'key': key,
        'value': value,
      };

  ProductMetaData.fromJson(Map json)
      : id = json['id'],
        key = json['key'],
        value = json['value'];
}

class ProductVideo {
  String? thumbnail, id, type, featured, name, host, content;

  ProductVideo(
      {this.thumbnail,
      this.id,
      this.type,
      this.featured,
      this.name,
      this.host,
      this.content});

  Map toJson() => {
        'thumbnail': thumbnail,
        'id': id,
        'type': type,
        'featured': featured,
        'name': name,
        'host': host,
        'content': content,
      };

  ProductVideo.fromJson(Map json)
      : thumbnail = json['thumbn'],
        id = json['id'],
        type = json['type'],
        featured = json['featured'],
        name = json['name'],
        host = json['host'],
        content = json['content'];
}

class Vendor {
  var id, icon;
  String? name;
  String? address;
  bool? isClose;

  Vendor({this.id, this.name, this.icon, this.address, this.isClose});

  Map toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'address': address,
        'is_close': isClose
      };

  Vendor.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        icon = json['icon'],
        address = json['address'],
        isClose = json['is_close'] ?? false;
}
