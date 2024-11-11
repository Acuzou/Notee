// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// ignore: import_of_legacy_library_into_null_safe
import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/general_widget/data_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/menu_file/widget/menu_item.dart';
import 'package:flutter/material.dart';
//import 'package:lite_rolling_switch/lite_rolling_switch.dart';

// ignore: must_be_immutable
class MenuScreen extends StatelessWidget {
  static String routeName = '/Menu-Screen';

  MenuScreen({Key key}) : super(key: key);

  int shopId;
  int myId;
  String _firstName;
  String _lastName;
  String _profilPictureUrl;

  bool isDark;
  bool isFrench;
  Color colorAppBar;

  double radius;

  Future<NetworkImage> getImage(String profilPictureUrl) async {
    return NetworkImage(profilPictureUrl);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double height = size.height;
    radius = height * 0.1;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    //Pour conserver la couleur de l'appBar précédente
    colorAppBar = routeArgs['colorAppBar'] as Color;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            Text('Something went wrong.');
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          User auth = FirebaseAuth.instance.currentUser;
          final List<QueryDocumentSnapshot> usersDocs = userSnapshot.data.docs;

          var userData =
              usersDocs.firstWhere((user) => user['email'] == auth.email);

          shopId = userData['shopId'];
          myId = userData['ID'];
          _firstName = userData['firstname'];
          _lastName = userData['lastname'];
          _profilPictureUrl = userData['profilPictureUrl'];
          isDark = userData['isDark'];
          isFrench = userData['isFrench'];

          return Scaffold(
            backgroundColor: primaryColor(isDark),
            extendBody: true,
            appBar: AppBar(
              // title: Center(
              //   child: Text(titlePage[indexPage]),
              // ),
              title: Text("Menu"),

              backgroundColor: shadeColor(colorAppBar, 0.1),

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.06),

                  // CircleAvatar(
                  //   radius: 80,
                  //   backgroundColor: secondaryColor(!isDark, colorAppBar),
                  //   child:
                  SizedBox(
                    height: radius * 2 + 6,
                    width: radius * 2 + 6,
                    child: SizedBox(
                      child: FutureBuilder(
                          future: getImage(_profilPictureUrl),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              //if (snapshot.hasData) {
                              return drawerHeader(radius, isDark, false,
                                  colorAppBar, snapshot.data);
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  // DrawerHeader(
                  //   child: CircleAvatar(
                  //     //backgroundImage: NetworkImage(''),
                  //     backgroundColor: primaryColor(isDark),
                  //     backgroundImage: NetworkImage(_profilPictureUrl),
                  //     maxRadius: 80,
                  //   ),
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_firstName $_lastName',
                        style: TextStyle(
                          color: secondaryColor(!isDark, colorAppBar),
                          fontSize: 22,
                          fontFamily: 'RebondGrotesque',
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.04),

                  //Profile Page
                  //Faire en sorte quand on clique dessus le fond du padding devient plus foncé

                  MenuItemNotee(
                    icon: Icons.person,
                    title: isFrench ? 'Mon Profil' : 'My Profile',
                    itemId: 0,
                    myId: myId,
                    shopId: shopId,
                    isDark: isDark,
                    colorAppBar: colorAppBar,
                    isFrench: isFrench,
                  ),

                  //MonMagasin Page

                  MenuItemNotee(
                    icon: Icons.home,
                    title: isFrench ? 'Mon Magasin' : 'My Store',
                    itemId: 1,
                    myId: myId,
                    shopId: shopId,
                    isDark: isDark,
                    colorAppBar: colorAppBar,
                    isFrench: isFrench,
                  ),

                  //Favoris Page

                  MenuItemNotee(
                    icon: Icons.star,
                    title: isFrench ? 'Mes Favoris' : 'My Favorites',
                    itemId: 2,
                    myId: myId,
                    shopId: shopId,
                    isDark: isDark,
                    colorAppBar: colorAppBar,
                    isFrench: isFrench,
                  ),

                  // MenuItemNotee(
                  //    icon: Icons.camera,
                  //    title: isFrench ? 'Mes QR Codes' : 'My QR Codes',
                  //    itemId: 4,
                  //    myId: myId,
                  //    shopId: shopId,
                  //    isDark: isDark,
                  //    colorAppBar: colorAppBar,
                  //    isFrench: isFrench,
                  //  ),

                  //Setting Page

                  MenuItemNotee(
                    icon: Icons.settings,
                    title: isFrench ? 'Paramètres' : 'Settings',
                    itemId: 3,
                    myId: 100,
                    shopId: 1,
                    isDark: isDark,
                    colorAppBar: colorAppBar,
                    isFrench: isFrench,
                  ),

                  //Logout
                  //Spacer(),
                  MenuItemNotee(
                    icon: Icons.exit_to_app,
                    title: isFrench ? 'Déconnexion' : 'Logout',
                    itemId: 4,
                    myId: 100,
                    shopId: 1,
                    isDark: isDark,
                    colorAppBar: colorAppBar,
                    isFrench: isFrench,
                  ),
                  //SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
  }
}
