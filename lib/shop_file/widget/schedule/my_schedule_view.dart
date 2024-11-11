import 'package:cuzou_app/shop_file/widget/schedule/horaire_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../research_file/Model/horaire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuzou_app/research_file/Data/data_function.dart';

class MyScheduleView extends StatefulWidget {
  final bool isModifiable;
  final Color color;
  final bool isFrench;
  final bool isDark;

  const MyScheduleView({
    Key key,
    this.isModifiable,
    this.color,
    this.isFrench,
    this.isDark,
  }) : super(key: key);

  @override
  MyScheduleViewState createState() => MyScheduleViewState();
}

class MyScheduleViewState extends State<MyScheduleView> {
  //Faire en sort que les données soit null quand les jours sont nulls
  static const double horaireSize = 20;
  static const double jourSize = 20;

  Map<Jour, List<Heure>> horaire;

  void submitHourChosen(
      int heure, int minute, bool ouverture, int dayIndex) async {
    int openIndex;
    if (ouverture) {
      openIndex = 0;
    } else {
      openIndex = 1;
    }

    try {
      User auth = FirebaseAuth.instance.currentUser;

      String textField = getFieldFromIndex(dayIndex, openIndex);

      await FirebaseFirestore.instance
          .collection('shops')
          .doc(auth.uid)
          .collection('horaire')
          .doc(auth.uid)
          .update({
        //horaire[jourNum(dayIndex)][openIndex] = Heure(heure, minute);
        textField: Heure(heure, minute).getStringHeure,
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

    // setState(() {
    //   print(openIndex);
    //   horaire[jourNum(dayIndex)][openIndex] = Heure(heure, minute);

    // });
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
    var auth = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('shops')
            .doc(auth.uid)
            .collection('horaire')
            .snapshots(),
        builder: (context, horaireSnapshot) {
          if (horaireSnapshot.hasError) {
            const Text('Something went wrong.');
          }
          if (horaireSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // final test = horaireSnapshot.requireData.docs[0];
          // print(test['mondayOp']);
          horaire = getHoraire(horaireSnapshot, true);

          return HoraireView(
            isFrench: widget.isFrench,
            isDark: widget.isDark,
            isModifiable: widget.isModifiable,
            color: widget.color,
            dayClickedList: dayClickedList,
            horaire: horaire,
            submitHourChosen: submitHourChosen,
            submitDayPresence: submitDayPresence,
          );
        });
  }
}
