// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';
import 'package:cuzou_app/research_file/Model/shop.dart';
import 'package:cuzou_app/authentication_file/widget/cityDialog.dart';
import 'package:cuzou_app/shop_file/widget/shop_creation/categorySimpleDialog.dart';

class ModifyShopInfoAccount extends StatefulWidget {
  static const routeName = "/modify-shop-info-account";

  const ModifyShopInfoAccount({Key key}) : super(key: key);

  @override
  ModifyShopInfoAccountState createState() => ModifyShopInfoAccountState();
}

class ModifyShopInfoAccountState extends State<ModifyShopInfoAccount> {
  final _formKey = GlobalKey<FormState>();
  bool isInit = true;
  Color colorAppBar;
  bool _isDark;
  bool _isFrench;

  final double iconSize = 30;

  String _postalAdress;
  String _emailAdress;
  String _website;
  int _phoneNumber;
  int _cityId;
  int _subCatId;

  String _cityText;

  String _subCatText;
  SubCat _subCatSelected;

  int pageSize = 12;
  double fontSizeTitle = 26;

  void _submitCity(int cityId, String cityName) {
    setState(() {
      _cityId = cityId;
      _cityText = cityName;
      isInit = false;
    });
  }

  void _submitCategory(SubCat subCat, String subCatText) {
    setState(() {
      _subCatSelected = subCat;
      _subCatText = subCatText;
      isInit = false;
    });
  }

  void _submitData(
    BuildContext context,
    String postalAdress,
    String emailAdress,
    String website,
    int phoneNumber,
    int cityId,
    bool isFrench,
    SubCat subCatSelected,
  ) async {
    _formKey.currentState.validate();
    _formKey.currentState.save();
    FocusScope.of(context).unfocus();

    int subCatIndex = getSubCatIndex(subCatSelected);

    try {
      User auth = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('shops')
          .doc(auth.uid)
          .update({
        'address': postalAdress.trim(),
        'email': emailAdress.trim(),
        'website': website.trim(),
        'phoneNumber': phoneNumber,
        'cityId': cityId,
        'subCatId': subCatIndex,
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

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    colorAppBar = routeArgs['colorAppBar'] as Color;
    _isDark = routeArgs['isDark'] as bool;
    _isFrench = routeArgs['isFrench'] as bool;

    if (isInit) {
      _postalAdress = routeArgs['postalAdress'] as String;
      _emailAdress = routeArgs['emailAdress'] as String;
      _website = routeArgs['website'] as String;
      _phoneNumber = routeArgs['phoneNumber'] as int;
      _cityId = routeArgs['cityId'] as int;
      _subCatId = routeArgs['subCatId'] as int;
      _subCatSelected = subCatList[_subCatId];

      _subCatText = _isFrench
          ? frenchTextType(subCatList[_subCatId])
          : englishTextType(subCatList[_subCatId]);
      _cityText = getCityName(cityList[_cityId]);

      isInit = false;
    }

    return Scaffold(
      backgroundColor: primaryColor(_isDark),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: shadeColor(colorAppBar, 0.1),
        title: Text(_isFrench ? 'Mon Magasin' : 'My Store'),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: height * 0.9,
          child: Column(
            children: [
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      _isFrench
                          ? 'Modification\ndes informations\nmagasins'
                          : 'Shop\ninformations\nmodification',
                      style: TextStyle(
                        color: secondaryColor(!_isDark, colorAppBar),
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RebondGrotesque',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),

              Flexible(
                flex: pageSize,
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: width * 0.80,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardAppearance:
                                  _isDark ? Brightness.dark : Brightness.light,
                              key: const ValueKey('address'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  if (_isFrench) {
                                    return 'Entrez une adresse postale valide s\'il vous plait !';
                                  } else {
                                    return 'Please, enter a valid address !';
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: Palette.black,
                                  size: iconSize,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: secondaryColor(
                                          !_isDark, Palette.blue),
                                      width: 3.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: secondaryColor(
                                          !_isDark, Palette.blue),
                                      width: 1.0),
                                ),
                                hintText: _postalAdress,
                                hintStyle: TextStyle(
                                  color: Palette.black,
                                  fontFamily: 'RebondGrotesque',
                                ),
                              ),
                              initialValue: _postalAdress,

                              //OnChanged
                              onChanged: (value) {
                                _postalAdress = value;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardAppearance:
                                  _isDark ? Brightness.dark : Brightness.light,
                              key: const ValueKey('email'),
                              validator: (value) {
                                if (!value.contains('@') || value.isEmpty) {
                                  if (_isFrench) {
                                    return 'Entrez une adresse email valide s\'il vous plait !';
                                  } else {
                                    return 'Please, enter a valid email !';
                                  }
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Palette.black,
                                  size: iconSize,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: secondaryColor(
                                          !_isDark, Palette.blue),
                                      width: 3.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: secondaryColor(
                                          !_isDark, Palette.blue),
                                      width: 1.0),
                                ),
                                hintText: _emailAdress,
                                hintStyle: TextStyle(
                                  color: tintColor(Palette.black, 0.1),
                                  fontFamily: 'RebondGrotesque',
                                ),
                              ),
                              initialValue: _emailAdress,
                              onChanged: (value) {
                                _emailAdress = value;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardAppearance:
                                  _isDark ? Brightness.dark : Brightness.light,
                              key: const ValueKey('phonenumber'),
                              validator: (value) {
                                if ((value.length > 10) && (value.length < 9)) {
                                  if (_isFrench) {
                                    return 'Entrez un numéro valide s\'il vous plait !';
                                  } else {
                                    return 'Please, enter a valid phone number !';
                                  }
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone_outlined,
                                  color: Palette.black,
                                  size: iconSize,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: secondaryColor(
                                          !_isDark, Palette.blue),
                                      width: 3.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: secondaryColor(
                                          !_isDark, Palette.blue),
                                      width: 1.0),
                                ),
                                hintText: _isFrench
                                    ? '0$_phoneNumber'
                                    : _phoneNumber.toString(),
                                hintStyle: TextStyle(
                                  color: tintColor(Palette.black, 0.1),
                                  fontFamily: 'RebondGrotesque',
                                ),
                              ),
                              initialValue: _isFrench
                                  ? '0$_phoneNumber'
                                  : _phoneNumber.toString(),
                              onChanged: (value) {
                                _phoneNumber = int.parse(value);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardAppearance:
                                  _isDark ? Brightness.dark : Brightness.light,
                              key: const ValueKey('website'),
                              validator: (value) {
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.web,
                                  color: Palette.black,
                                  size: iconSize,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: secondaryColor(
                                          !_isDark, Palette.blue),
                                      width: 3.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: secondaryColor(
                                          !_isDark, Palette.blue),
                                      width: 1.0),
                                ),
                                hintText: _website,
                                hintStyle: TextStyle(
                                  color: tintColor(Palette.black, 0.1),
                                  fontFamily: 'RebondGrotesque',
                                ),
                              ),
                              initialValue: _website,
                              onChanged: (value) {
                                _website = value;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //SubCategorie Simple Dialogue
                                SizedBox(
                                  width: width * 0.33,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            SimpleDialogCategory(
                                          width: width,
                                          height: height,
                                          catIndex: 0,
                                          isCatPage: true,
                                          submitCategory: _submitCategory,
                                          isFrench: _isFrench,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 4,
                                      backgroundColor: colorAppBar,
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 12,
                                        bottom: 12,
                                      ),
                                      shape: const StadiumBorder(),
                                      side: BorderSide(
                                        width: 1,
                                        color: secondaryColor(
                                            !_isDark, colorAppBar),
                                      ),
                                    ),
                                    child: Text(
                                      _subCatText,
                                      style: TextStyle(
                                        color: secondaryColor(
                                            !_isDark, colorAppBar),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'RebondGrotesque',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),

                                //City Choice Button
                                SizedBox(
                                  width: width * 0.33,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialogCity(
                                            width: width,
                                            height: height,
                                            submitCity: _submitCity,
                                            isFrench: _isFrench),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 4,
                                      backgroundColor: colorAppBar,
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 12,
                                        bottom: 12,
                                      ),
                                      shape: const StadiumBorder(),
                                      side: BorderSide(
                                        width: 1,
                                        color: secondaryColor(
                                            !_isDark, colorAppBar),
                                      ),
                                    ),
                                    child: Text(
                                      _cityText,
                                      style: TextStyle(
                                          color: secondaryColor(
                                              !_isDark, colorAppBar),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'RebondGrotesque'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 4,
                                      backgroundColor: colorAppBar,
                                      padding: const EdgeInsets.all(11),
                                      shape: const CircleBorder(),
                                      side: BorderSide(
                                        width: 1,
                                        color: secondaryColor(
                                            !_isDark, colorAppBar),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      size: 30,
                                    ),
                                  ),
                                ),

                                //Continuer Button
                                Flexible(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _submitData(
                                        context,
                                        _postalAdress,
                                        _emailAdress,
                                        _website,
                                        _phoneNumber,
                                        _cityId,
                                        _isFrench,
                                        _subCatSelected,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 4,
                                      backgroundColor: colorAppBar,
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 15,
                                        bottom: 15,
                                      ),
                                      shape: const StadiumBorder(),
                                      side: BorderSide(
                                        width: 1,
                                        color: secondaryColor(
                                            !_isDark, colorAppBar),
                                      ),
                                    ),
                                    child: Text(
                                      _isFrench ? 'Valider' : 'Submit',
                                      style: TextStyle(
                                        color: Palette.secondary,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'RebondGrotesque',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: SizedBox(height: height * 0.1),
              ),
              //Return and Validate Button
              //Return Button
            ],
          ),
        ),
      ),
    );
  }
}
