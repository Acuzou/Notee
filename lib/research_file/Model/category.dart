import 'package:flutter/material.dart';
import '../Model/shop.dart';

class Category {
  final String id;
  final String frenchTitle;
  final String englishTitle;
  final List<SubCat> subcategorie;
  final Color color;
  final String image;

  //A modifier pour rajouter le logo comme instance de class

  const Category({
    this.id,
    this.frenchTitle,
    this.englishTitle,
    this.subcategorie,
    this.color,
    this.image,
  });
}
