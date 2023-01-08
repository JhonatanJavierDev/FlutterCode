class ProductReviewModel {
  int? id, rating;
  String? dateCreated, status, reviewer, review, avatar;

  ProductReviewModel(
      {this.id,
      this.dateCreated,
      this.status,
      this.reviewer,
      this.review,
      this.rating,
      this.avatar});

  Map toJson() => {
        'id': id,
        'date_created': dateCreated,
        'status': status,
        'reviewer': reviewer,
        'review': review,
        'rating': rating,
        'avatar': avatar
      };

  ProductReviewModel.fromJson(Map json) {
    id = json['id'];
    dateCreated = json['date_created'];
    status = json['status'];
    reviewer = json['reviewer'];
    review = json['review'];
    rating = json['rating'];
    avatar = json['reviewer_avatar_urls']['48'];
  }
}
