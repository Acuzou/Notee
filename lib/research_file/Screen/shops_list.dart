import 'package:cuzou_app/research_file/Screen/shops_list2.dart';
import 'package:flutter/material.dart';
import '../Model/category.dart';
import '../Model/shop.dart';
import '../Data/general_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ShopsListScreen extends StatefulWidget {
  static const routeName = '/shops-list';

  final int shopListIndex;
  final List<int> favoriteShop;
  final Color colorAppBar;
  final bool isDark;
  final bool isFrench;

  const ShopsListScreen({
    Key key,
    this.shopListIndex,
    this.colorAppBar,
    this.isDark,
    this.isFrench,
    this.favoriteShop,
  }) : super(key: key);

  @override
  ShopsListScreenState createState() => ShopsListScreenState();
}

class ShopsListScreenState extends State<ShopsListScreen> {
  //List<SubCat> catTypeList = [];
  List<QueryDocumentSnapshot> shopsSelectedSorted;
  int shopListIndex;
  List<int> favoriteShop;
  bool isInit = true;

  List<SubCat> _subCatList = [];
  bool isGlobalResearch = false;
  Color categoryColor;
  Color colorAppBar;
  bool isDark;
  bool isFrench;
  Category category;
  bool isCategoryResearch;

  @override
  void initState() {
    shopListIndex = widget.shopListIndex;
    favoriteShop = widget.favoriteShop;
    colorAppBar = widget.colorAppBar;
    categoryColor = widget.colorAppBar;
    isDark = widget.isDark;
    isFrench = widget.isFrench;
    super.initState();
  }

  // CategoryMealsScreen(this.categoryId, this.categoryTitle);

  dynamic sortedShopVisibilty(dynamic shopsList) {
    dynamic diamondShop = shopsList.where((shop) {
      return shop["visibilityId"] == 3;
    }).toList();
    dynamic goldShop = shopsList.where((shop) {
      return shop["visibilityId"] == 2;
    }).toList();
    dynamic silverShop = shopsList.where((shop) {
      return shop["visibilityId"] == 1;
    }).toList();
    dynamic bronzeShop = shopsList.where((shop) {
      return shop["visibilityId"] == 0;
    }).toList();

    return diamondShop + goldShop + silverShop + bronzeShop;
  }

  // @override
  // void initState() {
  //   isInitState = true;
  // }

  void sortedShop(List<QueryDocumentSnapshot> shopsDocs, bool isGlobalResearch,
      List<SubCat> subCatListArg) {
    List<QueryDocumentSnapshot> shopsSelected = [];
    if (shopListIndex == 0) {
      if (isGlobalResearch) {
        shopsSelected = shopsDocs.toList();
      } else {
        //Reinitialization
        //catTypeList = [];

        for (int i = 0; i < subCatListArg.length; i++) {
          List<QueryDocumentSnapshot> partialShopSelected = shopsDocs
              .where((shop) =>
                  shop['subCatId'] == getSubCatIndex(subCatListArg[i]))
              .toList();
          shopsSelected = shopsSelected + partialShopSelected;
          //catTypeList.add(subCatList[_subCatIdList[i]]);
        }

        // shopsSelected =
        //     shopsDocs.where((shop) => shop['subCatId'] == subCatId).toList();
      }
    } else {
      if (shopListIndex == 1) {
        shopsSelected = shopsDocs
            .where((shop) => favoriteShop.contains(shop['shopId']))
            .toList();
      }
    }

    if (shopsSelected != null) {
      shopsSelected.sort((shopA, shopB) {
        double rateA = shopA['rate'].toDouble();
        double rateB = shopB['rate'].toDouble();

        return rateB.compareTo(rateA);
      });

      //Mettre setState si trop long pour trier //Problème du setState ici
      shopsSelectedSorted = shopsSelected.toList();
    }

    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    if (shopListIndex != 1) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;

      _subCatList = routeArgs['subCatList'] as List<SubCat>;
      isGlobalResearch = routeArgs['isGlobalResearch'] as bool;
      isCategoryResearch = routeArgs['isCategoryResearch'] as bool;
      category = routeArgs['category'] as Category;
      categoryColor = routeArgs['color'] as Color;
      colorAppBar = routeArgs['colorAppBar'] as Color;

      isDark = routeArgs['isDark'] as bool;
      isFrench = routeArgs['isFrench'] as bool;
    } else {
      _subCatList.add(SubCat.Default);
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('shops').snapshots(),
        builder: (context, shopSnapshot) {
          if (shopSnapshot.hasError) {
            const Text('Something went wrong.');
          }
          if (shopSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<QueryDocumentSnapshot> shopsDocs = shopSnapshot.data.docs;

          if (isInit) {
            sortedShop(shopsDocs, isGlobalResearch, _subCatList);
          }

          return ShopsListScreen2(
            shopListIndex: shopListIndex,
            favoriteShop: favoriteShop,
            isDark: isDark,
            isFrench: isFrench,
            isGlobalResearch: isGlobalResearch,
            isCategoryResearch: isCategoryResearch,
            category: category,
            colorAppBar: colorAppBar,
            categoryColor: categoryColor,
            shopsSelectedSorted: shopsSelectedSorted,
            subCatType: _subCatList[0],
          );
        });
  }
}
