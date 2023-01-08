class ListNotification {
  int? userId;
  int? orderId;
  String? status;
  String? image;
  String? createdAt;

  ListNotification(
      {this.userId, this.orderId, this.status, this.image, this.createdAt});

  ListNotification.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    orderId = json['order_id'];
    status = json['status'];
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    return data;
  }
}
