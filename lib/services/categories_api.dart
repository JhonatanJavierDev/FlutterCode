import 'package:catalinadev/utils/globalURL.dart';

class CategoriesAPI {
  /*fetchCategories({String showPopular = ''}) async {
    var response = await baseAPI.getAsync(
        '$category?show_popular=$showPopular',isCustom: true);
    return response;
  }*/

  fetchNewProductCategories() async {
    var response = await baseAPI.getAsync('$allCategoriesURL', isCustom: true);
    print(response);
    return response;
  }

  fetchProductCategories() async {
    print(url);
    var response = await baseAPI.getAsync('$allCategoriesURL',
        printedLog: false, isCustom: true);
    return response;
  }

  /*fetchPopularCategories() async {
    var response = await baseAPI.getAsync(
        '$popularCategories',isCustom: true);
    return response;
  }*/

  /*fetchAllCategories() async {
    Map data = {};
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$allCategoriesUrl',
      data,
      isCustom: true,
    );
    return response;
  }*/
}
