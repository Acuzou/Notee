import 'package:flutter/material.dart';

import '../../main.dart';
import '../../main_switch.dart';

class AboutUsScreen extends StatelessWidget {
  static String routeName = 'aboutUs-route';

  const AboutUsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final Color colorAppBar = routeArgs['colorAppBar'] as Color;
    final bool isDark = routeArgs['isDark'] as bool;
    final bool isFrench = routeArgs['isFrench'] as bool;

    const double radius = 40;
    const double fontSizeText = 17;
    final String pText1 =
        isFrench ? 'Qu\'est-ce donc Notee ?' : "What is Notee?";
    final String pText2 = isFrench
        ? '- Une application qui garantit une relation commerciale bienveillante et fructueuse. \n- Un outil de dialogue direct entre clients et commerçants !'
        : '- An application that guarantees a friendly and prosperous business relationship! \n- A chat tool for direct dialogue between customers and merchants.';
    final String pText3 = isFrench
        ? 'Notee a pour objectif de fédérer les commerçants et tous les acteurs du secteur de l\'artisanat, la restauration, de l\'hôtellerie ; et de propulser leur e-reputation, tout en fidélisant de manière plus humaine, leur clientèle.'
        : 'Notee aims to unite retailers, artisans, restaurants & hotels; in order to boost their e-reputation, while building back their customer loyalty in a more human way.';
    final String pText4 = isFrench
        ? 'En décembre 2021, après étude du marché, de faisabilité du projet et analyse comparative des plateformes concurrentes existantes, le projet a été validé par son fondateur, Jonathan Flores et initié par l\'équipe du Studio Rosa. Pour la rentrée 2022, nous prévoyons une première implantation de l\'application Notee, auprès des commerçants, restaurants et hôtels de la ville de Nantes, propose une première période d’essai gratuite auprès des commerçants que nous aurons sollicités.'
        : 'In December 2021, after conducting a market study of the project and a comparative analysis of existing competing platforms, Notee was endorsed by its founder, Jonathan Flores and initiated by the team of Studio Rosa. In september 2022, we are planning a first implementation of the Notee app, among the shopkeepers, restaurants and hotels of the city of Nantes, offering a first free trial period among the retailers we will have solicited.';

    final String pText5 = isFrench
        ? 'Pour plus d\'informations, contactez-nous : \nhello@notee.world'
        : 'For more information, please contact us : \nhello@notee.world';

    final String pText6 = isFrench
        ? 'Merci pour votre soutien! \nL’équipe Notee '
        : 'Thank you for your support! \nThe Notee team ';

    final String pText7 = isFrench
        ? '© Notee 2022. Création par Jonathan Flores, et Studio Rosa :'
        : '© Notee 2022. Design by Jonathan Flores, and Studio Rosa Team :';

    final String pText8 = isFrench
        ? 'Jonathan Flores,\nfondateur du projet'
        : 'Jonathan Flores,\nproject founder';
    final String pText9 = isFrench
        ? 'Cynthia Cuzou,\ndirectrice de projet'
        : 'Cynthia Cuzou,\nproject manager';
    final String pText10 = isFrench
        ? 'Alexandre Cuzou,\ndéveloppeur IOS/Android'
        : 'Alexandre Cuzou,\nIOS/Android developer';
    final String pText11 = isFrench
        ? 'Maël Haurogné,\ndirecteur artistique '
        : 'Maël Haurogné,\nart director';

    return Scaffold(
      //backgroundColor: shadeColor(Palette.primary, 0.4),
      backgroundColor: primaryColor(isDark),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: shadeColor(colorAppBar, 0.1),
        title: Text(isFrench ? 'A propos' : 'About Us'),
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
      body: ListView(
        children: [
          //Jonathan

          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              pText1,
              style: TextStyle(
                color: primaryColor(!isDark),
                fontFamily: 'RebondGrotesque',
                fontSize: fontSizeText + 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Text(
              pText2,
              style: TextStyle(
                color: primaryColor(!isDark),
                fontFamily: 'RebondGrotesque',
                fontSize: fontSizeText,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              pText3,
              style: TextStyle(
                color: primaryColor(!isDark),
                fontFamily: 'RebondGrotesque',
                fontSize: fontSizeText,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              pText4,
              style: TextStyle(
                color: primaryColor(!isDark),
                fontFamily: 'RebondGrotesque',
                fontSize: fontSizeText,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              pText5,
              style: TextStyle(
                color: primaryColor(!isDark),
                fontFamily: 'RebondGrotesque',
                fontSize: fontSizeText,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              pText6,
              style: TextStyle(
                color: primaryColor(!isDark),
                fontFamily: 'RebondGrotesque',
                fontSize: 20,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              pText7,
              style: TextStyle(
                color: primaryColor(!isDark),
                fontFamily: 'RebondGrotesque',
                fontSize: fontSizeText,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: CircleAvatar(
                    radius: radius + 2,
                    backgroundColor: primaryColor(!isDark),
                    child: CircleAvatar(
                      radius: radius,
                      backgroundColor: primaryColor(!isDark),
                      backgroundImage: const AssetImage(
                          "assets/images/notee_team/Jonathan.jpg"),
                    ),
                  ),
                ),
                Text(
                  pText8,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: primaryColor(!isDark),
                      fontSize: fontSizeText + 5,
                      fontFamily: 'RebondGrotesque'),
                ),
              ],
            ),
          ),

          //Alexandre
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  pText9,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: primaryColor(!isDark),
                      fontSize: fontSizeText + 5,
                      fontFamily: 'RebondGrotesque'),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: CircleAvatar(
                    radius: radius + 2,
                    backgroundColor: primaryColor(!isDark),
                    child: CircleAvatar(
                      radius: radius,
                      backgroundColor: primaryColor(!isDark),
                      backgroundImage: const AssetImage(
                          "assets/images/notee_team/cynthia.jpg"),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Cynthia
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: CircleAvatar(
                    radius: radius + 2,
                    backgroundColor: primaryColor(!isDark),
                    child: CircleAvatar(
                      radius: radius,
                      backgroundColor: primaryColor(!isDark),
                      backgroundImage: const AssetImage(
                          "assets/images/notee_team/alexandre.jpeg"),
                    ),
                  ),
                ),
                Text(
                  pText10,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: primaryColor(!isDark),
                      fontSize: fontSizeText + 5,
                      fontFamily: 'RebondGrotesque'),
                ),
              ],
            ),
          ),

          //Mael
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  pText11,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: primaryColor(!isDark),
                      fontSize: fontSizeText + 5,
                      fontFamily: 'RebondGrotesque'),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: CircleAvatar(
                    radius: radius + 2,
                    backgroundColor: primaryColor(!isDark),
                    child: CircleAvatar(
                      radius: radius,
                      backgroundColor: primaryColor(!isDark),
                      backgroundImage:
                          const AssetImage("assets/images/notee_team/mael.jpg"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
