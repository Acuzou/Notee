import 'package:cuzou_app/menu_file/Screen/creationShop_screen.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';

// ignore: camel_case_types, must_be_immutable
class notMerchantCard extends StatelessWidget {
  bool isDark;
  bool isFrench;
  int shopId;
  int myId;
  Color colorAppBar;

  notMerchantCard(
      {Key key,
      this.shopId,
      this.myId,
      this.isDark,
      this.colorAppBar,
      this.isFrench})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    return Center(
      child: Card(
        color: primaryColor(isDark),
        margin: EdgeInsets.only(
            top: height * 0.2, left: 20, right: 20, bottom: height * 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isFrench
                    ? 'Vous n\'êtes pas commerçant !'
                    : 'You are not merchant !',
                style: TextStyle(
                  color: secondaryColor(!isDark, Palette.orange),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Text(
                isFrench
                    ? 'Souhaitez-vous ouvrir votre commerce ?'
                    : 'Do you want to open your shop ?',
                style: TextStyle(
                  color: secondaryColor(!isDark, Palette.orange),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Return button
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
                          color: secondaryColor(!isDark, colorAppBar),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          ShopCreationScreen.routeName,
                          arguments: {
                            'isDark': isDark,
                            'colorAppBar': colorAppBar,
                            'myId': myId,
                            'isFrench': isFrench,
                          },
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
                          color: secondaryColor(!isDark, colorAppBar),
                        ),
                      ),
                      child: Text(
                        isFrench ? '   S\'inscrire   ' : 'Register',
                        style: TextStyle(
                          color: Palette.black,
                          fontSize: 18,
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
    );
  }
}
