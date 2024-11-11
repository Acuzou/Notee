// ignore_for_file: constant_identifier_names

import 'horaire.dart';
import 'coordonnee.dart';

//Niveau d'abonnement (Bronze = Gratuit)
enum VisibilityShop {
  Bronze,
  Silver,
  Gold,
  Diamond,
}

//A Completer pour toutes les villes possèdant au moins un magasin sur l'appli
enum City {
  Paris,
  Lyon,
  Marseille,
  Nantes,
  Rennes,
  Cannes,
  Bordeau,
  Lille,
  Strasbourg,
  SaintEtienne,
  Calai,
  Brest,
  Grenoble,
  Toulouse,
  Default,
}

enum SubCat {
  Fast_Food,
  Gastronomie,
  Asiatique,
  Africain,
  Vegetarien,
  Bar_Restaurant,
  Supermarket,
  Hotel,
  Hotel_Luxe,
  Auberge_Jeunnesse,
  Camping,
  Bar_Etudiant,
  Bar_Dansant,
  Bar,
  Cafe,
  Boulangerie_Patisserie,
  Poissonerie,
  Charcuterie,
  Caviste,
  Primeur,
  Bio,
  IceCream,
  Friperie,
  Fast_Fashing,
  Luxe,
  Opticien,
  Coiffure,
  Institut_beaute,
  Pharmacie,
  Bureau_Tabac,
  Pressing,
  Mercerie,
  Magasin_Musique,
  Magasin_Sport,
  Magasin_Jouet,
  Magasin_Photo,
  Galerie_Art,
  Cinema,
  Theatre,
  Agence_Voyage,
  Office_Tourisme,
  Animalerie,
  Bricolage,
  Librairie,
  Cordonnier,
  Casino,
  Default,
}

class Shop {
  final int shopId;
  final int userSavId;
  final int subCatId;
  final String title;
  final City city;
  final bool isBan;

  //int contactShopId;

  //Number Between 0 and 10 to juge the value of a shop
  final double rate;

  //Visibility between 0 and 1 - Random pour le moment - A changer suivant abonnement
  //final VisibilityShop visibility;

  //Unique name of the image
  final String imageUrl;
  final Horaire horaire;

  final Coordonnee coordonnee;
  final String presentationContent;

  Shop(
      {this.shopId,
      this.userSavId,
      this.subCatId,
      this.title,
      this.city,
      this.rate,
      //this.visibility,
      this.imageUrl,
      this.horaire,
      this.coordonnee,
      this.isBan,
      this.presentationContent});

  String getCityName() {
    switch (city) {
      case City.Paris:
        return 'Paris';
      case City.Cannes:
        return 'Cannes';
      case City.Lyon:
        return 'Lyon';
      case City.Nantes:
        return 'Nantes';
      case City.Marseille:
        return 'Marseille';
      case City.Rennes:
        return 'Rennes';
      default:
        return 'Unknown';
    }
  }
}
