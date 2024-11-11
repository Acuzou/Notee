import 'package:flutter/material.dart';
import '../Model/shop.dart';

class SubCategory {
  final int id;
  final SubCat type;
  final Color color;
  final String image;
  final double size;

  //A modifier pour rajouter le logo comme instance de class

  const SubCategory({
    this.id,
    this.type,
    this.color,
    this.image,
    this.size,
  });
}
