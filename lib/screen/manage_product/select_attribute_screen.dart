part of '../pages.dart';

class SelectAttributeScreen extends StatefulWidget {
  const SelectAttributeScreen({Key? key}) : super(key: key);

  @override
  State<SelectAttributeScreen> createState() => _SelectAttributeScreenState();
}

class _SelectAttributeScreenState extends State<SelectAttributeScreen> {
  bool isColor = false, isShape = false, isSize = false, isStyle = false;
  AttributeProvider? attributeProvider;
  List<String> listAttr = [];
  bool shouldPop = false;

  @override
  void initState() {
    super.initState();
    attributeProvider = Provider.of<AttributeProvider>(context, listen: false);
    print(attributeProvider!.listAttribute.length);
  }

  Future<bool> checkIsValid() async {
    for (int i = 0; i < attributeProvider!.listAttribute.length; i++) {
      if (attributeProvider!.listAttribute[i].selected!) {
        for (int j = 0;
            j < attributeProvider!.listAttribute[i].term!.length;
            j++) {
          if (attributeProvider!.listAttribute[i].term![j].selected! &&
              attributeProvider!.listAttribute[i].term![j].slug != "all" &&
              attributeProvider!.listAttribute[i].term![j].slug != "All") {
            setState(() {
              shouldPop = true;
            });
            attributeProvider!.listAttribute[i].selectedTerm =
                attributeProvider!.listAttribute[i].term!.first;
          }
        }
      }
    }
    if (!shouldPop) {
      snackBar(context, message: 'please select attribute first');
    }
    return shouldPop;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: checkIsValid,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.18),
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {
              checkIsValid().then((value) {
                if (value) {
                  Navigator.pop(context);
                }
              });
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 18,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Select Attribute",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: attributeProvider!.loadingAttribute
            ? Container(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: attributeProvider!.listAttribute.length,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      Container(
                        child: Row(
                          children: [
                            Checkbox(
                              value: attributeProvider!
                                  .listAttribute[index].selected,
                              onChanged: (val) {
                                setState(() {
                                  attributeProvider!.changeValueAttribute(
                                      index: index, selected: val);
                                });
                              },
                              activeColor: accentColor,
                            ),
                            TextStyles(
                              value:
                                  attributeProvider!.listAttribute[index].name,
                              size: 14,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:
                            attributeProvider!.listAttribute[index].selected!,
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: attributeProvider!
                                .listAttribute[index].term!.length,
                            itemBuilder: (context, j) {
                              return Column(children: [
                                Container(
                                  child: attributeProvider!.listAttribute[index]
                                              .term![j].name !=
                                          "All"
                                      ? Row(children: [
                                          Checkbox(
                                            value: attributeProvider!
                                                .listAttribute[index]
                                                .term![j]
                                                .selected,
                                            onChanged: (val) {
                                              setState(() {
                                                attributeProvider!
                                                    .changeTermAttribute(
                                                        index: index,
                                                        selected: val,
                                                        indexj: j);
                                                if (attributeProvider!
                                                    .listAttribute[index]
                                                    .term![j]
                                                    .selected!) {
                                                  setState(() {
                                                    attributeProvider!
                                                            .listAttribute[index]
                                                            .selectedTerm =
                                                        attributeProvider!
                                                            .listAttribute[
                                                                index]
                                                            .term!
                                                            .first;
                                                  });
                                                }
                                              });
                                            },
                                            activeColor: accentColor,
                                          ),
                                          TextStyles(
                                            value: attributeProvider!
                                                .listAttribute[index]
                                                .term![j]
                                                .name,
                                            size: 14,
                                            weight: FontWeight.bold,
                                          ),
                                        ])
                                      : Container(),
                                ),
                              ]);
                            },
                          ),
                        ),
                      ),
                    ]);
                  },
                ),
              )
            : customLoading(),
      ),
    );
  }
}
