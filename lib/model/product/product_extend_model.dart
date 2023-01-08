class ProductExtendModel {
  // Model
  final String? title;
  final String? description;
  final String? products;

  ProductExtendModel({this.title, this.description, this.products});

  Map toJson() =>
      {'title': title, 'description': description, 'products': products};

  ProductExtendModel.fromJson(Map json)
      : description = json['description'],
        title = json['title'],
        products = json['products'];
}

class NewProductExtendModel {
  // Model
  String? title;
  String? description;

  NewProductExtendModel({this.title, this.description});

  Map toJson() => {'title': title, 'description': description};

  NewProductExtendModel.fromJson(Map json) {
    description = json['description'];
    title = json['title'];
  }
}
