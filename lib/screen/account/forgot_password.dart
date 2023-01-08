part of '../pages.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool? isDone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.18),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 18,
          ),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate('forgot_password')!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Text(
              isDone != true
                  ? AppLocalizations.of(context)!.translate('lost_password')!
                  : AppLocalizations.of(context)!.translate('we_have_sent')!,
              style: TextStyle(
                fontSize: isDone != true ? 14 : 16,
              ),
            ),
            Container(height: 20),
            isDone != true
                ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyles(
                          value: AppLocalizations.of(context)!
                              .translate('user_or_email')!,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: double.infinity,
                          child: GreyText(
                            hintText: AppLocalizations.of(context)!
                                .translate('ent_ur_user')!,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 15),
              child: MaterialButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                color: accentColor,
                onPressed: () {
                  if (isDone != true) {
                    setState(() {
                      isDone = true;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    isDone != true
                        ? AppLocalizations.of(context)!.translate('reset_pass')!
                        : AppLocalizations.of(context)!.translate('done')!,
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
