import 'package:flutter/material.dart';
import 'package:catalinadev/utils/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale appLocale = Locale('es', 'ES');

  Locale get appLocal => appLocale;
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    printLog('Fetching Locale : ${prefs.getString('language_code')}');
    if (prefs.getString('language_code') == null) {
      appLocale = Locale('es', 'ES');
      return Null;
    }
    appLocale = Locale(prefs.getString('language_code')!);
    printLog('${appLocal.toString()}', name: 'AppLocal');
    notifyListeners();
    return Null;
  }

  Future<Locale> changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (appLocale == type) {
      return appLocale;
    }
    if (type == Locale("id")) {
      appLocale = Locale("id");
      await prefs.setString('language_code', 'id');
      await prefs.setString('countryCode', '');
    } else if (type == Locale("pt")) {
      appLocale = Locale("pt");
      await prefs.setString('language_code', 'pt');
      await prefs.setString('countryCode', '');
    } else if (type == Locale("km")) {
      appLocale = Locale("km");
      await prefs.setString('language_code', 'km');
      await prefs.setString('countryCode', '');
    } else if (type == Locale("es")) {
      appLocale = Locale("es");
      await prefs.setString('language_code', 'es');
      await prefs.setString('countryCode', '');
    } else if (type == Locale("ja")) {
      appLocale = Locale("ja");
      await prefs.setString('language_code', 'ja');
      await prefs.setString('countryCode', '');
    } else if (type == Locale("vi")) {
      appLocale = Locale("vi");
      await prefs.setString('language_code', 'vi');
      await prefs.setString('countryCode', '');
    } else if (type == Locale("en")) {
      appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    } else if (type == Locale("fr")) {
      appLocale = Locale("fr");
      await prefs.setString('language_code', 'fr');
      await prefs.setString('countryCode', '');
    }
    printLog('Setting Locale : ${prefs.getString('language_code')}');
    notifyListeners();
    return appLocale;
  }

  void statusLanguage() async {
    notifyListeners();
  }
}
