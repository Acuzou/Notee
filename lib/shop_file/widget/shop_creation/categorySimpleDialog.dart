// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cuzou_app/research_file/Model/shop.dart';
import 'package:cuzou_app/research_file/Data/data_shop.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';
import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/research_file/Model/category.dart';

// ignore: must_be_immutable
class SimpleDialogCategory extends StatefulWidget {
  final double width;
  final double height;
  int catIndex;
  final int subCatId;
  final bool isCatPage;
  final bool isFrench;
  final void Function(
    SubCat subCatSelected,
    String subCatText,
  ) submitCategory;

  SimpleDialogCategory({
    Key key,
    this.width,
    this.height,
    this.catIndex,
    this.subCatId,
    this.isFrench,
    this.isCatPage,
    this.submitCategory,
  }) : super(key: key);

  @override
  State<SimpleDialogCategory> createState() => _SimpleDialogCategoryState();
}

class _SimpleDialogCategoryState extends State<SimpleDialogCategory> {
  SubCat subCatSelected = SubCat.Default;
  String subCatTextSelected = 'Default';
  int catInteger;
  int subCatInteger;

  List<Category> catList = SHOP_CATEGORIES;

  double factorWSD = 0.7;
  double factorHSD = 0.4;

  void sendSubCat(SubCat subCatSelected, String subCatTextSelected) {
    if (subCatSelected != SubCat.Default) {
      widget.submitCategory(subCatSelected, subCatTextSelected);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Widget catItem(
    int catIndex,
    String title,
    Color color,
  ) {
    return Container(
      width: widget.width * 0.3,
      height: widget.height * 0.17,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialogCategory(
              width: widget.width,
              height: widget.height,
              catIndex: catIndex,
              isCatPage: false,
              submitCategory: widget.submitCategory,
              isFrench: widget.isFrench,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
            bottom: 5,
          ),
          side: BorderSide(
            width: 6,
            color: color,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              width: widget.width * 0.18,
              height: widget.height * 0.1,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(catList[catIndex].image),
                    fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        'Liste des Catégories',
        style: TextStyle(
          color: Palette.orange,
        ),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: tintColor(Palette.black, 0.01),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            (widget.isCatPage)
                //Categorie Choice Page
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          catItem(
                              0,
                              widget.isFrench
                                  ? SHOP_CATEGORIES[0].frenchTitle
                                  : SHOP_CATEGORIES[0].englishTitle,
                              Palette.orange),
                          catItem(
                              1,
                              widget.isFrench
                                  ? SHOP_CATEGORIES[1].frenchTitle
                                  : SHOP_CATEGORIES[1].englishTitle,
                              Palette.yellow),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          catItem(
                              2,
                              widget.isFrench
                                  ? SHOP_CATEGORIES[2].frenchTitle
                                  : SHOP_CATEGORIES[2].englishTitle,
                              Palette.green),
                          catItem(
                              3,
                              widget.isFrench
                                  ? SHOP_CATEGORIES[3].frenchTitle
                                  : SHOP_CATEGORIES[3].englishTitle,
                              Palette.purple),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          catItem(
                              4,
                              widget.isFrench
                                  ? SHOP_CATEGORIES[4].frenchTitle
                                  : SHOP_CATEGORIES[4].englishTitle,
                              Palette.pink),
                          catItem(
                              5,
                              widget.isFrench
                                  ? SHOP_CATEGORIES[5].frenchTitle
                                  : SHOP_CATEGORIES[5].englishTitle,
                              Palette.blue),
                        ],
                      ),
                    ],
                  )

                //SubCategory Choice Page
                : SizedBox(
                    height: widget.height * 0.598,
                    width: widget.width * 0.7,
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        Category cat = catList[widget.catIndex];
                        Color color = cat.color;
                        SubCat subCat = cat.subcategorie[index];
                        String subCatText = widget.isFrench
                            ? frenchTextType(subCat)
                            : englishTextType(subCat);

                        return Column(children: [
                          SizedBox(
                            width: widget.width * 0.6,
                            height: widget.height * 0.1,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  subCatSelected = subCat;
                                  subCatTextSelected = subCatText;
                                  subCatInteger = index;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 5,
                                  bottom: 5,
                                ),
                                side: (subCatInteger == index)
                                    ? BorderSide(
                                        width: 5, color: shadeColor(color, 0.3))
                                    : BorderSide(
                                        width: 2,
                                        color: color,
                                      ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //SubCatText
                                  SizedBox(
                                    width: widget.width * 0.3,
                                    child: Text(
                                      subCatText,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'RebondGrosteque',
                                          color: color),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  SizedBox(width: widget.width * 0.07),

                                  //SubCatIcon
                                  SizedBox(
                                    width: widget.width * 0.15,
                                    child: Container(
                                      color: color,
                                      child: Image.asset(
                                        SHOP_SUBCATEGORIES(true)
                                            .firstWhere((subCatData) =>
                                                subCatData.type == subCat)
                                            .image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ]);
                      },
                      itemCount: catList[widget.catIndex].subcategorie.length,
                    ),
                  ),

            const SizedBox(
              height: 20,
            ),

            //End Button

            (widget.isCatPage)
                //Return Button
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.isFrench ? 'Retour' : 'Return',
                      style: TextStyle(
                        color: Palette.orange,
                        fontSize: 16,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Return Button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.isFrench ? 'Retour' : 'Return',
                          style: TextStyle(
                            color: Palette.orange,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      //Validate Button
                      ElevatedButton(
                        onPressed: () {
                          sendSubCat(subCatSelected, subCatTextSelected);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: shadeColor(Palette.orange, 0.3),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 15,
                          ),
                        ),
                        child: Text(
                          widget.isFrench ? "Valider" : 'Validate',
                          style: TextStyle(
                            color: Palette.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        )
      ],
    );
  }
}
