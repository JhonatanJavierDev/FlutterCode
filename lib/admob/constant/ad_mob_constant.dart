import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobConstant {
  /*DISCLAIMER : make sure you have already know how to use and create an Ad Mob account.*/

  /*Set TRUE if using AdMob*/
  static const bool isAdMobActive = true;

  /* Ad Unit can be set the same or different for each variable. Make sure ad unit type for each platforms (Android & iOS) is BANNER AD.
  if you just want to set for android (Android deployment only) you can set blank/empty value the IOS variable,
  but if you want to upload both platforms then you must fill all variable */
  static const String adUnitHomeAndroid = "";
  static const String adUnitCategoryAndroid = "";
  static const String adUnitProductAndroid = "";

  static const String adUnitHomeIOS = "";
  static const String adUnitCategoryIOS = "";
  static const String adUnitProductIOS = "";

  /* you can also resize the banner ad */
  static const AdSize adSizeBanner = AdSize.mediumRectangle;

  static void initAdMob() {
    if (isAdMobActive) {
      MobileAds.instance.initialize();
    }
  }
}
