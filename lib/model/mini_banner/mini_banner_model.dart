class MiniBannerModel {
  final int? product;
  final String? titleSlider;
  final String? image;
  final String? type;
  final String? linkTo;
  final String? name;

  MiniBannerModel(
      {this.product,
      this.titleSlider,
      this.image,
      this.type,
      this.linkTo,
      this.name});

  Map toJson() => {
        'product': product,
        'title_slider': titleSlider,
        'image': image,
        'type': type,
        'link_to': linkTo,
        'name': name
      };

  MiniBannerModel.fromJson(Map json)
      : product = json['product'],
        titleSlider = json['title_slider'],
        image = json['image'],
        type = json['type'],
        linkTo = json['link_to'],
        name = json['name'];
}
