import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:catalinadev/provider/home_provider.dart';
import 'package:catalinadev/screen/intro/intro_screen.dart';
import 'package:catalinadev/session/session.dart';

import '../pages.dart';

class SplashScreen extends StatefulWidget {
  final Future Function()? onLinkClicked;
  SplashScreen({Key? key, this.onLinkClicked}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loadHomeSuccess = true;

  String? _versionName;
  Future _init() async {
    final _packageInfo = await PackageInfo.fromPlatform();
    context.read<HomeProvider>().setPackageInfo(_packageInfo);

    return _packageInfo.version;
  }

  startSplashScreen(intro) async {
    var duration = const Duration(milliseconds: 2500);

    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Session.data.getBool('isIntro')!
            ? HomeScreen(intro: intro.intro)
            : IntroScreen(
                intro: intro.intro,
              );
      }));
      if (widget.onLinkClicked != null) {
        widget.onLinkClicked!();
      }
    });
  }

  getNewHome() async {
    final intro = Provider.of<HomeProvider>(context, listen: false);
    await Provider.of<HomeProvider>(context, listen: false)
        .getNewHome()
        .then((value) {
      this.setState(() {
        loadHomeSuccess = value;
      });
      if (loadHomeSuccess) {
        if (mounted) startSplashScreen(intro);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (!Session.data.containsKey('isIntro')) {
      Session.data.setBool('isLogin', false);
      Session.data.setBool('isIntro', false);
    }
    getNewHome();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<HomeProvider>(context, listen: false);

    return Scaffold(
      body: home.loading
          ? Container()
          : loadHomeSuccess
              ? Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              home.splashscreen.image!))),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              home.splashscreen.title!,
                              style:
                                  TextStyle(fontSize: 22, color: Colors.grey),
                            ),
                            Text(
                              home.splashscreen.description!,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: _init(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _versionName = snapshot.data as String?;
                            return Text(
                              'Version ' + _versionName!,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ))
              : Container(),
    );
  }
}
