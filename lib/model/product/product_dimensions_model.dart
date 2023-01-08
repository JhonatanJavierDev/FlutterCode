class ProductDimensionsModel {
  String? length;
  String? width;
  String? height;
  String? weight;

  ProductDimensionsModel({this.length, this.width, this.height, this.weight});

  ProductDimensionsModel.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    width = json['width'];
    height = json['height'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['weight'] = this.weight;
    return data;
  }
}