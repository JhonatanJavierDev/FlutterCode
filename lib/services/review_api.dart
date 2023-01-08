import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';
import 'package:catalinadev/utils/utility.dart';

class ReviewAPI {
  inputReview(productId, review, rating) async {
    Map data = {
      "product_id": productId,
      "review": review,
      "reviewer": Session.data.getString('firstname'),
      "reviewer_email": Session.data.getString('email'),
      "rating": rating,
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync('$addReviewUrl', data);
    return response;
  }

  listReview({int? page = 1, int? perPage = 8, String? product}) async {
    var response = await baseAPI.getAsync(
        '$addReviewUrl?page=$page&per_page=$perPage&product=$product');
    return response;
  }
}
