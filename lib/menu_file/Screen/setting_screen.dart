//import 'dart:html';
import 'package:cuzou_app/authentication_file/Screen/authentification_screen.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/menu_file/Screen/aboutus.dart';
import 'package:cuzou_app/menu_file/Screen/change_password.dart';
import 'package:cuzou_app/menu_file/widget/setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cuzou_app/message_file/Screen/messages_screen.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/my_setting';

  const SettingScreen({Key key}) : super(key: key);

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool isHovering = false;
  final colorBar = Colors.white24;
  final color = Palette.primary;
  bool isChangingPassword = false;

  bool isInit = true;
  double height;
  double width;
  Color colorAppBar;

  void _saveSetting(
    bool isDark,
    bool isNotificationOn,
    bool isFrench,
    BuildContext ctx,
  ) async {
    try {
      User authResult = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.uid)
          .update({
        'isDark': isDark,
        'isNotificationOn': isNotificationOn,
        'isFrench': isFrench,
      });
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
    }
  }

  void setPage(int index) {
    if (index == 1) {
      setState(() {
        isChangingPassword = true;
      });
    } else {
      setState(() {
        isChangingPassword = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isInit) {
      Size size = MediaQuery.of(context).size;
      height = size.height;
      width = size.width;

      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      colorAppBar = routeArgs['colorAppBar'] as Color;
      isInit = false;
    }

    return StreamBuilder(
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
          User auth = FirebaseAuth.instance.currentUser;
          final users = userSnapshot.requireData.docs;

          final user =
              users.firstWhere((user) => user.data()['email'] == auth.email);

          int myId = user.data()['ID'];
          bool isDark = user.data()['isDark'];
          bool isFrench = user.data()['isFrench'];
          bool isNotificationOn = user.data()['isNotificationOn'];

          return Scaffold(
            //backgroundColor: shadeColor(Palette.primary, 0.4),
            backgroundColor: primaryColor(isDark),
            extendBody: true,
            appBar: AppBar(
              backgroundColor: shadeColor(colorAppBar, 0.1),
              title: Text(isFrench ? 'Paramètres' : 'Settings'),
              actions: <Widget>[
                IconButton(
                  icon: const ImageIcon(
                    AssetImage("assets/images/logos/logo_notee/icon_noir.png"),
                    size: 120,
                  ),
                  tooltip: 'Home Page',
                  onPressed: () {
                    Navigator.of(context).restorablePushNamedAndRemoveUntil(
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
                child: SafeArea(
                  child: (isChangingPassword)
                      //? Test(_formKeySetting)
                      ? ChangePasswordPage(
                          colorAppBar,
                          isFrench,
                          isDark,
                          setPage,
                          width,
                        )
                      : Column(
                          children: <Widget>[
                            //Change authentification Button
                            SettingWidgets(
                              isDark: isDark,
                              isFrench: isFrench,
                              isNotificationOn: isNotificationOn,
                              saveSetting: _saveSetting,
                              colorAppBar: colorAppBar,
                            ),
                            Divider(
                                thickness: 2,
                                color: secondaryColor(!isDark, colorAppBar)),

                            SizedBox(
                              height: height * 0.02,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    //Change password Button
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 5),
                                      width: width * 0.43,
                                      height: height * 0.12,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setPage(1);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: secondaryColor(
                                                !isDark, colorAppBar),
                                            padding: const EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            side: BorderSide(
                                              width: 1,
                                              color: isDark
                                                  ? colorAppBar
                                                  : Palette.black,
                                            )),
                                        child: Text(
                                          isFrench
                                              ? 'Changer de\nmot de passe'
                                              : 'Change\npassword',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'RebondGrotesque',
                                            fontWeight: FontWeight.bold,
                                            color: secondaryColor(
                                                isDark, colorAppBar),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    //Abous Us Button
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 5),
                                      width: width * 0.43,
                                      height: height * 0.12,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              AboutUsScreen.routeName,
                                              arguments: {
                                                'colorAppBar': colorAppBar,
                                                'isDark': isDark,
                                                'isFrench': isFrench,
                                              });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: secondaryColor(
                                                isDark, colorAppBar),
                                            padding: const EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            side: BorderSide(
                                              width: 1,
                                              color: isDark
                                                  ? colorAppBar
                                                  : Palette.black,
                                            )),
                                        child: Text(
                                          isFrench
                                              ? 'À propos de nous'
                                              : 'About Us',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'RebondGrotesque',
                                            color: secondaryColor(
                                                !isDark, colorAppBar),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    //Help Button
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 5),
                                      width: width * 0.43,
                                      height: height * 0.12,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            MessageScreen.routeName,
                                            arguments: {
                                              'contactId': 0,
                                              'contactName': isFrench
                                                  ? 'Aide / Recommandation'
                                                  : 'Help / Recommendation',
                                              'photo': 'Default_Profile_Photo',
                                              'myId': myId,
                                              'isDark': isDark,
                                              'isFrench': isFrench,
                                              'isUserMerchant': false,
                                              'isContactMerchant': false,
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: secondaryColor(
                                                isDark, colorAppBar),
                                            padding: const EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            side: BorderSide(
                                              width: 1,
                                              color: isDark
                                                  ? colorAppBar
                                                  : Palette.black,
                                            )),
                                        child: Text(
                                          isFrench
                                              ? 'Aide\nRecommandation'
                                              : 'Help\nRecommendation',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'RebondGrotesque',
                                            fontWeight: FontWeight.bold,
                                            color: secondaryColor(
                                                !isDark, colorAppBar),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 5),
                                      width: width * 0.43,
                                      height: height * 0.12,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  AuthentificationScreen
                                                      .routeName,
                                                  (route) => false);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: secondaryColor(
                                                !isDark, colorAppBar),
                                            padding: const EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            side: BorderSide(
                                              width: 1,
                                              color: isDark
                                                  ? colorAppBar
                                                  : Palette.black,
                                            )),
                                        child: Text(
                                          isFrench ? 'Déconnexion' : 'Logout',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'RebondGrotesque',
                                            fontWeight: FontWeight.bold,
                                            color: secondaryColor(
                                                isDark, colorAppBar),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
        });
  }
}
