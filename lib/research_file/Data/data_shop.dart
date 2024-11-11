import 'package:cuzou_app/research_file/Model/subcategory.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';

import '../Model/category.dart';
import '../Model/shop.dart';
import 'package:cuzou_app/main.dart';

double subcatIconSize = 50;
double subcatBigIconSize = 90;
double subcatSmallIconSize = 50;

Icon defaultIcon(bool isSmall) {
  return Icon(Icons.wallpaper,
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize);
}

//SHOP CATEGORIES DATA
// ignore: non_constant_identifier_names
final SHOP_CATEGORIES = [
  Category(
    id: 'c1',
    frenchTitle: 'Restaurant',
    englishTitle: 'Restaurant',
    subcategorie: [
      SubCat.Fast_Food,
      SubCat.Gastronomie,
      SubCat.Asiatique,
      SubCat.Africain,
      SubCat.Vegetarien,
      SubCat.Bar_Restaurant,
    ],
    color: Palette.orange,
    image: 'assets/images/logos/category_logos/logo_restaurant.png',
  ),
  Category(
    id: 'c2',
    frenchTitle: 'Logement',
    englishTitle: 'Housing',
    subcategorie: [
      SubCat.Hotel,
      SubCat.Hotel_Luxe,
      SubCat.Auberge_Jeunnesse,
      SubCat.Camping,
    ],
    color: Palette.yellow,
    image: 'assets/images/logos/category_logos/logo_hotel.png',
  ),
  Category(
    id: 'c3',
    frenchTitle: 'Bar',
    englishTitle: 'Bar',
    subcategorie: [
      SubCat.Cafe,
      SubCat.Bar,
      SubCat.Bar_Dansant,
      SubCat.Bar_Restaurant,
      SubCat.Bar_Etudiant,
    ],
    color: Palette.green,
    image: 'assets/images/logos/category_logos/logo_bar.png',
  ),
  Category(
    id: 'c4',
    frenchTitle: 'Epicerie Fine',
    englishTitle: 'Deli',
    subcategorie: [
      SubCat.Boulangerie_Patisserie,
      SubCat.Poissonerie,
      SubCat.Charcuterie,
      SubCat.Supermarket,
      SubCat.Caviste,
      SubCat.Primeur,
      SubCat.Bio,
      SubCat.IceCream,
    ],
    color: Palette.purple,
    image: 'assets/images/logos/category_logos/logo_epicerie_fine.png',
  ),
  Category(
    id: 'c5',
    frenchTitle: 'Mode',
    englishTitle: 'Fashion',
    subcategorie: [
      SubCat.Friperie,
      SubCat.Fast_Fashing,
      SubCat.Luxe,
      SubCat.Institut_beaute,
      SubCat.Coiffure,
      SubCat.Opticien,
      SubCat.Pressing,
      SubCat.Mercerie,
    ],
    color: Palette.pink,
    image: 'assets/images/logos/category_logos/logo_mode.png',
  ),
  Category(
    id: 'c6',
    frenchTitle: 'Spécialisés',
    englishTitle: 'Specialized',
    subcategorie: [
      SubCat.Pharmacie,
      SubCat.Librairie,
      SubCat.Magasin_Musique,
      SubCat.Magasin_Sport,
      SubCat.Magasin_Jouet,
      SubCat.Magasin_Photo,
      SubCat.Cinema,
      SubCat.Galerie_Art,
      SubCat.Agence_Voyage,
      SubCat.Office_Tourisme,
      SubCat.Animalerie,
      SubCat.Cordonnier,
      SubCat.Bricolage,
      SubCat.Casino,
      SubCat.Theatre,
      SubCat.Bureau_Tabac,
    ],
    color: Palette.blue,
    image: 'assets/images/logos/category_logos/logo_service.png',
  ),
];

//SHOP SUBCATEGORIE DATA
// ignore: non_constant_identifier_names
List<SubCategory> SHOP_SUBCATEGORIES(bool isSmall) {
  return [
    SubCategory(
      id: 0,
      type: SubCat.Default,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_1.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    //Restaurant SubCategorie
    SubCategory(
      id: 1,
      type: SubCat.Fast_Food,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_1.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 2,
      type: SubCat.Gastronomie,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_2.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
      //icon: Icon(Icons.brunch_dining),
    ),
    SubCategory(
      id: 3,
      type: SubCat.Asiatique,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_3.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 4,
      type: SubCat.Africain,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_4.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 5,
      type: SubCat.Vegetarien,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_5.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),

    SubCategory(
      id: 7,
      type: SubCat.Bar_Restaurant,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_7.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),

    //Hotel SubCategories
    SubCategory(
      id: 8,
      type: SubCat.Hotel,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_8.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
      //icon: Icon(Icons.bungalow),
    ),
    SubCategory(
      id: 9,
      type: SubCat.Hotel_Luxe,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_9.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 10,
      type: SubCat.Auberge_Jeunnesse,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_10.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 11,
      type: SubCat.Camping,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_11.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),

    //Bar SubCategories
    SubCategory(
      id: 16,
      type: SubCat.Cafe,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_16.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 15,
      type: SubCat.Bar,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_15.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 13,
      type: SubCat.Bar_Dansant,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_13.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 12,
      type: SubCat.Bar_Etudiant,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_12.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),

    //Epicerie fine SubCategories
    SubCategory(
      id: 6,
      type: SubCat.Supermarket,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_6.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 17,
      type: SubCat.Boulangerie_Patisserie,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_17.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 18,
      type: SubCat.Poissonerie,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_18.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 19,
      type: SubCat.Charcuterie,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_19.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 20,
      type: SubCat.Caviste,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_20.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 21,
      type: SubCat.Primeur,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_21.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 22,
      type: SubCat.Bio,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_22.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 23,
      type: SubCat.IceCream,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_23.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    //Mode SubCategories
    SubCategory(
      id: 24,
      type: SubCat.Friperie,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_24.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 25,
      type: SubCat.Fast_Fashing,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_25.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 26,
      type: SubCat.Luxe,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_26.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 29,
      type: SubCat.Institut_beaute,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_29.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 28,
      type: SubCat.Coiffure,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_28.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 27,
      type: SubCat.Opticien,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_27.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 32,
      type: SubCat.Pressing,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_32.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 33,
      type: SubCat.Mercerie,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_33.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),

    //Service SubCategories
    SubCategory(
      id: 30,
      type: SubCat.Pharmacie,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_30.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 39,
      type: SubCat.Cinema,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_39.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),

    SubCategory(
      id: 34,
      type: SubCat.Magasin_Musique,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_34.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 35,
      type: SubCat.Magasin_Sport,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_35.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 40,
      type: SubCat.Agence_Voyage,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_40.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 41,
      type: SubCat.Office_Tourisme,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_41.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 44,
      type: SubCat.Librairie,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_44.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 38,
      type: SubCat.Galerie_Art,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_38.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 36,
      type: SubCat.Magasin_Jouet,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_36.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 37,
      type: SubCat.Magasin_Photo,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_37.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),

    SubCategory(
      id: 42,
      type: SubCat.Animalerie,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_42.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 45,
      type: SubCat.Cordonnier,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_45.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 43,
      type: SubCat.Bricolage,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_43.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 46,
      type: SubCat.Casino,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_46.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 31,
      type: SubCat.Bureau_Tabac,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_31.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    ),
    SubCategory(
      id: 47,
      type: SubCat.Theatre,
      color: Palette.primary,
      image:
          'assets/images/logos/subcategory_logos/Pictogrammes_Sous-categories_47.png',
      size: (isSmall) ? subcatSmallIconSize : subcatBigIconSize,
    )
  ];
}
