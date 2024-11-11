import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/shop_file/screen/myshop.dart';
import 'package:cuzou_app/shop_file/widget/shop_creation/card_myshop.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyShopScreen extends StatefulWidget {
  static const routeName = '/my-shop';

  const MyShopScreen({Key key}) : super(key: key);

  @override
  MyShopScreenState createState() => MyShopScreenState();
}

class MyShopScreenState extends State<MyShopScreen> {
  User auth = FirebaseAuth.instance.currentUser;

  Color colorAppBar;
  bool _isDark;
  bool _isFrench;
  int _shopId;
  int _myId;
  bool _isMerchant;

  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    colorAppBar = routeArg['colorAppBar'] as Color;
    _isDark = routeArg['isDark'] as bool;
    _isFrench = routeArg['isFrench'] as bool;

    return Scaffold(
      backgroundColor: primaryColor(_isDark),
      appBar: AppBar(
        backgroundColor: shadeColor(colorAppBar, 0.1),
        title: Text(_isFrench ? "Mon Magasin" : 'My Store'),
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
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasError) {
                const Text('Something went wrong.');
              }

              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final usersDocs = userSnapshot.data.docs;
              var userData = usersDocs
                  .firstWhere((user) => user.data()['email'] == auth.email);

              _isMerchant = userData.data()['isMerchant'];
              _shopId = userData.data()['shopId'];
              _myId = userData.data()['ID'];

              // final selectedShop =
              //     dataShops.firstWhere((shop) => shop.id == _shopId);

              // final List<News> selectedNews =
              //     dataNews.where((news) => news.shopId == _shopId).toList();

              return !_isMerchant
                  ? notMerchantCard(
                      shopId: _shopId,
                      myId: _myId,
                      isDark: _isDark,
                      colorAppBar: colorAppBar,
                      isFrench: _isFrench,
                    )
                  : MyShop(
                      myId: _myId,
                      shopId: _shopId,
                      isDark: _isDark,
                      color: colorAppBar,
                      isFrench: _isFrench,
                    );
            }),
      ),
    );
  }
}
