part of '../widget.dart';

class CategoriesScreen extends StatefulWidget {
  final bool withBackBtn;

  CategoriesScreen({Key? key, this.withBackBtn = false}) : super(key: key);
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: widget.withBackBtn
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              )
            : null,
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.18),
        titleSpacing: 0,
        leadingWidth: 35,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("categories")!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Consumer<CategoryProvider>(builder: (context, value, child) {
                if (value.loading) {
                  return Container();
                } else {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.productCategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (value
                          .productCategories[index].subCategories!.isNotEmpty) {
                        return subCategories(
                            value.productCategories[index], index);
                      }
                      return nonSubCategories(
                          value.productCategories[index], index);
                      /*return categories[index].sub == null
                          ? nonSubCategories(categories, index)
                          : subCategories(categories, index, itemWidth, itemHeight);*/
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector nonSubCategories(ProductCategoryModel category, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoriesScreen(
              nonSub: true,
              title: category.name,
              id: category.id.toString(),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 5,
        ),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              offset: Offset(0, 4),
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6)
        ]),
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              category.image != null
                  ? Image.network(
                      category.image,
                      width: 60,
                    )
                  : Icon(
                      Icons.image_outlined,
                      size: 60,
                    ),
              Container(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyles(
                    value: category.name,
                    size: 12,
                    weight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    width: 200,
                    child: TextStyles(
                      value: category.description ?? '',
                      size: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                MaterialIcons.keyboard_arrow_right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container subCategories(ProductCategoryModel category, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6)
      ]),
      child: ListTileTheme(
        child: ExpansionTile(
          tilePadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          childrenPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          leading: category.image != null
              ? Image.network(
                  category.image,
                  width: 60,
                )
              : Icon(
                  Icons.image_outlined,
                  size: 60,
                ),
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoriesScreen(
                    nonSub: true,
                    title: category.name,
                    id: category.id.toString(),
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextStyles(
                  value: category.name,
                  size: 12,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: 200,
                  child: TextStyles(
                    value: category.description ?? '',
                    size: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: (1 / 1),
              ),
              itemCount: category.subCategories!.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategoriesScreen(
                          nonSub: true,
                          title: category.subCategories![i].name,
                          id: category.subCategories![i].id.toString(),
                        ),
                      ),
                    );
                  },
                  dense: true,
                  contentPadding:
                      EdgeInsets.only(left: 6.0, right: 6.0, bottom: 5),
                  title: Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: darkColor.withOpacity(0.10), blurRadius: 5)
                    ]),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          category.subCategories![i].image != null
                              ? Image.network(
                                  category.subCategories![i].image,
                                  width: 60,
                                )
                              : Icon(
                                  Icons.image_outlined,
                                  size: 60,
                                ),
                          Container(height: 10),
                          TextStyles(
                            value: category.subCategories![i].name,
                            size: 12,
                            isLine: true,
                            weight: FontWeight.bold,
                            align: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
