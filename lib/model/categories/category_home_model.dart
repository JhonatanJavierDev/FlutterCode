class CategoryHomeModel {
  final int? categories;
  final String? id;
  final String? titleCategories;
  final String? image;
  final String? slug;

  CategoryHomeModel(
      {this.categories, this.titleCategories, this.image, this.id, this.slug});

  Map toJson() => {
        'categories': categories,
        'title_slider': titleCategories,
        'image': image
      };

  CategoryHomeModel.fromJson(Map json)
      : categories = json['categories'],
        titleCategories = json['title_categories'] ?? json['name'],
        image = json['image'],
        id = json['id'],
        slug = json['slug'];
}
