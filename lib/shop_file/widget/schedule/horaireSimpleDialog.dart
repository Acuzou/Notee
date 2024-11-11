// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';
import 'package:cuzou_app/research_file/Model/horaire.dart';
import 'package:cuzou_app/shop_file/widget/schedule/time_entered.dart';

// ignore: must_be_immutable
class HoraireSimpleDialog extends StatefulWidget {
  int dayIndex;
  bool ouverture;
  String titre;
  double width;
  double height;
  Function(int heure, int minute, bool ouverture, int dayIndex)
      submitHourChosen;

  HoraireSimpleDialog(this.dayIndex, this.ouverture, this.titre, this.width,
      this.height, this.submitHourChosen,
      {Key key})
      : super(key: key);

  @override
  State<HoraireSimpleDialog> createState() => _HoraireSimpleDialogState();
}

class _HoraireSimpleDialogState extends State<HoraireSimpleDialog> {
  Map<Jour, List<Heure>> horaire = horaireExample.getHoraires();

  int heure;
  int minute;

  @override
  void initState() {
    Heure heurePrec = getHeureFromString(widget.titre);
    heure = heurePrec.getHeure;
    minute = heurePrec.getMinute;

    // heure = horaire[jourNum(widget.dayIndex)][openIndex].getHeure;
    // minute = horaire[jourNum(widget.dayIndex)][openIndex].getMinute;
    super.initState();
  }

  void selectHour(int heureSelected) {
    setState(() {
      heure = heureSelected;
    });
  }

  void selectMinute(int minuteSelected) {
    setState(() {
      minute = minuteSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: [
          Text(
            'Sélectionner une heure pour',
            style: TextStyle(
              color: Palette.orange,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            widget.ouverture
                ? 'l\'ouverture de ${textJour(jourNum(widget.dayIndex))}'
                : 'la fermeture de ${textJour(jourNum(widget.dayIndex))}',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  color: Colors.black,
                  height: widget.height * 0.21,
                  width: widget.width * 0.20,
                  // child: ListView.builder(
                  //   itemBuilder: (ctx, index) {
                  //     if (index == 0) {
                  //       return TimeEntered(null, heure, selectHour);
                  //     }

                  //     if (index == 25) {
                  //       return TimeEntered(null, heure, selectHour);
                  //     }
                  //     return TimeEntered(index - 1, heure, selectHour);
                  //   },
                  //   itemCount: 26,
                  // ),
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: widget.height * 0.08,
                    diameterRatio: 2,
                    physics: const FixedExtentScrollPhysics(),
                    useMagnifier: true,
                    magnification: 1.5,
                    squeeze: 1,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        heure = index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 24,
                      builder: (context, index) {
                        return TimeEntered(index, heure, selectHour);
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      ':',
                      style: TextStyle(
                        color: Palette.orange,
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: widget.height * 0.04,
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  color: Colors.black,
                  height: widget.height * 0.21,
                  width: widget.width * 0.2,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: widget.height * 0.08,
                    diameterRatio: 2,
                    physics: const FixedExtentScrollPhysics(),
                    useMagnifier: true,
                    magnification: 1.5,
                    squeeze: 1,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        minute = index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (context, index) {
                        return TimeEntered(index, heure, selectHour);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
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
                    widget.submitHourChosen(
                        heure, minute, widget.ouverture, widget.dayIndex);

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
  }
}
