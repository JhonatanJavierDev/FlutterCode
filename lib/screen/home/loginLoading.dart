import 'dart:async';

import 'package:flutter/material.dart';
import 'package:catalinadev/screen/pages.dart';
import 'package:catalinadev/utils/shared.dart';

class LoadingLogin extends StatefulWidget {
  @override
  _LoadingLoginState createState() => _LoadingLoginState();
}

class _LoadingLoginState extends State<LoadingLogin> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(milliseconds: 1000);

    return Timer(duration, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            isLogin: false,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: spinDancing,
        ),
      ),
    );
  }
}
