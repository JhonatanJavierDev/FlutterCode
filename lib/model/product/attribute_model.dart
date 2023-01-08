class AttributeModel {
  String? id;
  String? name, label;
  List<AttributeTermModel>? term;
  AttributeTermModel? selectedTerm;
  bool? selected = false;

  AttributeModel(
      {this.id,
      this.name,
      this.label,
      this.term,
      this.selected,
      this.selectedTerm});

  Map toJson() => {
        "attribute_id": id,
        "attribute_name": name,
        "attribute_label": label,
        "term": term
      };

  AttributeModel.fromJson(Map json) {
    id = json['attribute_id'];
    name = json['attribute_name'];
    label = json['attribute_label'];
    if (json['term'] != null) {
      term = [];
      json['term'].forEach((v) {
        term!.add(new AttributeTermModel.fromJson(v));
      });
    }
  }
}

class AttributeTermModel {
  int? idTerm;
  String? name, slug, taxonomy;
  bool? selected = false;

  AttributeTermModel(
      {this.idTerm, this.name, this.slug, this.taxonomy, this.selected});

  Map toJson() =>
      {"term_id": idTerm, "name": name, "slug": slug, "taxonomy": taxonomy};

  AttributeTermModel.fromJson(Map json) {
    idTerm = json['term_id'];
    name = json['name'];
    slug = json['slug'];
    taxonomy = json['taxonomy'];
  }
}

class ProductAtributeModel {
  String? taxonomyName;
  bool? variation = true;
  bool? visible = true;
  List<String>? options;

  ProductAtributeModel(
      {this.taxonomyName, this.variation, this.visible, this.options});

  Map toJson() => {
        "taxonomy_name": taxonomyName,
        "variation": variation,
        "visible": visible,
        "options": options
      };

  ProductAtributeModel.toJson(Map json) {
    taxonomyName = json['taxonomy_name'];
    variation = json['variation'];
    visible = json['visible'];
    options = json['options'];
  }
}
