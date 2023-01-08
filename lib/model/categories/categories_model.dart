class CategoriesModel {
  // Model
  final int? categories;
  final String? id;
  final String? titleCategories;
  final String? image;

  CategoriesModel({this.categories, this.titleCategories, this.image, this.id});

  Map toJson() => {
        'categories': categories,
        'title_slider': titleCategories,
        'image': image
      };

  CategoriesModel.fromJson(Map json)
      : categories = json['categories'],
        titleCategories = json['title_categories'] ?? json['name'],
        image = json['image'],
        id = json['id'];
}

class PopularCategoriesModel {
  // Model
  String? title;
  List<CategoriesModel>? categories;

  PopularCategoriesModel({this.categories, this.title});

  Map toJson() => {'categories': categories, 'title': title};

  PopularCategoriesModel.fromJson(Map json) {
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories!.add(new CategoriesModel.fromJson(v));
      });
    }
    title = json['title'];
  }
}

class AllCategoriesModel {
  // Model
  final int? id, count, parent;
  final String? title;
  final String? description;
  final String? image;

  AllCategoriesModel(
      {this.id,
      this.count,
      this.parent,
      this.title,
      this.description,
      this.image});

  Map toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'parent': parent,
        'count': count,
        'image': image
      };

  AllCategoriesModel.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        parent = json['parent'],
        count = json['count'],
        image = json['image'];
}

class CategoriesSelectedClass {
  int? id;
  String? name;

  CategoriesSelectedClass({this.id, this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.name;
    return data;
  }
}

class NewAllCategoriesModel {
  int? id;
  String? slug;
  String? name;
  bool? isSelected;
  List<SubCategories>? subCategories;

  NewAllCategoriesModel(
      {this.id, this.slug, this.name, this.isSelected, this.subCategories});

  NewAllCategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    isSelected = false;
    if (json['sub_categories'] != null) {
      subCategories = new List<SubCategories>.empty(growable: true);
      json['sub_categories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['is_selected'] = this.isSelected;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  int? id;
  String? slug;
  String? name;
  bool? isSelected;
  List<SubCategories>? subCategories;

  SubCategories(
      {this.id, this.slug, this.name, this.isSelected, this.subCategories});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    isSelected = false;
    if (json['sub_categories'] != null) {
      subCategories = new List<SubCategories>.empty(growable: true);
      json['sub_categories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['is_selected'] = this.isSelected;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
