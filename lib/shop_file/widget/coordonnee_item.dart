import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import '../../research_file/Model/coordonnee.dart';
import '../../research_file/Model/shop.dart';
import '../../research_file/Data/general_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CoordonneeItem extends StatelessWidget {
  final Coordonnee coordonneeShop;
  final City city;
  final int subCatId;
  final Color color;
  final bool isFrench;
  final bool isOpen;
  final bool isDark;

  CoordonneeItem({
    Key key,
    this.coordonneeShop,
    this.city,
    this.color,
    this.isFrench,
    this.isDark,
    this.isOpen,
    this.subCatId,
  }) : super(key: key);

  void _openGoogleMaps(BuildContext ctx, String searchQuery) async {
    String message = isFrench
        ? 'Erreur : Impossible d\'ouvrir Google Maps'
        : 'Error : Impossible to launch Google Maps';

    final url =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(searchQuery)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Impossible d\'ouvrir Googles Maps ! $url');

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Palette.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _makePhoneCall(BuildContext ctx, String phoneNumber) async {
    String message = isFrench
        ? 'Erreur : Impossible de lancer l\'appel'
        : 'Error : Impossible to launch call';

    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Impossible de lancer l\'appel ! : $url');

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Palette.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendHttpRequest(BuildContext ctx, String url) async {
    String message = isFrench
        ? 'Erreur requête ! Ce lien https ne doit pas exister'
        : 'Request error ! This https link must not exist';

    try {
      final response = await http.get(Uri.parse(url));
      print('Statut de la reponse : ${response.statusCode}');
    } catch (e) {
      print('Erreur lors de la requête : $e');

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Palette.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.only(right: 20, left: 20),
      padding: const EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 15),
      width: double.infinity,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: secondaryColor(!isDark, color),
                    width: 1,
                    style: BorderStyle.solid),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.category,
                  color: secondaryColor(!isDark, color),
                  size: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  isFrench
                      ? frenchTextType(subCatList[subCatId])
                      : englishTextType(subCatList[subCatId]),
                  style: TextStyle(
                    color: secondaryColor(!isDark, color),
                    fontSize: 18,
                    fontFamily: 'RebondGrotesque',
                  ),
                  //softWrap: true,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5, top: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: secondaryColor(!isDark, color),
                    width: 1,
                    style: BorderStyle.solid),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: secondaryColor(!isDark, color),
                  size: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coordonneeShop.getGeographicAdress(),
                      style: TextStyle(
                        color: secondaryColor(!isDark, color),
                        fontSize: 18,
                        fontFamily: 'RebondGrotesque',
                      ),
                      //softWrap: true,
                    ),
                    Text(
                      getCityName(city),
                      //getCityPostalCodeText(city),
                      style: TextStyle(
                        color: secondaryColor(!isDark, color),
                        fontSize: 18,
                        fontFamily: 'RebondGrotesque',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              _makePhoneCall(context, coordonneeShop.getPhoneNumberText());
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: secondaryColor(!isDark, color),
                      width: 1,
                      style: BorderStyle.solid),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.phone_outlined,
                    color: secondaryColor(!isDark, color),
                    size: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    coordonneeShop.getPhoneNumberText(),
                    style: TextStyle(
                      color: secondaryColor(!isDark, color),
                      fontSize: 18,
                      fontFamily: 'RebondGrotesque',
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _sendHttpRequest(
                  context, "https://${coordonneeShop.getWebsite()}");
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: secondaryColor(!isDark, color),
                      width: 1,
                      style: BorderStyle.solid),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.web,
                    color: secondaryColor(!isDark, color),
                    size: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    coordonneeShop.getWebsite(),
                    style: TextStyle(
                      color: secondaryColor(!isDark, color),
                      fontSize: 18,
                      fontFamily: 'RebondGrotesque',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.only(bottom: 5, top: 5),
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     border: Border(
          //       bottom: BorderSide(
          //           color: secondaryColor(!isDark, Palette.blue),
          //           width: 3,
          //           style: BorderStyle.solid),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Icon(
          //         Icons.web,
          //         color: secondaryColor(!isDark, Palette.blue),
          //         size: 40,
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       Text(
          //         'www.hotel2luxxe.fr',
          //         style: TextStyle(
          //           color: secondaryColor(!isDark, Palette.blue),
          //           fontSize: 18,
          //           fontFamily: 'RebondGrotesque',
          //           //decoration: TextDecoration.underline,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
