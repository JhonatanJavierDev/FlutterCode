part of 'shared.dart';

Color primaryColor = Color(0xFFFDF8F0);
Color accentColor = Color(0xFF345D34);
Color tittleColor = Color(0xFF345D34);
Color listHeadColor = Color(0xFFFFF4E0);
Color disableColors = Color(0xFFAFAFAF);
Color greyText = Color(0xFF616161);
Color greyLine = Color(0xFFEEEEEE);
Color mutedColor = Color(0xFF616161);
Color darkColor = Color(0xFF212121);

final formatedCurrency =
    NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);

//------------------------------------------------------------------------------ TEXT STYLE
class TextStyles extends StatelessWidget {
  const TextStyles(
      {Key? key,
      this.value,
      this.size,
      this.weight,
      this.color,
      this.align,
      this.isLine,
      this.lineThrough,
      this.isPrice = false})
      : super(key: key);
  final String? value;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final TextDecoration? lineThrough;
  final TextAlign? align;
  final bool? isLine;
  final bool isPrice;

  @override
  Widget build(BuildContext context) {
    if (isPrice) {
      return RichText(
        text: TextSpan(
          style: TextStyle(color: color),
          children: <TextSpan>[
            TextSpan(
                text: value,
                style: TextStyle(
                    fontWeight: weight,
                    fontSize: size,
                    decoration: lineThrough,
                    color: color)),
          ],
        ),
      );
    }
    return Text(
      value!,
      textAlign: align,
      maxLines: isLine != true ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size,
          decoration: lineThrough,
          color: color,
          fontWeight: weight),
    );
  }
}

final dateFormat = new DateFormat("yyyy-MM-dd'T'HH:mm:ss");
final formatDate = new DateFormat('yyyy-MM-dd | hh:mm');

String dateFormater({required String date}) {
  DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('MM-dd-yyyy | hh:mm');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

final List<String> navbarIcon = [
  'assets/images/home/eva_home-fill.png',
  'assets/images/home/bx_bxs-category-alt.png',
  'assets/images/home/mdi_cart.png',
  'assets/images/home/ri_user-3-fill.png',
];

final List<String> categoryList = [
  'assets/images/home/Category1.png',
  'assets/images/home/phone.png',
  'assets/images/home/dashicons_food.png',
  'assets/images/home/volleyball-ball.png',
  'assets/images/home/carbon_game-console.png',
  'assets/images/home/printer.png',
  'assets/images/home/si-glyph_t-shirt.png',
  'assets/images/home/viewall.png',
];

final List<String> filterList = [
  'Popularity',
  'Latest',
  'Highest Price',
  'Lowest Price',
];

final List<String> categoryListTxt = [
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
];

final List<String> typeCategoryList = [
  'Komputer',
  'Televisi',
  'Printer',
  'Hand Phone',
  'Gadget'
];

final List<String> myOrderDummy = [
  'DONE',
  'SENT',
  'CANCELED',
  'NET YET PAID',
];

var spinkits = SpinKitWanderingCubes(
  color: tittleColor,
  size: 50.0,
);

var spinDancing = SpinKitThreeBounce(
  color: tittleColor,
  size: 30.0,
);

final String iconTag = 'assets/images/account';

final List<String> typeVariantList = ['BLUE', 'RED', 'BLACK', 'DARK BLUE'];
List<Widget> demo = [
  Container(height: 300, color: Colors.amber),
  Container(height: 300, color: Colors.black),
  Container(height: 300, color: Colors.blue),
  Container(height: 300, color: Colors.green),
];

final border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(
      color: Colors.white,
    ));
final borderSide = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(
      color: accentColor,
    ));

Widget chip(String label, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Chip(
      labelPadding: EdgeInsets.all(5.0),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 0,
      shadowColor: Colors.grey[60],
      // padding: EdgeInsets.all(6.0),
    ),
  );
}

Widget chipBorder(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Container(
        child: Text(
          label,
          style: TextStyle(
            color: Color(0xFF1565C0),
            fontSize: 10,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF1565C0), width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      // padding: EdgeInsets.all(6.0),
    ),
  );
}

class GreyText extends StatefulWidget {
  final String? textField;
  final hintText;
  final TextEditingController? controllerTxt;
  final showPassword;
  final String? validator;
  final double paddingScroll;
  final bool disable, password, passwordRegister, isRequired, isNumber;
  GreyText(
      {Key? key,
      this.hintText,
      this.controllerTxt,
      this.showPassword,
      this.textField,
      this.validator,
      this.disable = true,
      this.paddingScroll = 0,
      this.password = false,
      this.passwordRegister = false,
      this.isRequired = true,
      this.isNumber = false})
      : super(key: key);
  @override
  _GreyTextState createState() => _GreyTextState();
}

class _GreyTextState extends State<GreyText> {
  bool? showPassword = false;

  @override
  void initState() {
    super.initState();
    showPassword = widget.showPassword;
    print(showPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(cursorColor: accentColor),
          hintColor: Colors.transparent,
        ),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            children: [
              TextFormField(
                // enabled: widget.hintText == "Enter your first email" ||
                //         widget.hintText == "Enter your username"
                //     ? false
                //     : true,
                enabled: widget.disable,
                scrollPadding: EdgeInsets.only(bottom: widget.paddingScroll),
                controller: widget.controllerTxt,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20),
                    focusedBorder: border,
                    border: border,
                    hintStyle: TextStyle(color: Colors.black26),
                    labelStyle:
                        TextStyle(fontFamily: 'Brandon', color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                    hintText: widget.hintText),
                keyboardType: widget.password == true
                    ? TextInputType.visiblePassword
                    : widget.hintText == "Enter your zip" || widget.isNumber
                        ? TextInputType.number
                        : TextInputType.emailAddress,
                obscureText:
                    widget.password == true && showPassword! ? true : false,
                validator: widget.isRequired
                    ? (value) {
                        print("value");
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .translate("empty");
                        }
                        if (widget.passwordRegister == true &&
                            widget.controllerTxt!.text.length < 8) {
                          return AppLocalizations.of(context)!
                              .translate("pass_length");
                        }
                        return null;
                      }
                    : null,
              ),
              Visibility(
                visible: widget.password == true ? true : false,
                child: Positioned(
                  right: 0,
                  child: Container(
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword!;
                        });
                      },
                      icon: showPassword != true
                          ? Icon(Ionicons.md_eye)
                          : Icon(Ionicons.md_eye_off),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PriceForm extends StatefulWidget {
  final hintText;
  final TextEditingController? controllerTxt;
  final String? price;
  final showPassword;

  PriceForm(
      {Key? key,
      this.hintText,
      this.controllerTxt,
      this.showPassword,
      this.price})
      : super(key: key);
  @override
  _PriceFormState createState() => _PriceFormState();
}

class _PriceFormState extends State<PriceForm> {
  bool? showPassword = false;
  String? initVal;
  late CurrencyTextInputFormatter _formatter;
  TextEditingController? txtController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    final gs = Provider.of<HomeProvider>(context, listen: false);
    dynamic decimalNumber = int.parse(gs.formatCurrency.slug!);

    showPassword = widget.showPassword;
    print(showPassword);
    String pattern =
        '${convertHtmlUnescape(gs.currency.description!)}#${gs.formatCurrency.image}###${gs.formatCurrency.title}#';

    pattern = '${convertHtmlUnescape(gs.currency.description!)}#,###.#';
    _formatter = CurrencyTextInputFormatter(
        symbol: convertHtmlUnescape(gs.currency.description!),
        decimalDigits: decimalNumber,
        customPattern: pattern);
    txtController = widget.controllerTxt;
    if (txtController!.text.isNotEmpty) {
      txtController!.text = _formatter.format(
          "${double.parse(widget.controllerTxt!.text).toStringAsFixed(decimalNumber)}");
    } else {
      txtController!.text = _formatter.format(widget.controllerTxt!.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gs = Provider.of<HomeProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(cursorColor: accentColor),
          hintColor: Colors.transparent,
        ),
        child: TextFormField(
          controller: txtController,
          style: TextStyle(color: Colors.black),
          inputFormatters: [_formatter],
          decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () {
                  txtController!.clear();
                },
                child: Icon(Icons.clear),
              ),
              contentPadding: EdgeInsets.only(left: 20),
              focusedBorder: border,
              border: border,
              hintStyle: TextStyle(color: Colors.black26),
              labelStyle: TextStyle(fontFamily: 'Brandon', color: Colors.white),
              filled: true,
              fillColor: Color(0xFFFAFAFA),
              hintText: convertHtmlUnescape(gs.currency.description!)),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}

class LabelTxt extends StatelessWidget {
  const LabelTxt({Key? key, this.txt}) : super(key: key);
  final String? txt;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        txt!,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SignInMethod extends StatelessWidget {
  const SignInMethod({Key? key, this.img, this.text}) : super(key: key);

  final String? img, text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[100]!, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Image.asset(
              img!,
              width: 21,
            ),
          ),
          Text(text!, style: TextStyle(fontSize: 13))
        ],
      ),
    );
  }
}

//------------------------------------------------------------------------------ SEGMENT TITLE
class SegmentTittle extends StatelessWidget {
  const SegmentTittle({
    Key? key,
    this.more,
    this.segment,
    this.isMore,
    this.products,
    this.featured = false,
    this.rating = false,
  }) : super(key: key);

  final String? segment, more, products;
  final bool? isMore;
  final bool featured, rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            segment!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          isMore != true
              ? Container()
              : InkWell(
                  onTap: () {
                    print(segment);
                    print(products);
                    print(featured);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductMoreScreen(
                          title: segment,
                          id: products,
                          featured: featured,
                          rating: rating,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate("more")!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: tittleColor,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

//------------------------------------------------------------------------------ TIMER COUNDWON SYLE
class TimerStyle extends StatelessWidget {
  const TimerStyle({
    Key? key,
    this.timer,
    this.color,
    this.textColor,
    this.height,
    this.width,
    this.backgroundColor,
  }) : super(key: key);

  final int? timer;
  final Color? color, textColor, backgroundColor;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: color!, width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Center(
        child: Text(
          timer.toString(),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------ IMAGE STYLE

class ImgStyle extends StatelessWidget {
  const ImgStyle({
    Key? key,
    this.url,
    this.radius,
    this.height,
    this.width,
  }) : super(key: key);

  final String? url;
  final double? radius, width, height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(radius!),
        ),
        child: CachedNetworkImage(
          imageUrl: url!,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------ LINE

class Line extends StatelessWidget {
  const Line({Key? key, this.height, this.color}) : super(key: key);

  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          )),
    );
  }
}

//------------------------------------------------------------------------------ STAR PRODUCT
class StarProduct extends StatelessWidget {
  const StarProduct({
    Key? key,
    this.itemCount,
    this.size,
  }) : super(key: key);

  final int? itemCount;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 20,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Icon(
            MaterialCommunityIcons.star_outline,
            size: size,
            color: Colors.orange,
          );
        },
      ),
    );
  }
}

//------------------------------------------------------------------------------ HORIZONTAL LIST
class HorizontalList extends StatelessWidget {
  const HorizontalList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10),
      height: 38,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: typeVariantList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                typeVariantList[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//------------------------------------------------------------------------------ ROW TOTAL STYLE
class RowTotalStyle extends StatelessWidget {
  const RowTotalStyle({
    this.value,
    this.keys,
    this.size,
    this.color,
    this.weight,
  });

  final String? value, keys;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextStyles(
            value: value,
            size: size,
            color: color,
            weight: weight,
          ),
          TextStyles(
            value: keys,
            size: size,
            color: color,
            weight: weight,
          )
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final image;

  DetailScreen({this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              image,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String? translate(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'id', 'pt', 'km', 'ja', 'es', 'vi', 'fr']
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
