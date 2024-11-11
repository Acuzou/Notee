import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuzou_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Data/data_function.dart';

// ignore: must_be_immutable
class FavoriteButton extends StatefulWidget {
  bool isDark;
  bool favoriteState;
  int shopId;
  List<QueryDocumentSnapshot> shopsDocs;
  QueryDocumentSnapshot shopSelected;

  FavoriteButton({
    Key key,
    this.isDark,
    this.favoriteState,
    this.shopId,
    this.shopSelected,
    this.shopsDocs,
  }) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool favoriteState;

  @override
  void initState() {
    favoriteState = widget.favoriteState;
    super.initState();
  }

  void _setFavorite(bool isFavorite, int shopId, dynamic shopSelected,
      List<QueryDocumentSnapshot> shopsData) async {
    try {
      var auth = FirebaseAuth.instance.currentUser;
      (isFavorite)
          ? await FirebaseFirestore.instance
              .collection("users")
              .doc(auth.uid)
              .collection("favorite")
              .doc(shopId.toString())
              .set({
              'shopId': shopId,
              'subCatId': shopSelected['subCatId'],
            })
          : await FirebaseFirestore.instance
              .collection("users")
              .doc(auth.uid)
              .collection("favorite")
              .doc(shopId.toString())
              .delete();

      (isFavorite)
          ? await FirebaseFirestore.instance
              .collection('shops')
              .doc(shopSelected.id)
              .update({'nbFavorites': shopSelected['nbFavorites'] - 1})
          : await FirebaseFirestore.instance
              .collection('shops')
              .doc(shopSelected.id)
              .update({'nbFavorites': shopSelected['nbFavorites'] + 1});

      double rate = getRate(
          shopSelected['nbPublications'],
          shopSelected['nbFavorites'],
          shopSelected['meanResponseTime'].toDouble(),
          shopSelected['subCatId'],
          shopsData);

      await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopSelected.id)
          .update({'rate': rate});
    } on PlatformException catch (err) {
      var message = 'An error occured, pleased check your credentials !';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 20,
        top: 10,
        bottom: 10,
      ),
      child: (favoriteState)
          ?
          //Activate FavoriteButton
          IconButton(
              icon: const Icon(
                Icons.favorite,
                size: 30,
              ),
              color: secondaryColor(!widget.isDark, Palette.pink),
              onPressed: () {
                setState(() {
                  favoriteState = false;
                  _setFavorite(favoriteState, widget.shopId,
                      widget.shopSelected, widget.shopsDocs);
                });
              }, //Function registering the shop as fav
            )
          :
          //Desactivate FavoriteButton
          IconButton(
              icon: const Icon(Icons.favorite_border_rounded, size: 30),
              color: secondaryColor(!widget.isDark, Palette.pink),
              onPressed: () {
                setState(() {
                  favoriteState = true;
                  _setFavorite(favoriteState, widget.shopId,
                      widget.shopSelected, widget.shopsDocs);
                });
              },
            ),
    );
  }
}
