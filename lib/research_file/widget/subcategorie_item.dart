import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';
import '../Screen/shops_list.dart';
import '../Model/shop.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';

class SubCategoryItem extends StatelessWidget {
  final int id;
  final SubCat type;
  final Color color;
  final Icon icon;
  final bool isDark;
  final bool isFrench;

  const SubCategoryItem(
      {Key key,
      this.id,
      this.type,
      this.color,
      this.icon,
      this.isDark,
      this.isFrench})
      : super(key: key);

  void selectSubCategory(BuildContext ctx) {
    Navigator.pushNamed(
      ctx,
      ShopsListScreen.routeName,
      arguments: {
        'subCatList': [type],
        'colorAppBar': Palette.blue,
        'color': color,
        'isGlobalResearch': false,
        'isCategoryResearch': false,
        'isDark': isDark,
        'isFrench': isFrench,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => selectSubCategory(context),
        //splashColor: Theme.of(context).primaryColor,
        splashColor: primaryColor(!isDark),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          width: (width - 60) / 2,
          height: height / 4,
          //child : Image.asset('images/logos/logo_restaurant.png', fit: BoxFit.cover),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                //child: Image.asset(imageAsset, fit: BoxFit.cover),
                child: icon,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  isFrench ? frenchTextType(type) : englishTextType(type),
                  style: Theme.of(context).textTheme.headline4,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
