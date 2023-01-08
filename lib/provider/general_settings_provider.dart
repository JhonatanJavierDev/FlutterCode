import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:catalinadev/model/general_settings/general_settings_model.dart';
import 'package:catalinadev/services/general_settings_api.dart';
import 'package:catalinadev/utils/utility.dart';

class GeneralSettingsProvider with ChangeNotifier {
  List<GeneralSettingsModel> intro = [];

  GeneralSettingsModel splashscreen = new GeneralSettingsModel();
  GeneralSettingsModel logo = new GeneralSettingsModel();
  GeneralSettingsModel wa = new GeneralSettingsModel();
  GeneralSettingsModel sms = new GeneralSettingsModel();
  GeneralSettingsModel phone = new GeneralSettingsModel();
  GeneralSettingsModel about = new GeneralSettingsModel();
  GeneralSettingsModel currency = new GeneralSettingsModel();
  GeneralSettingsModel formatCurrency = new GeneralSettingsModel();

  GeneralSettingsModel image404 = new GeneralSettingsModel();
  GeneralSettingsModel imageThanksOrder = new GeneralSettingsModel();
  GeneralSettingsModel imageNoTransaction = new GeneralSettingsModel();
  GeneralSettingsModel imageSearchEmpty = new GeneralSettingsModel();

  bool loading = false;
  bool? isBarcodeActive = false;
  String? message;

  GeneralSettingsProvider() {
    fetchGeneralSettings();
  }

  Future<bool> fetchIntroPage() async {
    loading = true;
    await GeneralSettingsAPI().introPageData().then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        splashscreen =
            GeneralSettingsModel.fromJson(responseJson['splashscreen']);
        for (Map item in responseJson['intro']) {
          intro.add(GeneralSettingsModel.fromJson(item));
        }
        loading = false;
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchGeneralSettings() async {
    loading = true;
    await GeneralSettingsAPI().generalSettingsData().then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);
        printLog(json.encode(responseJson));
        for (Map item in responseJson['empty_image']) {
          if (item['title'] == '404_images') {
            image404 = GeneralSettingsModel.fromJson(item);
          } else if (item['title'] == 'thanks_order') {
            imageThanksOrder = GeneralSettingsModel.fromJson(item);
          } else if (item['title'] == 'no_transaksi') {
            imageNoTransaction = GeneralSettingsModel.fromJson(item);
          } else if (item['title'] == 'search_empty') {
            imageSearchEmpty = GeneralSettingsModel.fromJson(item);
          }
        }

        logo = GeneralSettingsModel.fromJson(responseJson['logo']);
        wa = GeneralSettingsModel.fromJson(responseJson['wa']);
        sms = GeneralSettingsModel.fromJson(responseJson['sms']);
        phone = GeneralSettingsModel.fromJson(responseJson['phone']);
        about = GeneralSettingsModel.fromJson(responseJson['about']);
        currency = GeneralSettingsModel.fromJson(responseJson['currency']);
        formatCurrency =
            GeneralSettingsModel.fromJson(responseJson['format_currency']);

        if (responseJson['barcode_active'] != null) {
          isBarcodeActive = responseJson['barcode_active'];
        }

        loading = false;
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
      }
    });
    return true;
  }
}
