class ListFlashSale {
  int? id;
  String? title;
  String? start;
  String? end;
  String? products;

  ListFlashSale({this.id, this.title, this.start, this.end, this.products});

  ListFlashSale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    start = json['start'];
    end = json['end'];
    products = json['products'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['start'] = this.start;
    data['end'] = this.end;
    data['products'] = this.products;
    return data;
  }
}

class FlashSale {
  FlashSale({
    this.linkTo,
    this.name,
    this.product,
    this.titleSlider,
    this.type,
    this.image,
  });

  String? linkTo;
  String? name;
  int? product;
  String? titleSlider;
  String? type;
  String? image;

  factory FlashSale.fromJson(Map<String, dynamic> json) => FlashSale(
        linkTo: json["link_to"],
        name: json["name"],
        product: json["product"],
        titleSlider: json["title_slider"],
        type: json["type"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "link_to": linkTo,
        "name": name,
        "product": product,
        "title_slider": titleSlider,
        "type": type,
        "image": image,
      };
}
