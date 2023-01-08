class CreateVendor {
  // String storeName;
  // List<Null> social;
  // Payment payment;
  // String phone;
  // String storeEmail;
  // String showEmail;
  // Address address;
  // String location;
  // int storeLat;
  // int storeLng;
  // int listBanner;
  // int banner;
  // int icon;
  // int gravatar;
  // int storePpp;
  // StoreSeo storeSeo;
  // List<Null> customerSupport;
  // String storeHideEmail;
  // String storeHidePhone;
  // String storeHideAddress;
  // String storeHideMap;
  // String storeHideDescription;
  // String storeHidePolicy;
  // String avatar;
  String? role;

  CreateVendor({
    // this.storeName,
    // this.social,
    // this.payment,
    // this.phone,
    // this.storeEmail,
    // this.showEmail,
    // this.address,
    // this.location,
    // this.storeLat,
    // this.storeLng,
    // this.listBanner,
    // this.banner,
    // this.icon,
    // this.gravatar,
    // this.storePpp,
    // this.storeSeo,
    // this.customerSupport,
    // this.storeHideEmail,
    // this.storeHidePhone,
    // this.storeHideAddress,
    // this.storeHideMap,
    // this.storeHideDescription,
    // this.storeHidePolicy,
    // this.avatar,
    this.role,
  });

  CreateVendor.fromJson(Map<String, dynamic> json) {
    // storeName = json['store_name'];
    // if (json['social'] != null) {
    //   social = new List<Null>();
    //   json['social'].forEach((v) {
    //     social.add(new Null.fromJson(v));
    //   });
    // }
    // payment =
    //     json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    // phone = json['phone'];
    // storeEmail = json['store_email'];
    // showEmail = json['show_email'];
    // address =
    //     json['address'] != null ? new Address.fromJson(json['address']) : null;
    // location = json['location'];
    // storeLat = json['store_lat'];
    // storeLng = json['store_lng'];
    // listBanner = json['list_banner'];
    // banner = json['banner'];
    // icon = json['icon'];
    // gravatar = json['gravatar'];
    // storePpp = json['store_ppp'];
    // storeSeo = json['store_seo'] != null
    //     ? new StoreSeo.fromJson(json['store_seo'])
    //     : null;
    // if (json['customer_support'] != null) {
    //   customerSupport = new List<Null>();
    //   json['customer_support'].forEach((v) {
    //     customerSupport.add(new Null.fromJson(v));
    //   });
    // }
    // storeHideEmail = json['store_hide_email'];
    // storeHidePhone = json['store_hide_phone'];
    // storeHideAddress = json['store_hide_address'];
    // storeHideMap = json['store_hide_map'];
    // storeHideDescription = json['store_hide_description'];
    // storeHidePolicy = json['store_hide_policy'];
    // avatar = json['avatar'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['store_name'] = this.storeName;
    // if (this.social != null) {
    //   data['social'] = this.social.map((v) => v.toJson()).toList();
    // }
    // if (this.payment != null) {
    //   data['payment'] = this.payment.toJson();
    // }
    // data['phone'] = this.phone;
    // data['store_email'] = this.storeEmail;
    // data['show_email'] = this.showEmail;
    // if (this.address != null) {
    //   data['address'] = this.address.toJson();
    // }
    // data['location'] = this.location;
    // data['store_lat'] = this.storeLat;
    // data['store_lng'] = this.storeLng;
    // data['list_banner'] = this.listBanner;
    // data['banner'] = this.banner;
    // data['icon'] = this.icon;
    // data['gravatar'] = this.gravatar;
    // data['store_ppp'] = this.storePpp;
    // if (this.storeSeo != null) {
    //   data['store_seo'] = this.storeSeo.toJson();
    // }
    // if (this.customerSupport != null) {
    //   data['customer_support'] =
    //       this.customerSupport.map((v) => v.toJson()).toList();
    // }
    // data['store_hide_email'] = this.storeHideEmail;
    // data['store_hide_phone'] = this.storeHidePhone;
    // data['store_hide_address'] = this.storeHideAddress;
    // data['store_hide_map'] = this.storeHideMap;
    // data['store_hide_description'] = this.storeHideDescription;
    // data['store_hide_policy'] = this.storeHidePolicy;
    // data['avatar'] = this.avatar;
    data['role'] = this.role;
    return data;
  }
}

class Payment {
  List<String>? paypal;
  List<Null>? bank;

  Payment({this.paypal, this.bank});

  Payment.fromJson(Map<String, dynamic> json) {
    paypal = json['paypal'].cast<String>();
    // if (json['bank'] != null) {
    //   bank = new List<Null>();
    //   json['bank'].forEach((v) {
    //     bank.add(new Null.fromJson(v));
    //   });
    // }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['paypal'] = this.paypal;
  //   if (this.bank != null) {
  //     data['bank'] = this.bank.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Address {
  String? street1;
  String? city;
  String? zip;
  String? country;
  String? state;
  String? storeSlug;

  Address(
      {this.street1,
      this.city,
      this.zip,
      this.country,
      this.state,
      this.storeSlug});

  Address.fromJson(Map<String, dynamic> json) {
    street1 = json['street_1'];
    city = json['city'];
    zip = json['zip'];
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

class StoreSeo {
  String? wcfmmpSeoMetaTitle;
  String? wcfmmpSeoMetaDesc;
  String? wcfmmpSeoMetaKeywords;
  String? wcfmmpSeoOgTitle;
  String? wcfmmpSeoOgDesc;
  String? wcfmmpSeoOgImage;
  String? wcfmmpSeoTwitterTitle;
  String? wcfmmpSeoTwitterDesc;
  String? wcfmmpSeoTwitterImage;

  StoreSeo(
      {this.wcfmmpSeoMetaTitle,
      this.wcfmmpSeoMetaDesc,
      this.wcfmmpSeoMetaKeywords,
      this.wcfmmpSeoOgTitle,
      this.wcfmmpSeoOgDesc,
      this.wcfmmpSeoOgImage,
      this.wcfmmpSeoTwitterTitle,
      this.wcfmmpSeoTwitterDesc,
      this.wcfmmpSeoTwitterImage});

  StoreSeo.fromJson(Map<String, dynamic> json) {
    wcfmmpSeoMetaTitle = json['wcfmmp-seo-meta-title'];
    wcfmmpSeoMetaDesc = json['wcfmmp-seo-meta-desc'];
    wcfmmpSeoMetaKeywords = json['wcfmmp-seo-meta-keywords'];
    wcfmmpSeoOgTitle = json['wcfmmp-seo-og-title'];
    wcfmmpSeoOgDesc = json['wcfmmp-seo-og-desc'];
    wcfmmpSeoOgImage = json['wcfmmp-seo-og-image'];
    wcfmmpSeoTwitterTitle = json['wcfmmp-seo-twitter-title'];
    wcfmmpSeoTwitterDesc = json['wcfmmp-seo-twitter-desc'];
    wcfmmpSeoTwitterImage = json['wcfmmp-seo-twitter-image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wcfmmp-seo-meta-title'] = this.wcfmmpSeoMetaTitle;
    data['wcfmmp-seo-meta-desc'] = this.wcfmmpSeoMetaDesc;
    data['wcfmmp-seo-meta-keywords'] = this.wcfmmpSeoMetaKeywords;
    data['wcfmmp-seo-og-title'] = this.wcfmmpSeoOgTitle;
    data['wcfmmp-seo-og-desc'] = this.wcfmmpSeoOgDesc;
    data['wcfmmp-seo-og-image'] = this.wcfmmpSeoOgImage;
    data['wcfmmp-seo-twitter-title'] = this.wcfmmpSeoTwitterTitle;
    data['wcfmmp-seo-twitter-desc'] = this.wcfmmpSeoTwitterDesc;
    data['wcfmmp-seo-twitter-image'] = this.wcfmmpSeoTwitterImage;
    return data;
  }
}
