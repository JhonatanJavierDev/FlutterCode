import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:catalinadev/admob/constant/ad_mob_constant.dart';
import 'package:catalinadev/admob/widget/admob_widget.dart';
import 'package:catalinadev/utils/utility.dart';

class AdMobState extends StatefulWidget {
  final String? type;
  const AdMobState({Key? key, this.type}) : super(key: key);

  @override
  State<AdMobState> createState() => _AdMobStateState();
}

class _AdMobStateState extends State<AdMobState> {
  /*Ad Banner Config*/
  bool? _isBannerLoaded = false;
  BannerAd? _bannerAd;
  String? _adUnitAndroid = '';
  String? _adUnitIOS = '';

  /*End*/

  _loadBannerAd() {
    printLog('Creating BannerAd');
    if (widget.type == 'home') {
      _adUnitAndroid = AdMobConstant.adUnitHomeAndroid;
      _adUnitIOS = AdMobConstant.adUnitHomeIOS;
    }
    if (widget.type == 'category') {
      _adUnitAndroid = AdMobConstant.adUnitCategoryAndroid;
      _adUnitIOS = AdMobConstant.adUnitCategoryIOS;
    }
    if (widget.type == 'product') {
      _adUnitAndroid = AdMobConstant.adUnitProductAndroid;
      _adUnitIOS = AdMobConstant.adUnitProductIOS;
    }

    _bannerAd = BannerAd(
        size: AdMobConstant.adSizeBanner,
        adUnitId: Platform.isIOS
            ? _adUnitIOS!
            : Platform.isAndroid
                ? _adUnitAndroid!
                : '',
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            _isBannerLoaded = true;
          });
        }, onAdFailedToLoad: (ad, e) {
          ad.dispose();
          if (kDebugMode) print('AdBanner failedToLoad: $e');
        }),
        request: const AdRequest())
      ..load();
    printLog('BannerAd Loaded');
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null && _isBannerLoaded!) {
      return AdMobWidget(
        bannerAd: _bannerAd,
      );
    } else {
      return Container();
    }
  }
}
