class SliderModel{
  final dynamic product;
  final String? titleSlider;
  final String? image;
  final String? linkTo;
  final String? name;

  SliderModel({this.product, this.titleSlider, this.image, this.linkTo, this.name});

  Map toJson() =>
      {'product': product, 'title_slider': titleSlider, 'image': image, 'link_to': linkTo, 'name': name};

  SliderModel.fromJson(Map json)
      : product = json['product'],
        titleSlider = json['title_slider'],
        linkTo = json['link_to'],
        name = json['name'],
        image = json['image'];
}