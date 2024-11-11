import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/general_widget/data_widget.dart';
import 'package:flutter/material.dart';
import '../Model/category.dart';
import '../Model/shop.dart';
import '../Data/general_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shop_file/widget/shop_item.dart';
import 'package:cuzou_app/main.dart';

// ignore: must_be_immutable
class ShopsListScreen2 extends StatefulWidget {
  static const routeName = '/shops-list';

  final int shopListIndex;
  final List<int> favoriteShop;
  final bool isDark;
  final bool isFrench;
  final bool isGlobalResearch;
  final Color colorAppBar;
  final Color categoryColor;
  final SubCat subCatType;
  final Category category;
  final bool isCategoryResearch;
  final List<QueryDocumentSnapshot> shopsSelectedSorted;

  const ShopsListScreen2({
    Key key,
    this.shopListIndex,
    this.favoriteShop,
    this.isDark,
    this.isFrench,
    this.isGlobalResearch,
    this.colorAppBar,
    this.categoryColor,
    this.shopsSelectedSorted,
    this.subCatType,
    this.category,
    this.isCategoryResearch,
  }) : super(key: key);

  @override
  ShopsListScreen2State createState() => ShopsListScreen2State();
}

class ShopsListScreen2State extends State<ShopsListScreen2> {
  List<QueryDocumentSnapshot> shopsSelectedSorted;
  List<QueryDocumentSnapshot> shopDisplayed;
  int shopListIndex;
  List<int> favoriteShop;
  bool isInit = true;
  TextEditingController shopController;

  @override
  void initState() {
    shopListIndex = widget.shopListIndex;
    favoriteShop = widget.favoriteShop;
    shopsSelectedSorted = widget.shopsSelectedSorted;
    shopDisplayed = widget.shopsSelectedSorted;
    super.initState();
  }

  void updateDisplay(String value) {
    setState(() {
      shopDisplayed = shopsSelectedSorted.where((shop) {
        return shop['title']
            .toString()
            .toLowerCase()
            .contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (shopListIndex == 0)
        ? Scaffold(
            backgroundColor: primaryColor(widget.isDark),
            appBar: AppBar(
              backgroundColor: shadeColor(widget.colorAppBar, 0.1),
              title: Text(widget.isCategoryResearch
                  ? widget.isFrench
                      ? widget.category.frenchTitle
                      : widget.category.englishTitle
                  : widget.isFrench
                      ? frenchTextType(widget.subCatType)
                      : englishTextType(widget.subCatType)),
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
            body: (shopDisplayed == null)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          widget.isFrench
                              ? 'Aucun magasin\npour l\'instant'
                              : 'No shop added\nhere yet!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primaryColor(!widget.isDark),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RebondGrotesque',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ), //SizedBox can be seen as a separator
                      SizedBox(
                        height: 400,
                        child: Image.asset('assets/images/logos/waiting.png',
                            fit: BoxFit.cover),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      researchBar(widget.isDark, widget.isFrench, false, false,
                          updateDisplay, shopController),
                      Expanded(
                        child: SizedBox(
                          height: double.infinity,
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return ShopItem(
                                id: shopDisplayed[index]['shopId'],
                                title: shopDisplayed[index]['title'],
                                imageUrl: shopDisplayed[index]
                                    ['shopPictureUrl'],
                                city: cityList[shopDisplayed[index]['cityId']],
                                rate: shopDisplayed[index]['rate'].toDouble(),
                                // visibility: getVisibility(
                                //     shopsSelectedSorted[index]
                                //         ['visibilityId']),
                                categoryColor: widget.categoryColor,
                                isFrench: widget.isFrench,
                                isDark: widget.isDark,
                              );
                            },
                            itemCount: shopDisplayed.length,
                          ),
                        ),
                      ),
                    ],
                  ))
        : (shopDisplayed == null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.isFrench
                          ? 'Aucun magasin\npour l\'instant'
                          : 'No shop added\nhere yet!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ), //SizedBox can be seen as a separator
                  SizedBox(
                    height: 400,
                    child: Image.asset('assets/images/logos/waiting.png',
                        fit: BoxFit.cover),
                  ),
                ],
              )
            : Column(
                children: [
                  researchBar(widget.isDark, widget.isFrench, false, false,
                      updateDisplay, shopController),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return ShopItem(
                          id: shopDisplayed[index]['shopId'],
                          title: shopDisplayed[index]['title'],
                          imageUrl: shopDisplayed[index]['shopPictureUrl'],
                          city: cityList[shopDisplayed[index]['cityId']],
                          rate: shopDisplayed[index]['rate'].toDouble(),
                          // visibility: getVisibility(
                          //     shopsSelectedSorted[index]
                          //         ['visibilityId']),
                          categoryColor: widget.categoryColor,
                          isFrench: widget.isFrench,
                          isDark: widget.isDark,
                        );
                      },
                      itemCount: shopDisplayed.length,
                    ),
                  ),
                ],
              );
  }
}
