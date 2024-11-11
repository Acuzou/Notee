// ignore_for_file: constant_identifier_names

enum Jour {
  Lundi,
  Mardi,
  Mercredi,
  Jeudi,
  Vendredi,
  Samedi,
  Dimanche,
}

class Horaire {
  Map<Jour, List<Heure>> horaires;

  //Ex: {Jour.Lundi: [(8,0), (12,0), (14,0), (18,0)], ...}

  Horaire(this.horaires);

  Map<Jour, List<Heure>> getHoraires() {
    return horaires;
  }

  String horaireList(Jour jour) {
    List<Heure> listHoraire = horaires[jour];
    String strHoraire = '';

    for (int i = 0; i < listHoraire.length; i++) {
      if (i % 2 == 1) {
        strHoraire += '-';
      } else {
        if (i != 0) {
          strHoraire += ' / ';
        }
      }

      strHoraire += listHoraire[i].getStringHeure;
    }

    return strHoraire;
  }
}

class Heure {
  final int heure;
  final int minute;

  Heure(this.heure, this.minute);

  int get getHeure {
    return heure;
  }

  int get getMinute {
    return minute;
  }

  String get getStringHeure {
    if (minute ~/ 10 == 0) {
      return '$heure:0$minute';
    } else {
      return '$heure:$minute';
    }
  }
}

Heure getHeureFromString(String str) {
  int heure;
  int minute;
  String heureStr = '';
  String minuteStr = '';

  bool sep = false;

  for (int i = 0; i < str.length; i++) {
    if (str[i] == ":") {
      sep = true;
    } else {
      if (!sep) {
        heureStr += str[i];
      } else {
        minuteStr += str[i];
      }
    }
  }

  heure = int.parse(heureStr);
  minute = int.parse(minuteStr);

  return Heure(heure, minute);
}

int numJour(Jour jour) {
  switch (jour) {
    case Jour.Lundi:
      return 1;
    case Jour.Mardi:
      return 2;
    case Jour.Mercredi:
      return 3;
    case Jour.Jeudi:
      return 4;
    case Jour.Vendredi:
      return 5;
    case Jour.Samedi:
      return 6;
    case Jour.Dimanche:
      return 7;
    default:
      return 0;
  }
}

Jour jourNum(int dayIndex) {
  switch (dayIndex) {
    case 1:
      return Jour.Lundi;
    case 2:
      return Jour.Mardi;
    case 3:
      return Jour.Mercredi;
    case 4:
      return Jour.Jeudi;
    case 5:
      return Jour.Vendredi;
    case 6:
      return Jour.Samedi;
    case 7:
      return Jour.Dimanche;
    default:
      return Jour.Lundi;
  }
}

String textJour(Jour jour) {
  switch (jour) {
    case Jour.Lundi:
      return 'Lundi';
    case Jour.Mardi:
      return 'Mardi';
    case Jour.Mercredi:
      return 'Mercredi';
    case Jour.Jeudi:
      return 'Jeudi';
    case Jour.Vendredi:
      return 'Vendredi';
    case Jour.Samedi:
      return 'Samedi';
    case Jour.Dimanche:
      return 'Dimanche';
    default:
      return 'Inconnu';
  }
}

// ignore: missing_return
String getFieldFromIndex(int dayIndex, int openIndex) {
  switch (dayIndex) {
    case (1):
      switch (openIndex) {
        case (0):
          return 'mondayOp';
        case (1):
          return 'mondayCl';
      }
      break;
    case (2):
      switch (openIndex) {
        case (0):
          return 'tuesdayOp';
        case (1):
          return 'tuesdayCl';
      }
      break;
    case (3):
      switch (openIndex) {
        case (0):
          return 'wednesdayOp';
        case (1):
          return 'wednesdayCl';
      }
      break;
    case (4):
      switch (openIndex) {
        case (0):
          return 'thursdayOp';
        case (1):
          return 'thursdayCl';
      }
      break;
    case (5):
      switch (openIndex) {
        case (0):
          return 'fridayOp';
        case (1):
          return 'fridayCl';
      }
      break;
    case (6):
      switch (openIndex) {
        case (0):
          return 'saturdayOp';
        case (1):
          return 'saturdayCl';
      }
      break;
    case (7):
      switch (openIndex) {
        case (0):
          return 'sundayOp';
        case (1):
          return 'sundayCl';
      }
      break;
    default:
      return 'Unknow';
      break;
  }
}
