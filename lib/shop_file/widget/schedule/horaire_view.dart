import 'package:flutter/material.dart';
import '../../../research_file/Model/horaire.dart';
import 'package:cuzou_app/main.dart';

import 'horaire_item_block.dart';

// ignore: must_be_immutable
class HoraireView extends StatelessWidget {
  bool isFrench;
  bool isModifiable;
  bool isDark;
  Color color;
  List<bool> dayClickedList;
  Map<Jour, List<Heure>> horaire;
  Function(int heure, int minute, bool ouverture, int dayIndex)
      submitHourChosen;
  Function(bool isClicked, int dayIndex) submitDayPresence;

  HoraireView({
    Key key,
    this.isFrench,
    this.isDark,
    this.isModifiable,
    this.color,
    this.dayClickedList,
    this.horaire,
    this.submitHourChosen,
    this.submitDayPresence,
  }) : super(key: key);

  List<Jour> listDays = [
    Jour.Lundi,
    Jour.Mardi,
    Jour.Mercredi,
    Jour.Jeudi,
    Jour.Vendredi,
    Jour.Samedi,
    Jour.Dimanche,
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor(isDark),
        borderRadius: BorderRadius.circular(5),
      ),

      //margin: EdgeInsets.all(20),

      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                HoraireItem(
                  titre: isFrench ? 'Horaire' : 'Schedule',
                  isTextButton: false,
                  isClicked: dayClickedList[0],
                  ouverture: null,
                  dayIndex: 0,
                  width: width,
                  height: height,
                  submitHourChosen: submitHourChosen,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
                HoraireItem(
                  titre: isFrench ? 'Lundi' : 'Monday',
                  isTextButton: true,
                  isClicked: dayClickedList[1],
                  dayIndex: 1,
                  width: width,
                  height: height,
                  submitDayPresence: submitDayPresence,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
                HoraireItem(
                  titre: isFrench ? 'Mardi' : 'Tuesday',
                  isTextButton: true,
                  isClicked: dayClickedList[2],
                  dayIndex: 2,
                  width: width,
                  height: height,
                  submitDayPresence: submitDayPresence,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
                HoraireItem(
                  titre: isFrench ? 'Mercredi' : 'Wednesday',
                  isTextButton: true,
                  isClicked: dayClickedList[3],
                  dayIndex: 3,
                  width: width,
                  height: height,
                  submitDayPresence: submitDayPresence,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
                HoraireItem(
                  titre: isFrench ? 'Jeudi' : 'Thursday',
                  isTextButton: true,
                  isClicked: dayClickedList[4],
                  dayIndex: 4,
                  width: width,
                  height: height,
                  submitDayPresence: submitDayPresence,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
                HoraireItem(
                  titre: isFrench ? 'Vendredi' : 'Friday',
                  isTextButton: true,
                  isClicked: dayClickedList[5],
                  dayIndex: 5,
                  width: width,
                  height: height,
                  submitDayPresence: submitDayPresence,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
                HoraireItem(
                  titre: isFrench ? 'Samedi' : 'Saturday',
                  isTextButton: true,
                  isClicked: dayClickedList[6],
                  dayIndex: 6,
                  width: width,
                  height: height,
                  submitDayPresence: submitDayPresence,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
                HoraireItem(
                  titre: isFrench ? 'Dimanche' : 'Sunday',
                  isTextButton: true,
                  isClicked: dayClickedList[7],
                  dayIndex: 7,
                  width: width,
                  height: height,
                  submitDayPresence: submitDayPresence,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
              ],
            ),
            Column(
              children: [
                HoraireItem(
                  titre: isFrench ? 'Ouverture' : 'Openning',
                  isTextButton: true,
                  isClicked: dayClickedList[0],
                  dayIndex: 0,
                  width: width,
                  height: height,
                  submitDayPresence: submitDayPresence,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
                SizedBox(
                  height: (height * 0.05 + 5) * 7,
                  width: width * 0.26 + 10,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (ctx, index) {
                      return HoraireItem(
                        titre: horaire[listDays[index]][0].getStringHeure,
                        isTextButton: false,
                        isClicked: dayClickedList[index + 1],
                        ouverture: true,
                        dayIndex: index + 1,
                        width: width,
                        height: height,
                        submitHourChosen: submitHourChosen,
                        isEnable: isModifiable,
                        color: color,
                        isDark: isDark,
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                HoraireItem(
                  titre: isFrench ? 'Fermeture' : 'Closing',
                  isTextButton: true,
                  isClicked: dayClickedList[0],
                  dayIndex: 0,
                  width: width,
                  height: height,
                  submitDayPresence: submitDayPresence,
                  isEnable: isModifiable,
                  color: color,
                  isDark: isDark,
                ),
                SizedBox(
                  height: (height * 0.05 + 5) * 7,
                  width: width * 0.26 + 10,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (ctx, index) {
                      return HoraireItem(
                        titre: horaire[listDays[index]][1].getStringHeure,
                        isTextButton: false,
                        isClicked: dayClickedList[index + 1],
                        ouverture: false,
                        dayIndex: index + 1,
                        width: width,
                        height: height,
                        submitHourChosen: submitHourChosen,
                        isEnable: isModifiable,
                        color: color,
                        isDark: isDark,
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),

      //child : Image.asset('images/logos/logo_restaurant.png', fit: BoxFit.cover),
    );
  }
}
