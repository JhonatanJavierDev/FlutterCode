import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';

class WishListAPI {
  productWishlist() async {
    Map data = {"cookie": Session.data.getString('cookie')};
    var response =
        await baseAPI.postAsync(listWishlistProduct, data, isCustom: true);
    // print(response);
    print(data);
    return response;
  }

  listWishList(String? id, int? page) async {
    var url = product;
    Map data = {
      "include": id,
      "user_id": Session.data.getInt('id'),
      "limit": 8,
      "page": page
    };
    var response = await baseAPI.postAsync(url, data, isCustom: true);
    // print(response);
    print(data);
    return response;
  }

  whistlistToggle(String? id) async {
    var url = setWishlistProduct;
    Map data = {"product_id": id, "cookie": Session.data.getString('cookie')};
    var response = await baseAPI.postAsync(url, data, isCustom: true);
    print(data);
    print(response);
    return response;
  }
}
