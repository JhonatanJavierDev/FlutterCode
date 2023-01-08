import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:catalinadev/admob/constant/ad_mob_constant.dart';

class AdMobWidget extends StatelessWidget {
  final BannerAd? bannerAd;
  const AdMobWidget({Key? key, this.bannerAd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: AdMobConstant.isAdMobActive,
        child: Container(
          height: bannerAd!.size.height.toDouble(),
          width: bannerAd!.size.width.toDouble(),
          child: AdWidget(ad: bannerAd!),
          margin: EdgeInsets.all(8.0),
        ));
  }
}
