import 'package:cloud_firestore/cloud_firestore.dart';

//Vérifie si contactId est un contact déjà existant de uid
Future<bool> isContactFunction(String uid, int contactId) async {
  bool isContact = false;

  var collection = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('contact')
      .get();

  for (int i = 0; i < collection.docs.length; i++) {
    if (contactId == collection.docs[i]['contactId']) {
      isContact = true;
    }
  }

  return isContact;
}

//Fonction renvoyant l'identifiant Uid-Firebase à partir de son identifiant Id
Future<String> getUidFromId(int id) async {
  String uid = '';

  var collection = await FirebaseFirestore.instance.collection('users').get();

  for (int i = 0; i < collection.docs.length; i++) {
    if (id == collection.docs[i]['ID']) {
      uid = collection.docs[i].id;
    }
  }

  return uid;
}
