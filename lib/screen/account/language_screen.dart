part of '../pages.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int? indexSelect;
  List<Language>? language;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLanguage();
    });
    language = [
      Language(
          flag: "assets/images/openmoji_flag-spain.png",
          region: "Spanish",
          codeRegion: 'es'),
      Language(
          flag: "assets/images/openmoji_flag-uk.png",
          region: "English",
          codeRegion: 'en'),
      /*Language(
          flag: "assets/images/openmoji_flag-indonesia.png",
          region: "Indonesia",
          codeRegion: 'id'),
      Language(
          flag: "assets/images/openmoji_flag-cambodia.png",
          region: "Khmer",
          codeRegion: 'km'),
      Language(
          flag: "assets/images/openmoji_flag-portugal.png",
          region: "Portugese",
          codeRegion: 'pt'),*/
      /*Language(
          flag: "assets/images/openmoji_flag-japan.png",
          region: "Japanese",
          codeRegion: 'ja'),*/
      /*Language(
          flag: "assets/images/openmoji_flag-vietnam.png",
          region: "Vietnam",
          codeRegion: 'vi'),*/
      /*Language(
          flag: "assets/images/openmoji_flag-france.png",
          region: "France",
          codeRegion: 'fr'),*/
      // Language(
      //     flag: "assets/images/openmoji_flag-denmark.png", region: "Denmark"),
      // Language(
      //     flag: "assets/images/openmoji_flag-brazil.png", region: "Brazil"),
      // Language(
      //     flag: "assets/images/openmoji_flag-clipperton-island.png",
      //     region: "Prancis"),
      // Language(
      //     flag: "assets/images/openmoji_flag-czechia.png", region: "Filipina"),
    ];
  }

  _getLanguage() async {
    var code =
        Provider.of<AppLanguage>(context, listen: false).appLocale.languageCode;
    for (var item in language!) {
      setState(() {
        item.status = false;
        if (item.codeRegion == code) item.status = true;
      });
    }
    print(json.encode(language));
  }

  _changeLanguage(Locale code) async {
    Provider.of<AppLanguage>(context, listen: false)
        .changeLanguage(code)
        .then((value) {
      print(value.languageCode);
      _getLanguage();
    });
  }

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
          AppLocalizations.of(context)!.translate("lang")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<AppLanguage>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: language!.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _changeLanguage(Locale(language![index].codeRegion!));
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 17),
                          child:
                              Image.asset(language![index].flag!, width: 35)),
                      TextStyles(
                        value: language![index].region,
                        size: 14,
                      ),
                      Spacer(),
                      language![index].status == false
                          ? Container()
                          : TextStyles(
                              value: AppLocalizations.of(context)!
                                  .translate("active"),
                              size: 14,
                              weight: FontWeight.bold,
                              color: tittleColor,
                            )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
