import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/general_widget/data_widget.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';
import 'package:cuzou_app/research_file/Model/shop.dart';
import 'package:cuzou_app/research_file/Screen/shops_list.dart';
import 'package:flutter/material.dart';

import '../../menu_file/Screen/favorite_screen.dart';
import '../Data/data_shop.dart';
import '../Model/category.dart';
import '../../general_widget/listWheelScroll.dart';
import '../Model/subcategory.dart';
import 'package:cuzou_app/main.dart';

class CategorieDetailScreen extends StatefulWidget {
  static const routeName = '/detail-categorie-list';

  const CategorieDetailScreen({Key key}) : super(key: key);

  @override
  CategorieDetailScreenState createState() => CategorieDetailScreenState();
}

class CategorieDetailScreenState extends State<CategorieDetailScreen> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int indexPage = 1;

  TextEditingController shopController;
  int currentIndex = 1;
  List<SubCategory> subCategorySelected;
  Color categoryColor;

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
  }

  void updateDisplay(String value) {}

  void onSubCategorieTap(
    int subCatIndex,
    bool isDark,
    bool isFrench,
    Category category,
    BuildContext ctx,
  ) {
    Navigator.pushNamed(
      ctx,
      ShopsListScreen.routeName,
      arguments: {
        'subCatList': [subCategorySelected[subCatIndex].type],
        'colorAppBar': categoryColor,
        'color': categoryColor,
        'isGlobalResearch': false,
        'isCategoryResearch': false,
        'isDark': isDark,
        'isFrench': isFrench,
        'category': category
      },
    );
  }

  Widget subCatItem(int index, double width, double height, bool isDark,
      BuildContext context) {
    SubCategory shopSubCat = subCategorySelected[index];

    return InkWell(
      //splashColor: primaryColor(!isDark),
      splashColor: Colors.green,
      child: Padding(
        padding: EdgeInsets.only(
          right: width / 60,
          top: 8 * height / 680,
          left: width / 60,
          bottom: 8 * height / 680,
        ),
        child: SizedBox(
          width: (width - 60) / 2,
          height: height / 4.4,
          child: Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,

            //child: Image.asset(shopSubCat.image, fit: BoxFit.cover),
            decoration: BoxDecoration(
              color: categoryColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1,
                color: secondaryColor(!isDark, categoryColor),
              ),
            ),
            child: Image.asset(
              shopSubCat.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget subCatInfoWidget(int index, double width, double height, bool isDark,
      bool isFrench, int subCatLenght) {
    SubCategory shopSubCat = subCategorySelected[index];
    String title = isFrench
        ? frenchTextType(shopSubCat.type)
        : englishTextType(shopSubCat.type);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: height * 0.1,
      width: width * 0.6,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            '${index + 1} / $subCatLenght',
            style: const TextStyle(fontSize: 17),
          ),
          Divider(
            thickness: 1,
            color: primaryColor(!isDark),
          ),
          Text(
            title,
            style: TextStyle(
              color: primaryColor(!isDark),
              fontFamily: 'RebondGrotesque',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  final items = <Widget>[
    Image.asset(
      'assets/images/logos/navigation_bar_logo/journal.png',
      fit: BoxFit.cover,
      scale: 7,
    ),
    Image.asset(
      'assets/images/logos/navigation_bar_logo/home.png',
      fit: BoxFit.cover,
      scale: 7,
    ),
    Image.asset(
      'assets/images/logos/navigation_bar_logo/lettre.png',
      fit: BoxFit.cover,
      scale: 7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    final Category category = routeArgs['category'] as Category;
    final bool isFrench = routeArgs['isFrench'] as bool;
    final bool isDark = routeArgs['isDark'] as bool;
    final categoryTitle =
        isFrench ? category.frenchTitle : category.englishTitle;
    categoryColor = category.color;
    final String categoryImage = category.image;
    final List<SubCat> subCategorie = category.subcategorie;

    subCategorySelected = SHOP_SUBCATEGORIES(false).where((sub) {
      return (subCategorie).contains(sub.type);
    }).toList();

    return Scaffold(
      backgroundColor: primaryColor(isDark),
      appBar: AppBar(
        backgroundColor: shadeColor(categoryColor, 0.1),
        title: Text(categoryTitle),
        actions: <Widget>[
          IconButton(
            icon: const ImageIcon(
              AssetImage("assets/images/logos/logo_notee/icon_noir.png"),
              size: 120,
            ),
            tooltip: 'Home Page',
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.routeName,
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ShopsListScreen.routeName,
                arguments: {
                  'isGlobalResearch': false,
                  'isCategoryResearch': true,
                  'colorAppBar': categoryColor,
                  'isDark': isDark,
                  'isFrench': isFrench,
                  'subCatList': subCategorie,
                  'color': categoryColor,
                  'category': category,
                },
              );
            },
            child: researchBar(
                isDark, isFrench, true, false, updateDisplay, shopController),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.01),
            width: width * 0.95,
            height: height * 0.1,
            child: ElevatedButton(
              //hoverColor: shadeColor(Palette.primary, 0.6),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(MyFavorite.routeName, arguments: {
                  'colorAppBar': categoryColor,
                  'isFrench': isFrench,
                  'isDark': isDark,
                  'category': category,
                });
              },

              style: ElevatedButton.styleFrom(
                  backgroundColor: categoryColor,
                  padding: const EdgeInsets.all(10),
                  shape: const StadiumBorder(),
                  side: BorderSide(
                    width: 1,
                    color: Palette.black,
                  )),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      isFrench
                          ? 'Magasins favories : $categoryTitle'
                          : 'Favorites shops : $categoryTitle',
                      style: TextStyle(
                        color: Palette.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: width * 0.1,
                    height: height * 0.5,
                    child: Image.asset(categoryImage, fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: secondaryColor(!isDark, Palette.blue)),
                borderRadius: BorderRadius.circular(30),
                color: primaryColor(isDark),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      isFrench
                          ? 'Rechercher\n par sous-catégorie'
                          : 'Searching\n by subcategory',
                      style: TextStyle(
                        color: primaryColor(!isDark),
                        fontFamily: 'RebondGrotesque',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.2,
                    child: ListWheelScrollViewX.useDelegate(
                      childCount: subCategorie.length,
                      onTap: (index) => onSubCategorieTap(
                        index,
                        isDark,
                        isFrench,
                        category,
                        context,
                      ),
                      controller: FixedExtentScrollController(initialItem: 1),
                      scrollDirection: Axis.horizontal,
                      itemExtent: width * 0.35,
                      diameterRatio: 1.5,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: subCategorie.length,
                        builder: (context, index) {
                          return subCatItem(
                              index, width, height, isDark, context);
                        },
                      ),
                    ),
                  ),
                  subCatInfoWidget(currentIndex, width, height, isDark,
                      isFrench, subCategorie.length),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          color: (indexPage == 1)
              ? shadeColor(categoryColor, 0.1)
              : (indexPage == 0)
                  ? shadeColor(Palette.orange, 0.1)
                  : shadeColor(Palette.pink, 0.1),
          buttonBackgroundColor: (indexPage == 1)
              ? shadeColor(categoryColor, 0.1)
              : (indexPage == 0)
                  ? shadeColor(Palette.orange, 0.1)
                  : shadeColor(Palette.pink, 0.1),
          backgroundColor: Colors.transparent,
          height: 60,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          index: indexPage,
          items: items,
          onTap: (index) {
            setState(() {
              indexPage = index;
              //_pageController.jumpToPage(indexPage);
              //Faire un pagecontroller.dispose
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainScreen.routeName, (route) => false,
                  arguments: {'initialPage': index});
            });
          }),
    );
  }
}
