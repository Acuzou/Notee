import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/research_file/Model/shop.dart';
import 'package:flutter/material.dart';
import '../Model/horaire.dart';

final itemsNB = <Widget>[
  const Icon(Icons.map, size: 30),
  const Icon(Icons.home, size: 30),
  const Icon(Icons.message, size: 30),
];

void setPage(index, context) {
  Navigator.pushNamed(context, MainScreen.routeName, arguments: {
    'indexPage': index,
  });
}

final subCatList = {
  0: SubCat.Default,
  1: SubCat.Fast_Food,
  2: SubCat.Gastronomie,
  3: SubCat.Asiatique,
  4: SubCat.Africain,
  5: SubCat.Vegetarien,
  6: SubCat.Bar_Restaurant,
  7: SubCat.Supermarket,
  8: SubCat.Hotel,
  9: SubCat.Hotel_Luxe,
  10: SubCat.Auberge_Jeunnesse,
  11: SubCat.Camping,
  12: SubCat.Bar_Etudiant,
  13: SubCat.Bar_Dansant,
  15: SubCat.Bar,
  16: SubCat.Cafe,
  17: SubCat.Boulangerie_Patisserie,
  18: SubCat.Poissonerie,
  19: SubCat.Charcuterie,
  20: SubCat.Caviste,
  21: SubCat.Primeur,
  22: SubCat.Bio,
  23: SubCat.IceCream,
  24: SubCat.Friperie,
  25: SubCat.Fast_Fashing,
  26: SubCat.Luxe,
  27: SubCat.Opticien,
  28: SubCat.Coiffure,
  29: SubCat.Institut_beaute,
  30: SubCat.Pharmacie,
  31: SubCat.Bureau_Tabac,
  32: SubCat.Pressing,
  33: SubCat.Mercerie,
  34: SubCat.Magasin_Musique,
  35: SubCat.Magasin_Sport,
  36: SubCat.Magasin_Jouet,
  37: SubCat.Magasin_Photo,
  38: SubCat.Galerie_Art,
  39: SubCat.Cinema,
  40: SubCat.Agence_Voyage,
  41: SubCat.Office_Tourisme,
  42: SubCat.Animalerie,
  43: SubCat.Bricolage,
  44: SubCat.Librairie,
  45: SubCat.Cordonnier,
  46: SubCat.Casino,
  47: SubCat.Theatre,
};

int getSubCatIndex(SubCat subCat) {
  for (int i = 0; i < subCatList.length; i++) {
    if (subCatList[i] == subCat) {
      return i;
    }
  }
  return 0;
}

final List<City> cityList = [
  City.Default,
  City.Paris,
  City.Lyon,
  City.Marseille,
  City.Nantes,
  City.Rennes,
  City.Cannes,
  City.Bordeau,
  City.Lille,
  City.SaintEtienne,
  City.Strasbourg,
  City.Calai,
  City.Toulouse,
  City.Brest,
  City.Grenoble
];

String getCityName(City city) {
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
    case City.Bordeau:
      return 'Bordeaux';
    case City.Brest:
      return 'Brest';
    case City.Calai:
      return 'Calais';
    case City.Lille:
      return 'Lille';
    case City.SaintEtienne:
      return 'Saint-Etienne';
    case City.Strasbourg:
      return 'Strasbourg';
    case City.Toulouse:
      return 'Toulouse';
    case City.Grenoble:
      return 'Grenoble';

    default:
      return 'Unknown';
  }
}

Horaire horaireExample = Horaire({
  Jour.Lundi: [
    Heure(8, 0),
    Heure(19, 0),
  ],
  Jour.Mardi: [
    Heure(8, 0),
    Heure(19, 0),
  ],
  Jour.Mercredi: [
    Heure(8, 0),
    Heure(19, 0),
  ],
  Jour.Jeudi: [
    Heure(8, 0),
    Heure(19, 0),
  ],
  Jour.Vendredi: [
    Heure(8, 0),
    Heure(19, 0),
  ],
  Jour.Samedi: [
    Heure(8, 0),
    Heure(19, 0),
  ],
  Jour.Dimanche: [
    Heure(8, 0),
    Heure(19, 0),
  ],
});

String frenchTextType(catType) {
  switch (catType) {
    case SubCat.Default:
      return 'Recherche Global';
    case SubCat.Fast_Food:
      return 'Restauration rapide';
    case SubCat.Gastronomie:
      return 'Gastronomique';
    case SubCat.Asiatique:
      return 'Asiatique';
    case SubCat.Africain:
      return 'Africain';
    case SubCat.Vegetarien:
      return 'Végétarien';
    case SubCat.Bar_Restaurant:
      return 'Brasserie';
    case SubCat.Supermarket:
      return 'Supermarché';
    case SubCat.Hotel:
      return 'Hôtel';
    case SubCat.Hotel_Luxe:
      return 'Hôtel étoilé';
    case SubCat.Auberge_Jeunnesse:
      return 'Auberge';
    case SubCat.Camping:
      return 'Camping';
    case SubCat.Bar_Etudiant:
      return 'Bar étudiant';
    case SubCat.Bar_Dansant:
      return 'Bar dansant';
    case SubCat.Bar:
      return 'Bar';
    case SubCat.Cafe:
      return 'Café';
    case SubCat.Boulangerie_Patisserie:
      return 'Boulangerie-Patisserie';
    case SubCat.Poissonerie:
      return 'Poissonnerie';
    case SubCat.Charcuterie:
      return 'Charcuterie';
    case SubCat.Caviste:
      return 'Caviste';
    case SubCat.Primeur:
      return 'Primeur';
    case SubCat.Bio:
      return 'Bio';
    case SubCat.IceCream:
      return 'Glacier';
    case SubCat.Friperie:
      return 'Friperie';
    case SubCat.Fast_Fashing:
      return 'Prêt-à-porter';
    case SubCat.Luxe:
      return 'Maroquinerie';
    case SubCat.Opticien:
      return 'Opticien';
    case SubCat.Coiffure:
      return 'Salon de coiffure';
    case SubCat.Institut_beaute:
      return 'Institut de beauté';
    case SubCat.Pharmacie:
      return 'Pharmacie';
    case SubCat.Bureau_Tabac:
      return 'Bureau de tabac';
    case SubCat.Pressing:
      return 'Pressing';
    case SubCat.Mercerie:
      return 'Mercerie';
    case SubCat.Magasin_Musique:
      return 'Musique';
    case SubCat.Magasin_Sport:
      return 'Sport';
    case SubCat.Magasin_Jouet:
      return 'Jouet';
    case SubCat.Magasin_Photo:
      return 'Audiovisuel';
    case SubCat.Cinema:
      return 'Cinéma';
    case SubCat.Theatre:
      return 'Theater';
    case SubCat.Galerie_Art:
      return 'Galerie d\'Art';
    case SubCat.Agence_Voyage:
      return 'Agence de voyage';
    case SubCat.Office_Tourisme:
      return 'Office de tourisme';
    case SubCat.Animalerie:
      return 'Animalerie';
    case SubCat.Bricolage:
      return 'Bricolage';
    case SubCat.Librairie:
      return 'Librairie';
    case SubCat.Cordonnier:
      return 'Cordonnier';
    case SubCat.Casino:
      return 'Casino';
    default:
      return 'Inconnu';
  }
}

String englishTextType(catType) {
  switch (catType) {
    case SubCat.Default:
      return 'Global Search';
    case SubCat.Fast_Food:
      return 'Fast-Food';
    case SubCat.Gastronomie:
      return 'Gastronomie';
    case SubCat.Asiatique:
      return 'Asian';
    case SubCat.Africain:
      return 'African';
    case SubCat.Vegetarien:
      return 'Vegan';
    case SubCat.Bar_Restaurant:
      return 'Bar-Restaurant';
    case SubCat.Supermarket:
      return 'Drug Store';
    case SubCat.Hotel:
      return 'Hotel';
    case SubCat.Hotel_Luxe:
      return 'Luxe Hotel';
    case SubCat.Auberge_Jeunnesse:
      return 'Hostel';
    case SubCat.Camping:
      return 'Camping';
    case SubCat.Bar_Etudiant:
      return 'Student Bar';
    case SubCat.Bar_Dansant:
      return 'Dancing Bar';
    case SubCat.Bar:
      return 'Bar';
    case SubCat.Cafe:
      return 'Café';
    case SubCat.Boulangerie_Patisserie:
      return 'Bakery';
    case SubCat.Poissonerie:
      return 'Fish shop';
    case SubCat.Charcuterie:
      return 'Butchery';
    case SubCat.Caviste:
      return 'Wine Merchant';
    case SubCat.Primeur:
      return 'Greengrocer store';
    case SubCat.Bio:
      return 'Organic';
    case SubCat.IceCream:
      return 'Ice Cream Store';
    case SubCat.Friperie:
      return 'Thrift Shop';
    case SubCat.Fast_Fashing:
      return 'Fast-Fashion';
    case SubCat.Luxe:
      return 'Luxe';
    case SubCat.Opticien:
      return 'Optician';
    case SubCat.Coiffure:
      return 'Hair Salon';
    case SubCat.Institut_beaute:
      return 'Beauty Institute';
    case SubCat.Pharmacie:
      return 'Pharmacy';
    case SubCat.Bureau_Tabac:
      return 'Smoke shop';
    case SubCat.Pressing:
      return 'Pressing';
    case SubCat.Mercerie:
      return 'Haberdasher';
    case SubCat.Magasin_Musique:
      return 'Music Store';
    case SubCat.Magasin_Sport:
      return 'Sport store';
    case SubCat.Magasin_Jouet:
      return 'Toy Store';
    case SubCat.Magasin_Photo:
      return 'Picture Store';
    case SubCat.Cinema:
      return 'Cinema';
    case SubCat.Theatre:
      return 'Theater';
    case SubCat.Galerie_Art:
      return 'Art Gallery';
    case SubCat.Agence_Voyage:
      return 'Travel Agency';
    case SubCat.Office_Tourisme:
      return 'Tourist Office';
    case SubCat.Animalerie:
      return 'Pet Store';
    case SubCat.Bricolage:
      return 'DIY Store';
    case SubCat.Librairie:
      return 'Bookstore';
    case SubCat.Cordonnier:
      return 'Shoemaker';
    case SubCat.Casino:
      return 'Casino';
    default:
      return 'Unknown';
  }
}

VisibilityShop getVisibility(int visibilityId) {
  switch (visibilityId) {
    case (0):
      return VisibilityShop.Bronze;
    case (1):
      return VisibilityShop.Silver;
    case (2):
      return VisibilityShop.Gold;
    case (3):
      return VisibilityShop.Diamond;
    default:
      return VisibilityShop.Bronze;
  }
}

String visibilityText(VisibilityShop visibility) {
  switch (visibility) {
    case VisibilityShop.Bronze:
      return 'Bronze';
    case VisibilityShop.Silver:
      return 'Silver';
    case VisibilityShop.Gold:
      return 'Gold';
    case VisibilityShop.Diamond:
      return 'Diamond';
    default:
      return 'Unknown';
  }
}

String visibilityImageURL(VisibilityShop visibilityShop) {
  switch (visibilityShop) {
    case VisibilityShop.Bronze:
      return 'assets/images/logos/visibility_logos/bronze.png';
    case VisibilityShop.Silver:
      return 'assets/images/logos/visibility_logos/silver.png';
    case VisibilityShop.Gold:
      return 'assets/images/logos/visibility_logos/gold.png';
    case VisibilityShop.Diamond:
      return 'assets/images/logos/visibility_logos/diamond.png';
    default:
      return 'assets/images/logos/visibility_logos/bronze.png';
  }
}
