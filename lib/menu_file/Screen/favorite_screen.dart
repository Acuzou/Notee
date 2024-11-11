import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/research_file/Screen/shops_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';

import '../../research_file/Data/general_data.dart';
import '../../research_file/Model/category.dart';

// ignore: must_be_immutable
class MyFavorite extends StatelessWidget {
  static const routeName = '/my-favorite';
  Category category;

  List<int> favoriteShop = [];

  User auth = FirebaseAuth.instance.currentUser;

  MyFavorite({Key key}) : super(key: key);

  List<int> _setFavoriteList(List<QueryDocumentSnapshot> favoriteSnapshot) {
    List<QueryDocumentSnapshot> fav = favoriteSnapshot.toList();

    List<int> favList = [];

    if (category != null) {
      fav = fav
          .where((favShop) =>
              category.subcategorie.contains(subCatList[favShop['subCatId']]))
          .toList();
    }

    for (int i = 0; i < fav.length; i++) {
      favList.add(fav[i]['shopId']);
    }
    return favList;
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    final Color colorAppBar = routeArgs['colorAppBar'] as Color;
    final bool isFrench = routeArgs['isFrench'] as bool;
    final bool isDark = routeArgs['isDark'] as bool;
    category = routeArgs['category'] as Category;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.uid)
            .collection('favorite')
            .snapshots(),
        builder: (context, favoriteSnapshot) {
          if (favoriteSnapshot.hasError) {
            const Text('Something went wrong.');
          }
          if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (favoriteSnapshot.hasData) {
            favoriteShop = _setFavoriteList(favoriteSnapshot.data.docs);
          }

          return Scaffold(
            backgroundColor: primaryColor(isDark),
            appBar: AppBar(
              backgroundColor: shadeColor(colorAppBar, 0.1),
              title: Text(isFrench ? 'Mes Favories' : 'My Favorites'),
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
            body: Center(
              // child: favoriteShop.length == 0
              //     ? Text(
              //         'Tu n\'a pas de favori pour l\'instant ! \n N\'hésite pas à en ajouter !',
              //         style: TextStyle(color: Palette.black))
              //     : ShopsListScreen(1)),
              child: (!favoriteSnapshot.hasData)
                  ? Text(
                      'Tu n\'a pas de favori pour l\'instant ! \n N\'hésite pas à en ajouter !',
                      style: TextStyle(color: Palette.white),
                    )
                  : ShopsListScreen(
                      shopListIndex: 1,
                      favoriteShop: favoriteShop,
                      isDark: isDark,
                      isFrench: isFrench,
                      colorAppBar: colorAppBar,
                    ),
            ),
          );
        });
  }
}
