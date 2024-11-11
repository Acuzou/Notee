import 'package:cuzou_app/shop_file/widget/schedule/horaireSimpleDialog.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';

// ignore: must_be_immutable
class HoraireItem extends StatelessWidget {
  String titre;
  bool isTextButton;
  bool isClicked;
  bool ouverture;
  int dayIndex;
  double width;
  double height;
  Function(bool isClicked, int dayIndex) submitDayPresence;
  Function(int heure, int minute, bool ouverture, int dayIndex)
      submitHourChosen;
  Color color;
  bool isEnable;
  bool isDark;

  HoraireItem({
    Key key,
    this.titre,
    this.isTextButton,
    this.isClicked,
    this.ouverture,
    this.dayIndex,
    this.width,
    this.height,
    this.submitDayPresence,
    this.submitHourChosen,
    this.isEnable,
    this.color,
    this.isDark,
  }) : super(key: key);

  void submitDefaultHour(context) {
    int heureOp = 8;
    int heureCl = 19;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Column(
              children: [
                Text(
                  'Voulez-vous reprendre les horaires par défault ?',
                  style: TextStyle(
                    color: Palette.orange,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(20),
            backgroundColor: tintColor(Palette.black, 0.01),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Ouverture : ${heureOp}h00',
                    style: TextStyle(
                      color: Palette.orange,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Fermeture : ${heureCl}h00',
                    style: TextStyle(
                      color: Palette.orange,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  //End Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Close button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Retour',
                          style: TextStyle(
                            color: Palette.orange,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      //Validate Button
                      ElevatedButton(
                        onPressed: () {
                          //submitHourChosen(heure, minute, ouverture, dayIndex);
                          for (int i = 1; i < 8; i++) {
                            submitHourChosen(heureOp, 0, true, i);
                            submitHourChosen(heureCl, 0, false, i);
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: shadeColor(Palette.orange, 0.3),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 15,
                          ),
                        ),
                        child: Text(
                          "Valider",
                          style: TextStyle(
                            color: Palette.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          );
        });
  }

  void hourChoiceDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return HoraireSimpleDialog(
              dayIndex, ouverture, titre, width, height, submitHourChosen);
        });
  }

  @override
  Widget build(BuildContext context) {
    return isTextButton
        ? Container(
            width: width * 0.26,
            height: height * 0.05,
            margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextButton(
                onPressed: () {
                  if (isEnable) {
                    submitDayPresence(!isClicked, dayIndex);
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  side: BorderSide(
                    width: 1,
                    color: isDark ? color : Palette.black,
                  ),
                ),
                child: Text(
                  isClicked ? '' : titre,
                  style: TextStyle(
                      color: Palette.black,
                      fontSize: 18,
                      fontFamily: 'RebondGrotesque'),
                )),
          )
        : Container(
            width: width * 0.26,
            height: height * 0.05,
            margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
            decoration: BoxDecoration(
              //color: primaryColor(isDark),

              borderRadius: BorderRadius.circular(15),
            ),
            child: ElevatedButton(
                onPressed: () {
                  if (isEnable) {
                    if (dayIndex != 0) {
                      if (!isClicked) {
                        hourChoiceDialog(context);
                      }
                    } else {
                      submitDefaultHour(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: primaryColor(isDark),
                  side: BorderSide(
                    width: 1,
                    color: isDark ? color : Palette.black,
                  ),
                ),
                child: Text(
                  isClicked ? '' : titre,
                  style: TextStyle(
                    color: primaryColor(!isDark),
                    fontSize: 18,
                    fontFamily: 'RebondGrotesque',
                  ),
                )),
          );
  }
}
