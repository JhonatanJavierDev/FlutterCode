part of '../pages.dart';

class HomeScreen extends StatefulWidget {
  final List<GeneralSettingsModel>? intro;
  static const String id = 'home_screen';
  HomeScreen({this.intro});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _bottomNavIndex = 0;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 13330;
  List<Widget> pageList = <Widget>[
    HomeSegment(),
    CategoriesScreen(
      withBackBtn: false,
    ),
    CartSegment(),
    // Session.data.getBool('isLogin') ? AccountScreen() : LoadingLogin()
    AccountScreen()
  ];

  translate(String title) {
    AppLocalizations.of(context)!.translate(title);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textNavbar = <String>["Home", 'Categories', "Cart", "Account"];
    return Scaffold(
      backgroundColor: Colors.white,
      body: pageList[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllStoreScreen(),
            ),
          );
        },
        child: Container(
            child: Image.asset(
          'assets/images/home/Frame 3.png',
          width: 30,
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: navbarIcon.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? accentColor : Colors.grey[300];
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage(navbarIcon[index]),
                color: color,
              ),
              const SizedBox(height: 4),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate(textNavbar[index].toLowerCase())!,
                    style: TextStyle(fontSize: 10),
                  ))
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) async {
          setState(() {
            if (index == 3 && Session.data.getBool('isLogin')!) {
              Session.data.setString('role', '');
              Session.data.setString('status_approval_vendor', '');
            }

            _bottomNavIndex = index;
          });
        },
        //other params
      ),
    );
  }
}
