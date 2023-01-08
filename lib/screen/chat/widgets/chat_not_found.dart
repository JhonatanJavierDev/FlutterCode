import 'package:flutter/material.dart';
import 'package:catalinadev/screen/pages.dart';
import 'package:catalinadev/utils/shared.dart';

class ChatNotFound extends StatelessWidget {
  const ChatNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/chat/chat.png',
          width: 170,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 35,
          ),
          child: Text(
            AppLocalizations.of(context)!.translate("ask_seller_about")!,
            style: TextStyle(
                color: tittleColor, fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: 140,
          child: MaterialButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            color: accentColor,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()),
                  (Route<dynamic> route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                AppLocalizations.of(context)!.translate("home")!,
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
