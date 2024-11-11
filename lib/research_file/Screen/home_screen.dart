import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/research_file/Data/data_shop.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../Screen/detail_categorie_screen.dart';
import '../Model/category.dart';
import '../widget/categorie_item.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  bool isDark;
  bool isFrench;

  HomeScreen(this.isDark, this.isFrench, {Key key}) : super(key: key);
  static const routeName = "/home-screen";

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isFrench;
  bool _isDark;
  bool isInitState;

  @override
  // ignore: must_call_super
  void initState() {
    _isFrench = widget.isFrench;
    _isDark = widget.isDark;
    isInitState = true;
  }

  Future<void> setSettings() async {
    try {
      User auth = FirebaseAuth.instance.currentUser;

      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final users = userSnapshot.docs;
      final user =
          users.firstWhere((user) => user.data()['email'] == auth.email);
      bool isFrench = user.data()['isFrench'];
      bool isDark = user.data()['isDark'];

      setState(() {
        _isFrench = isFrench;
        _isDark = isDark;
        isInitState = false;
      });
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

  Widget catItem(index, width, height, isDark, isFrench, context) {
    Category shopCat = SHOP_CATEGORIES[index];

    String title = isFrench ? shopCat.frenchTitle : shopCat.englishTitle;

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
        child: CategoryItem(
          key: const Key(""),
          title: title,
          color: (isDark) ? shopCat.color : shadeColor(shopCat.color, 0.1),
          imageAsset: shopCat.image,
          width: double.infinity,
          onTap: () {
            Navigator.pushNamed(
              context,
              CategorieDetailScreen.routeName,
              arguments: {
                'id': shopCat.id,
                'title': title,
                'color': shopCat.color,
                'subcategorie': shopCat.subcategorie,
                'image': shopCat.image,
                'isFrench': isFrench,
                'isDark': isDark,
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    if (isInitState) {
      setSettings();
    }

    return Scaffold(
      //backgroundColor: Palette.primary,
      backgroundColor: primaryColor(_isDark),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                catItem(0, width, height, _isDark, _isFrench, context),
                catItem(1, width, height, _isDark, _isFrench, context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                catItem(2, width, height, _isDark, _isFrench, context),
                catItem(3, width, height, _isDark, _isFrench, context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                catItem(4, width, height, _isDark, _isFrench, context),
                catItem(5, width, height, _isDark, _isFrench, context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
