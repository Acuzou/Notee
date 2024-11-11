// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cuzou_app/shop_file/screen/myshop_screen.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shop_file/widget/shop_creation/2_shop_creation_form.dart';
import '../../shop_file/widget/shop_creation/3_shop_creation_form.dart';
import '../../shop_file/widget/shop_creation/4_shop_creation_form.dart';
import '../../shop_file/widget/shop_creation/5_shop_creation_form.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cuzou_app/research_file/Model/horaire.dart';

class ShopCreationScreen extends StatefulWidget {
  static String routeName = '/shop-creation-screen';

  const ShopCreationScreen({Key key}) : super(key: key);

  @override
  State<ShopCreationScreen> createState() => _ShopCreationScreenState();
}

class _ShopCreationScreenState extends State<ShopCreationScreen> {
  bool isLoading = false;
  bool isDark;
  bool isFrench;
  bool isInit = true;
  //bool isHiding = false;
  int pageIndex = 0;
  int _subCatId;

  String _shopEmail = '';
  String _shopTitle = '';
  String _shopAdress = '';
  String _shopWebsite = 'default';
  int _phoneNumberShop = 0;
  int _cityId = 0;

  int _shopId = 0;
  int _userSavId;
  //int _visibilityId = 0;

  String _presentationContent = '';

  File _imageShop;

  Map<Jour, List<Heure>> _horaire;

  Color colorAppBar;

  void _setPage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  // void _savePageOne(int visibilityId) {
  //   _visibilityId = visibilityId;
  // }

  void _savePageTwo(String email, String title, String adress, String website,
      int phoneNumber, int subCatIndex, int cityId) {
    _shopEmail = email;
    _shopTitle = title;
    _shopAdress = adress;
    if (website.isNotEmpty) {
      _shopWebsite = website;
    }
    _phoneNumberShop = phoneNumber;
    _subCatId = subCatIndex;
    _cityId = cityId;
  }

  void _savePageThree(File image) {
    _imageShop = image;
  }

  void _savePageFour(Map<Jour, List<Heure>> horaire, int shopId) {
    _horaire = horaire;
    _shopId = shopId;
  }

  void _savePageFive(String presentationContent) {
    _presentationContent = presentationContent;
  }

  void _submitCreationForm(
    BuildContext ctx,
    bool isDark,
    bool isFrench,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });

      User auth = FirebaseAuth.instance.currentUser;

      final ref = FirebaseStorage.instance
          .ref()
          .child('shop_image')
          .child('${auth.uid}jpg');

      await ref.putFile(_imageShop);

      final imageShopUrl = await ref.getDownloadURL();

      //Creation Donnée Shop
      await FirebaseFirestore.instance.collection('shops').doc(auth.uid).set({
        'shopId': _shopId,
        'userSavId': _userSavId,
        'email': _shopEmail,
        'title': _shopTitle,
        'address': _shopAdress,
        'website': _shopWebsite,
        'cityId': _cityId,
        'phoneNumber': _phoneNumberShop,
        'rate': 0,
        'isBan': false,
        'shopPictureUrl': imageShopUrl,
        'subCatId': _subCatId,
        'presentationContent': _presentationContent,
        'nbFavorites': 0,
        'nbPublications': 0,
        //m0 disapear in the formula with the quotient
        'meanResponseTime': 100,
        'nbResponses': 1,
        //'visibilityId': _visibilityId
      });

      //Creation de la collection horaire dans le document du magasin associé
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(auth.uid)
          .collection('horaire')
          .doc(auth.uid)
          .set({
        'mondayOp': _horaire[jourNum(1)][0].getStringHeure,
        'mondayCl': _horaire[jourNum(1)][1].getStringHeure,
        'tuesdayOp': _horaire[jourNum(2)][0].getStringHeure,
        'tuesdayCl': _horaire[jourNum(2)][1].getStringHeure,
        'wednesdayOp': _horaire[jourNum(3)][0].getStringHeure,
        'wednesdayCl': _horaire[jourNum(3)][1].getStringHeure,
        'thursdayOp': _horaire[jourNum(4)][0].getStringHeure,
        'thursdayCl': _horaire[jourNum(4)][1].getStringHeure,
        'fridayOp': _horaire[jourNum(5)][0].getStringHeure,
        'fridayCl': _horaire[jourNum(5)][1].getStringHeure,
        'saturdayOp': _horaire[jourNum(6)][0].getStringHeure,
        'saturdayCl': _horaire[jourNum(6)][1].getStringHeure,
        'sundayOp': _horaire[jourNum(7)][0].getStringHeure,
        'sundayCl': _horaire[jourNum(7)][1].getStringHeure,
      });

      //Changement attribut User
      await FirebaseFirestore.instance.collection('users').doc(auth.uid).update(
        {
          'isMerchant': true,
          'shopId': _shopId,
        },
      );

      Navigator.of(context).pushNamedAndRemoveUntil(
        MyShopScreen.routeName,
        (route) => false,
        arguments: {
          'colorAppBar': Palette.blue,
          'isDark': isDark,
          'isFrench': isFrench,
          //'isAfterCreation': true,
        },
      );
    } on PlatformException catch (err) {
      var message = 'An error occured, pleased check your credentials !';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
    }
  }

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    //double width = size.width;

    if (isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;

      isDark = routeArgs['isDark'] as bool;
      isFrench = routeArgs['isFrench'] as bool;
      colorAppBar = routeArgs['colorAppBar'] as Color;
      _userSavId = routeArgs['myId'] as int;
      isInit = false;
    }

    List<Widget> pages = [
      // ShopCreationForm(
      //   isLoading,
      //   isDark,
      //   _savePageOne,
      //   _setPage,
      //   //_onChange,
      // ),
      //TestTextField(),
      ShopCreationFormTwo(
        isLoading,
        isDark,
        isFrench,
        _savePageTwo,
        _setPage,
        _formKey,
        //_onChange,
      ),
      ShopCreationFormThree(
        isLoading,
        isDark,
        isFrench,
        _savePageThree,
        _setPage,
      ),
      ShopCreationFormFour(
        isLoading,
        isDark,
        isFrench,
        true,
        Palette.blue,
        _savePageFour,
        _setPage,
      ),

      ShopCreationFormFive(
        isLoading,
        isDark,
        isFrench,
        _savePageFive,
        _setPage,
        _submitCreationForm,
      )
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor(isDark),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: height * 1.01,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Création de votre',
                        style: TextStyle(
                          color: (isDark) ? Palette.orange : Palette.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'magasin Notee',
                        style: TextStyle(
                          color: (isDark) ? Palette.orange : Palette.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(
                      //   height: 60,
                      //   child: Image.asset(
                      //       'assets/images/logos/logo_notee/icon_blanc.png',
                      //       fit: BoxFit.cover),
                      // ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 30,
                  child: pages[pageIndex],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
