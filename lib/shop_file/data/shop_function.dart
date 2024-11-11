import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String getShopNameFromId(int shopId) async {
  var auth = FirebaseAuth.instance.currentUser;
  var shops = await FirebaseFirestore.instance.collection("shops").get();
  final List<QueryDocumentSnapshot> shopsDocs = shops.docs;

  QueryDocumentSnapshot shop = shopsDocs.firstWhere((shop) => shop['shopId'] = shopId);

  return shop['title'];
}