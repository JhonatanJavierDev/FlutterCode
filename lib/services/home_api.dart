import 'package:catalinadev/utils/globalURL.dart';

class HomeAPI {
  loginByDefault(String username, String password) async {
    Map data = {'username': username, 'password': password};
    var response = await baseAPI.postAsync(
      '$loginDefault',
      data,
      isCustom: true,
    );
    return response;
  }

  homeSliderApi() async {
    var response = await baseAPI.getAsync('$homeSlider', isCustom: true);
    return response;
  }

  homeCategoriesApi() async {
    var response = await baseAPI.getAsync('$homeCategory',
        isCustom: true, printedLog: false);
    return response;
  }

  homeMiniBannerApi() async {
    var response = await baseAPI.getAsync('$homeMiniBanner', isCustom: true);
    return response;
  }

  homeFlashSale() async {
    var response = await baseAPI.getAsync(getFlashSaleURL, isCustom: true);
    return response;
  }

  newHomeApi() async {
    var response = await baseAPI.getAsync(newHomeURL, isCustom: true);
    return response;
  }
}
