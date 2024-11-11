// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cuzou_app/research_file/Model/horaire.dart';
import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuzou_app/authentication_file/Data/user_data.dart';
import 'package:cuzou_app/shop_file/widget/schedule/horaire_view.dart';

class ShopCreationFormFour extends StatefulWidget {
  final bool isLoading;
  final bool isFrench;
  final bool isDark;
  final Color color;
  final bool isModifiable;
  final void Function(Map<Jour, List<Heure>> horaire, int shopId) savePageFour;

  final void Function(int index) setPage;

  const ShopCreationFormFour(this.isLoading, this.isDark, this.isFrench,
      this.isModifiable, this.color, this.savePageFour, this.setPage,
      {Key key})
      : super(key: key);
  @override
  ShopCreationFormFourState createState() => ShopCreationFormFourState();
}

class ShopCreationFormFourState extends State<ShopCreationFormFour> {
  int shopId;
  bool isInit = true;
  Color color = Palette.blue;
  Map<Jour, List<Heure>> horaire = horaireExample.getHoraires();

  void _trySubmit() {
    FocusScope.of(context).unfocus();

    //Creer collection des horaires
    widget.savePageFour(horaire, shopId);
    widget.setPage(3);
  }

  void submitHourChosen(int heure, int minute, bool ouverture, int dayIndex) {
    int openIndex;
    if (ouverture) {
      openIndex = 0;
    } else {
      openIndex = 1;
    }

    setState(() {
      horaire[jourNum(dayIndex)][openIndex] = Heure(heure, minute);
    });
  }

  void submitDayPresence(bool isClicked, int dayIndex) {
    if ((dayIndex != 0)) {
      setState(() {
        dayClickedList[dayIndex] = isClicked;
      });
    }
  }

  List<bool> dayClickedList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    //Refaire de manière moins redondante
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('shops').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> shopSnapshot) {
          if (shopSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<QueryDocumentSnapshot> shopsDocs = shopSnapshot.data.docs;

          if (isInit) {
            shopId = generatePrimaryKeyFromShop(shopsDocs);
            isInit = false;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HoraireView(
                color: color,
                isFrench: widget.isFrench,
                isDark: widget.isDark,
                isModifiable: true,
                dayClickedList: dayClickedList,
                horaire: horaire,
                submitHourChosen: submitHourChosen,
                submitDayPresence: submitDayPresence,
              ),
              const SizedBox(
                height: 20,
              ),
              if (widget.isLoading)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Return Button
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.setPage(1);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Palette.orange,
                          padding: const EdgeInsets.all(11),
                          shape: const CircleBorder(),
                          side: BorderSide(
                            width: 1,
                            color:
                                secondaryColor(!widget.isDark, Palette.orange),
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
                          _trySubmit();
                          //widget.setPage(3);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Palette.orange,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 15,
                          ),
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            width: 1,
                            color:
                                secondaryColor(!widget.isDark, Palette.orange),
                          ),
                        ),
                        child: Text(
                          widget.isFrench
                              ? '      Continuer      '
                              : '      Continue      ',
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle_outlined,
                    size: 10,
                    color: Palette.orange,
                  ),
                  Icon(Icons.circle_outlined, size: 10, color: Palette.orange),
                  Icon(Icons.circle, size: 15, color: Palette.orange),
                  Icon(Icons.circle_outlined, size: 10, color: Palette.orange),
                ],
              ),
            ],
          );
        });
  }
}
