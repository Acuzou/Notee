import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/research_file/Data/data_shop.dart';
import 'package:cuzou_app/general_widget/data_widget.dart';
import 'package:cuzou_app/research_file/Screen/shops_list.dart';
import 'package:flutter/material.dart';
import '../Model/shop.dart';
import '../Screen/detail_categorie_screen.dart';
import '../Model/category.dart';

import '../../general_widget/listWheelScroll.dart';

// ignore: must_be_immutable
class CategoriesScreen extends StatefulWidget {
  bool isDark;
  bool isFrench;

  CategoriesScreen({Key key, this.isDark, this.isFrench}) : super(key: key);
  static const routeName = "/categorie-screen";

  @override
  CategorieScreenState createState() => CategorieScreenState();
}

class CategorieScreenState extends State<CategoriesScreen> {
  int currentIndex = 1;

  TextEditingController shopController;
  //ScrollController scrollController = FixedExtentScrollController();

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
  }

//   void _onScroll() {

//   }

//   @override
//   void dispose() {
//     scrollController.removeListener(_onScroll);
//     scrollController.dispose();
//     super.dispose();
// }

  void updateDisplay(String value) {}

  void onCategorieTap(index) {
    Category shopCat = SHOP_CATEGORIES[index];

    Navigator.pushNamed(
      context,
      CategorieDetailScreen.routeName,
      arguments: {
        'category': shopCat,
        'isFrench': widget.isFrench,
        'isDark': widget.isDark,
      },
    );
  }

  Widget catItem(index, width, height, isDark, isFrench, context) {
    Category shopCat = SHOP_CATEGORIES[index];

    return Padding(
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
          decoration: BoxDecoration(
            color: shopCat.color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1,
              color: secondaryColor(!isDark, shopCat.color),
            ),
          ),
          child: Image.asset(shopCat.image, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget catInfoWidget(index, width, height) {
    String title = widget.isFrench
        ? SHOP_CATEGORIES[index].frenchTitle
        : SHOP_CATEGORIES[index].englishTitle;

    return Container(
      height: height * 0.1,
      width: width * 0.6,
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                (index == 0) ? Icons.circle : Icons.circle_outlined,
                size: (index == 0) ? 15 : 10,
                color: secondaryColor(!widget.isDark, Palette.blue),
              ),
              Icon(
                (index == 1) ? Icons.circle : Icons.circle_outlined,
                size: (index == 1) ? 15 : 10,
                color: secondaryColor(!widget.isDark, Palette.blue),
              ),
              Icon(
                (index == 2) ? Icons.circle : Icons.circle_outlined,
                size: (index == 2) ? 15 : 10,
                color: secondaryColor(!widget.isDark, Palette.blue),
              ),
              Icon(
                (index == 3) ? Icons.circle : Icons.circle_outlined,
                size: (index == 3) ? 15 : 10,
                color: secondaryColor(!widget.isDark, Palette.blue),
              ),
              Icon(
                (index == 4) ? Icons.circle : Icons.circle_outlined,
                size: (index == 4) ? 15 : 10,
                color: secondaryColor(!widget.isDark, Palette.blue),
              ),
              Icon(
                (index == 5) ? Icons.circle : Icons.circle_outlined,
                size: (index == 5) ? 15 : 10,
                color: secondaryColor(!widget.isDark, Palette.blue),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: primaryColor(!widget.isDark),
          ),
          Text(
            title,
            style: TextStyle(
              color: primaryColor(!widget.isDark),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: height * 0.02),
            child: Column(
              children: [
                Text(
                  widget.isFrench ? 'Bonjour :)' : 'Hello :)',
                  style: TextStyle(
                    color: primaryColor(!widget.isDark),
                    fontFamily: 'RebondGrotesque',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.isFrench
                      ? 'Vous recherchez...'
                      : 'You are searching...',
                  style: TextStyle(
                    color: primaryColor(!widget.isDark),
                    fontFamily: 'RebondGrotesque',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: secondaryColor(!widget.isDark, Palette.blue)),
              borderRadius: BorderRadius.circular(30),
              color: primaryColor(widget.isDark),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    widget.isFrench ? 'Par nom' : 'By name',
                    style: TextStyle(
                      color: primaryColor(!widget.isDark),
                      fontFamily: 'RebondGrotesque',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ShopsListScreen.routeName,
                      arguments: {
                        'isGlobalResearch': true,
                        'isCategoryResearch': false,
                        'colorAppBar': Palette.blue,
                        'isDark': widget.isDark,
                        'isFrench': widget.isFrench,
                        'subCatList': [SubCat.Default],
                        'color': Palette.blue,
                      },
                    );
                  },
                  child: researchBar(widget.isDark, widget.isFrench, true,
                      false, updateDisplay, shopController),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: secondaryColor(!widget.isDark, Palette.blue)),
                borderRadius: BorderRadius.circular(30),
                color: primaryColor(widget.isDark),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      widget.isFrench ? 'Par catégorie' : 'By category',
                      style: TextStyle(
                        color: primaryColor(!widget.isDark),
                        fontFamily: 'RebondGrotesque',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.2,
                    // child: GestureDetector(
                    //   onTap: () {
                    //     onCategorieTap(currentIndex);
                    //   },
                    child: ListWheelScrollViewX(
                        onTap: onCategorieTap,
                        controller: FixedExtentScrollController(initialItem: 1),
                        scrollDirection: Axis.horizontal,
                        itemExtent: width * 0.35,
                        diameterRatio: 1.5,
                        physics: const ScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        children: [
                          catItem(0, width, height, widget.isDark,
                              widget.isFrench, context),
                          catItem(1, width, height, widget.isDark,
                              widget.isFrench, context),
                          catItem(2, width, height, widget.isDark,
                              widget.isFrench, context),
                          catItem(3, width, height, widget.isDark,
                              widget.isFrench, context),
                          catItem(4, width, height, widget.isDark,
                              widget.isFrench, context),
                          catItem(5, width, height, widget.isDark,
                              widget.isFrench, context),
                        ]),
                  ),
                  // physics: const FixedExtentScrollPhysics(),
                  // childDelegate: ListWheelChildBuilderDelegate(
                  //   childCount: 6,
                  //   builder: (context, index) {
                  //     return catItem(
                  //         index, width, height, isDark, isFrench, context);
                  //   },
                  // ),

                  catInfoWidget(currentIndex, width, height),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          )
        ],
      ),
    );
  }
}
