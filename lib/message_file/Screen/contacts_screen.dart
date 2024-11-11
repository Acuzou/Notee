import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'contacts_screen_2.dart';

// ignore: must_be_immutable
class ContactScreen extends StatefulWidget {
  bool isDark;
  bool isFrench;
  bool isMerchant;

  ContactScreen({Key key, this.isDark, this.isFrench, this.isMerchant})
      : super(key: key);

  static const routeName = "/contact-screen";
  @override
  ContactScreenState createState() => ContactScreenState();
}

class ContactScreenState extends State<ContactScreen> {
  List<int> contactIdList = [];
  List<QueryDocumentSnapshot> contactUser;
  List<QueryDocumentSnapshot> contactDisplayed;
  List<QueryDocumentSnapshot> contactList;
  bool isSearching = false;
  bool isInit = true;
  List<QueryDocumentSnapshot> shopsDocs;
  final contactController = TextEditingController();

  Future<void> _getContactIdList(List<QueryDocumentSnapshot> users) async {
    try {
      var auth = FirebaseAuth.instance.currentUser;
      //Preparing updateDisplay
      var shopsSnapshot =
          await FirebaseFirestore.instance.collection("shops").get();

      shopsDocs = shopsSnapshot.docs;

      //getContactIdListFunction
      var contactSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.uid)
          .collection('contact')
          .get();

      for (int i = 0; i < contactSnapshot.docs.length; i++) {
        contactIdList.add(contactSnapshot.docs[i]['contactId']);
      }

      List<QueryDocumentSnapshot> contactList = users.where((user) {
        return (user['ID'] == 0) || contactIdList.contains(user['ID']);
      }).toList();

      setState(() {
        contactUser = contactList.toList();

        isInit = false;
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
  }

  void updateDisplay(String value) async {
    List<QueryDocumentSnapshot> updateContact = contactUser.where((contact) {
      QueryDocumentSnapshot<Object> shopContact;

      String shopName = '';

      if (contact['isMerchant']) {
        shopContact = shopsDocs.firstWhere((shop) {
          return (shop['shopId'] == contact['shopId']);
        });
        shopName = shopContact['title'];
      } else {
        shopName = '';
      }

      return '$shopName ${contact['firstname']} ${contact['lastname']}'
          .toLowerCase()
          .contains(value.toLowerCase());
    }).toList();

    if (value.isEmpty) {
      isSearching = false;
    } else {
      isSearching = true;
    }
    setState(() {
      contactDisplayed = updateContact;
      isInit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasError) {
            return const Text('Something went wrong.');
          }
          if (!userSnapshot.hasData) {
            return const Text('No DATA');
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          User auth = FirebaseAuth.instance.currentUser;
          final List<QueryDocumentSnapshot> users = userSnapshot.data.docs;

          final QueryDocumentSnapshot user =
              users.firstWhere((user) => user['email'] == auth.email);

          int myId = user['ID'];

          if (isInit) {
            _getContactIdList(users);
          }

          return ContactScreen2(
            isDark: widget.isDark,
            isFrench: widget.isFrench,
            isMerchant: widget.isMerchant,
            contactUser: contactUser,
            shopsDocs: shopsDocs,
            myId: myId,
          );
        });
  }
}
