// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cuzou_app/authentication_file/widget/cityDialog.dart';
import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';

class ModifyInfoAccount extends StatefulWidget {
  static const routeName = "/modify-info-account";

  const ModifyInfoAccount({
    Key key,
  }) : super(key: key);

  @override
  State<ModifyInfoAccount> createState() => ModifyInfoAccountState();
}

class ModifyInfoAccountState extends State<ModifyInfoAccount> {
  final _formKey = GlobalKey<FormState>();

  Color colorAppBar;
  bool isDark;
  bool isFrench;

  QueryDocumentSnapshot userData;

  String firstName;
  String lastName;
  int cityId;
  int phoneNumber;

  String cityText;

  bool isInit;

  int pageSize = 8;
  double fontSizeTitle = 26;

  @override
  void initState() {
    super.initState();
    isInit = true;
  }

  void _submitCity(int citySelected, String cityName) {
    setState(() {
      cityId = citySelected;
      cityText = cityName;
    });
  }

  void _submitData(
    BuildContext context,
    String lastName,
    String firstName,
    int phoneNumber,
    int cityId,
  ) async {
    _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();

    try {
      User auth = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.uid)
          .update({
        'lastname': lastName.trim(),
        'firstname': firstName.trim(),
        'phoneNumber': phoneNumber,
        'cityId': cityId,
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    if (isInit) {
      userData = routeArgs['userData'];
      isDark = routeArgs['isDark'];
      isFrench = routeArgs['isFrench'];
      colorAppBar = routeArgs['colorAppBar'];

      firstName = userData['firstname'];
      lastName = userData['lastname'];
      cityId = userData['cityId'];
      cityText = getCityName(cityList[cityId]);
      phoneNumber = userData['phoneNumber'];

      isInit = false;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryColor(isDark),
      appBar: AppBar(
        backgroundColor: shadeColor(colorAppBar, 0.1),
        title: Text(isFrench ? 'Mon Profil' : 'My Profile'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: height * 0.1,
              ),
              child: Text(
                isFrench
                    ? 'Modification\ndes informations\npersonnelles'
                    : 'Personal\ninformations\nmodification',
                style: TextStyle(
                  color: secondaryColor(!isDark, colorAppBar),
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RebondGrotesque',
                ),
                textAlign: TextAlign.center,
              ),
            ), //Flexible(
            SizedBox(height: height * 0.1),
            Container(
              padding: EdgeInsets.only(
                  left: width * 0.1, right: width * 0.1, bottom: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      keyboardAppearance:
                          isDark ? Brightness.dark : Brightness.light,
                      key: const ValueKey('lastname'),
                      validator: (value) {
                        if (value.isEmpty) {
                          if (isFrench) {
                            return 'Entrez un nom valide s\'il vous plait !';
                          } else {
                            return 'Please, enter a valid lastname !';
                          }
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: secondaryColor(!isDark, Palette.blue),
                              width: 3.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: secondaryColor(!isDark, Palette.blue),
                              width: 1.0),
                        ),
                        hintText: isFrench ? 'Nom' : 'Name',
                        hintStyle: TextStyle(
                          color: tintColor(Palette.black, 0.1),
                          fontFamily: 'RebondGrotesque',
                        ),
                      ),
                      initialValue: lastName,
                      onSaved: (value) {
                        lastName = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardAppearance:
                          isDark ? Brightness.dark : Brightness.light,
                      key: const ValueKey('firstname'),
                      validator: (value) {
                        if (value.isEmpty) {
                          if (isFrench) {
                            return 'Entrez un prénom valide s\'il vous plait !';
                          } else {
                            return 'Please, enter a valid firstname !';
                          }
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: secondaryColor(!isDark, Palette.blue),
                              width: 3.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: secondaryColor(!isDark, Palette.blue),
                              width: 1.0),
                        ),
                        hintText: isFrench ? 'Prénom' : 'Firstname',
                        hintStyle: TextStyle(
                          color: tintColor(Palette.black, 0.1),
                          fontFamily: 'RebondGrotesque',
                        ),
                      ),
                      initialValue: firstName,
                      onSaved: (value) {
                        firstName = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardAppearance:
                          isDark ? Brightness.dark : Brightness.light,
                      key: const ValueKey('phonenumber'),
                      validator: (value) {
                        if ((value.isEmpty) && (value.length != 10)) {
                          if (isFrench) {
                            return 'Entrez un numéro valide s\'il vous plait !';
                          } else {
                            return 'Please, enter a valid phone number !';
                          }
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: secondaryColor(!isDark, Palette.blue),
                              width: 3.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: secondaryColor(!isDark, Palette.blue),
                              width: 1.0),
                        ),
                        hintText:
                            isFrench ? 'Numéro de téléphone' : 'Phone Number',
                        hintStyle: TextStyle(
                          color: tintColor(Palette.black, 0.1),
                          fontFamily: 'RebondGrotesque',
                        ),
                      ),
                      initialValue:
                          isFrench ? '0$phoneNumber' : phoneNumber.toString(),
                      onSaved: (value) {
                        phoneNumber = int.parse(value);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //City Picking Button
                    SizedBox(
                      width: width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => SimpleDialogCity(
                              width: width,
                              height: height,
                              submitCity: _submitCity,
                              isFrench: isFrench,
                              color: colorAppBar,
                              cityId: cityId,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor(isDark),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 15,
                          ),
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            width: 1,
                            color: secondaryColor(!isDark, colorAppBar),
                          ),
                        ),
                        child: Text(
                          cityText,
                          style: TextStyle(
                            color: secondaryColor(!isDark, colorAppBar),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RebondGrotesque',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Continuer Button
                        ElevatedButton(
                          onPressed: () {
                            _submitData(
                              context,
                              lastName,
                              firstName,
                              phoneNumber,
                              cityId,
                            );
                            Navigator.of(context).pop();
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
                              color: secondaryColor(!isDark, colorAppBar),
                            ),
                          ),
                          child: Text(
                            isFrench ? 'Valider' : 'Submit',
                            style: TextStyle(
                              color: Palette.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RebondGrotesque',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //Return and Validate Button
            //Return Button
          ],
        ),
      ),
    );
  }
}
