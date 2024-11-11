import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/shop.dart';
import '../Model/horaire.dart';

//Fonction pour détecter si le magasin est ouvert ou non
//à l'heure actuelle suivant ces horaires

bool openningBool(Shop selectedShop) {
  //now = Temps actuel
  final now = DateTime.now();

  bool isOpen = false;

  //Extraction HoraireShop
  Horaire horaire = selectedShop.horaire;
  Map<Jour, List<Heure>> horaireShop = horaire.getHoraires();

  for (Jour jour in horaireShop.keys) {
    List<Heure> listHoraire = horaireShop[jour];

    for (int i = 0; i < listHoraire.length; i += 2) {
      if (isInPeriod(
          now, jour, horaireShop[jour][i], horaireShop[jour][i + 1])) {
        isOpen = true;
      }
    }
  }

  return isOpen;
}

bool isInPeriod(DateTime now, Jour jour, Heure debut, Heure fin) {
  bool isIn = false;

  int dayNow = now.weekday;
  //Pour prendre en compte le décalage horaire pour la France
  int heureNow = now.hour + 2;
  int minuteNow = now.minute;

  if (dayNow == numJour(jour)) {
    if (debut.getHeure != fin.getHeure) {
      if ((heureNow == debut.getHeure) && (minuteNow >= debut.getMinute)) {
        isIn = true;
      }
      if ((heureNow == fin.getHeure) && (minuteNow <= fin.getMinute)) {
        isIn = true;
      }
      if ((heureNow > debut.getHeure) && (heureNow < fin.getHeure)) {
        isIn = true;
      }
    } else {
      if ((heureNow == debut.getHeure) &&
          (minuteNow >= debut.getMinute) &&
          (minuteNow <= fin.getMinute)) {
        isIn = true;
      }
    }
  }

  return isIn;
}

Map<Jour, List<Heure>> getHoraire(horaireSnapshot, isAsync) {
  // ignore: prefer_typing_uninitialized_variables
  var horaireSaved;
  if (isAsync) {
    horaireSaved = horaireSnapshot.data.docs[0];
  } else {
    horaireSaved = horaireSnapshot.docs[0];
  }
  //Remplir les horaires suivants bases de données
  Map<Jour, List<Heure>> horaire = {
    Jour.Lundi: [
      getHeureFromString(horaireSaved['mondayOp']),
      getHeureFromString(horaireSaved['mondayCl']),
    ],
    Jour.Mardi: [
      getHeureFromString(horaireSaved['tuesdayOp']),
      getHeureFromString(horaireSaved['tuesdayCl']),
    ],
    Jour.Mercredi: [
      getHeureFromString(horaireSaved['wednesdayOp']),
      getHeureFromString(horaireSaved['wednesdayCl']),
    ],
    Jour.Jeudi: [
      getHeureFromString(horaireSaved['thursdayOp']),
      getHeureFromString(horaireSaved['thursdayCl']),
    ],
    Jour.Vendredi: [
      getHeureFromString(horaireSaved['fridayOp']),
      getHeureFromString(horaireSaved['fridayCl']),
    ],
    Jour.Samedi: [
      getHeureFromString(horaireSaved['saturdayOp']),
      getHeureFromString(horaireSaved['saturdayCl']),
    ],
    Jour.Dimanche: [
      getHeureFromString(horaireSaved['sundayOp']),
      getHeureFromString(horaireSaved['sundayCl']),
    ]
  };

  return horaire;
}

double getRate(
  int nbPublication,
  int nbFavorite,
  double meanResponseTime,
  int subCatId,
  List<QueryDocumentSnapshot> shopsData,
) {
  double score;

  //Pondération
  double x1 = 1 / 3;
  double x2 = 1 / 3;
  double x3 = 1 / 3;

  //R form factor
  double rFactor = 1;
  //put double rFactor = 1.5; during publication

  //Main factors
  int a = nbPublication;
  int b = nbFavorite;
  double c = meanResponseTime;

  //Category mean factors
  double am = 0;
  double bm = 0;
  double cm = 0;

  // QuerySnapshot shops =
  //     await FirebaseFirestore.instance.collection('shops').get();
  //List<QueryDocumentSnapshot> shopsData = shops.docs;

  int index = 0;

  for (int i = 0; i < shopsData.length; i++) {
    if (shopsData[i]['subCatId'] == subCatId) {
      am += shopsData[i]['nbPublications'];
      bm += shopsData[i]['nbFavorites'];
      cm += shopsData[i]['meanResponseTime'];
      index += 1;
    }
  }

  am = am / index;
  bm = bm / index;
  cm = cm / index;

  double normalizedScore = x1 * (1 - pow(2, -a / am)) +
      x2 * (1 - pow(2, -b / bm)) +
      x3 * (1 - pow(2, -c / cm));

  score = 5 * pow(normalizedScore, rFactor);

  return score;
}
