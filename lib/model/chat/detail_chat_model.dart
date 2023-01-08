class ChatDetail {
  String? chatId;
  String? senderId;
  String? receiverId;
  String? message;
  String? type;
  String? postId;
  String? typeMessage;
  String? status;
  String? potition;
  String? image;
  String? createdAt;
  List<Subject>? subject;

  ChatDetail(
      {this.chatId,
      this.senderId,
      this.receiverId,
      this.message,
      this.type,
      this.postId,
      this.typeMessage,
      this.status,
      this.potition,
      this.createdAt,
      this.image,
      this.subject});

  ChatDetail.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    type = json['type'];
    postId = json['post_id'];
    typeMessage = json['type_message'];
    status = json['status'];
    image = json['image'];
    potition = json['potition'];
    createdAt = json['created_at'];
    if (json['subject'] != null) {
      subject = [];
      json['subject'].forEach((v) {
        subject!.add(new Subject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_id'] = this.chatId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['message'] = this.message;
    data['type'] = this.type;
    data['post_id'] = this.postId;
    data['image'] = this.image;
    data['type_message'] = this.typeMessage;
    data['status'] = this.status;
    data['potition'] = this.potition;
    data['created_at'] = this.createdAt;
    if (this.subject != null) {
      data['subject'] = this.subject!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subject {
  int? productId;
  String? productName;
  dynamic productPrice;
  String? productFormattedPrice;
  List<ProductImages>? productImages;

  Subject(
      {this.productId,
      this.productName,
      this.productPrice,
      this.productFormattedPrice,
      this.productImages});

  Subject.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    productFormattedPrice = json['product_formatted_price'];
    if (json['product_images'] != null) {
      productImages = [];
      json['product_images'].forEach((v) {
        productImages!.add(new ProductImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['product_formatted_price'] = this.productFormattedPrice;
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImages {
  int? id;
  String? src;
  String? name;
  String? alt;
  int? position;

  ProductImages({this.id, this.src, this.name, this.alt, this.position});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'];
    name = json['name'];
    alt = json['alt'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['src'] = this.src;
    data['name'] = this.name;
    data['alt'] = this.alt;
    data['position'] = this.position;
    return data;
  }
}

class ListChat {
  String? id;
  String? receiverId;
  String? photo;
  String? sellerName;
  String? status;
  String? createdAt;
  String? unread;

  ListChat(
      {this.id,
      this.receiverId,
      this.photo,
      this.sellerName,
      this.status,
      this.createdAt,
      this.unread});

  ListChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverId = json['receiver_id'];
    photo = json['photo'];
    sellerName = json['seller_name'];
    status = json['status'];
    createdAt = json['created_at'];
    unread = json['unread'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receiver_id'] = this.receiverId;
    data['photo'] = this.photo;
    data['seller_name'] = this.sellerName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['unread'] = this.unread;
    return data;
  }
}
