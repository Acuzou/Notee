import 'package:flutter/material.dart';

import '../../research_file/Model/shop.dart';
import '../screen/shop_detail_screen.dart';
import 'package:cuzou_app/main.dart';

class ShopItem extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;
  final double rate;
  //final VisibilityShop visibility;
  final City city;
  final Color categoryColor;
  final bool isFrench;
  final bool isDark;

  const ShopItem({
    Key key,
    this.id,
    this.title,
    this.imageUrl,
    this.rate,
    //this.visibility,
    this.city,
    this.categoryColor,
    this.isFrench,
    this.isDark,
  }) : super(key: key);

  void selectShop(BuildContext context) {
    Navigator.pushNamed(context, ShopDetailScreen.routeName, arguments: {
      'shopId': id,
      'isFrench': isFrench,
      'isDark': isDark,
      'categoryColor': categoryColor,
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectShop(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),

                  //child: Image.network(

                  child: Image(
                    image: NetworkImage(imageUrl),
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: categoryColor,
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 8,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              (rate).toStringAsFixed(2),
                              style: TextStyle(
                                  color: Palette.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RebondGrotesque'),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber[500],
                              size: 30,
                            ),
                          ],
                        )),
                  ),
                  // SizedBox(
                  //   width: 22,
                  //   child: Image.asset(visibilityImageURL, fit: BoxFit.cover),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Mettre image cartoon ou logo
  // String get visibilityImageURL {
  //   switch (visibility) {
  //     case VisibilityShop.Bronze:
  //       return 'assets/images/logos/visibility_logos/bronze.png';
  //     case VisibilityShop.Silver:
  //       return 'assets/images/logos/visibility_logos/silver.png';
  //     case VisibilityShop.Gold:
  //       return 'assets/images/logos/visibility_logos/gold.png';
  //     case VisibilityShop.Diamond:
  //       return 'assets/images/logos/visibility_logos/diamond.png';
  //     default:
  //       return 'assets/images/logos/visibility_logos/bronze.png';
  //   }
  // }
}
