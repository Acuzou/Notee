import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/general_widget/data_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/user_item.dart';

// ignore: must_be_immutable
class ContactScreen2 extends StatefulWidget {
  bool isDark;
  bool isFrench;
  bool isMerchant;
  List<QueryDocumentSnapshot> contactUser;
  List<QueryDocumentSnapshot> shopsDocs;
  int myId;

  ContactScreen2({
    Key key,
    this.isDark,
    this.isFrench,
    this.isMerchant,
    this.contactUser,
    this.shopsDocs,
    this.myId,
  }) : super(key: key);

  static const routeName = "/contact-screen";
  @override
  ContactScreen2State createState() => ContactScreen2State();
}

class ContactScreen2State extends State<ContactScreen2> {
  List<int> contactIdList = [];
  List<QueryDocumentSnapshot> contactUser;
  List<QueryDocumentSnapshot> contactDisplayed;
  List<QueryDocumentSnapshot> contactList;
  bool isSearching = false;
  List<QueryDocumentSnapshot> shopsDocs;
  final contactController = TextEditingController();

  @override
  void initState() {
    contactDisplayed = widget.contactUser;
    contactUser = widget.contactUser;
    shopsDocs = widget.shopsDocs;
    super.initState();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      contactList = contactDisplayed;
    } else {
      contactList = contactUser;
    }

    return Scaffold(
      //extendBody: true,
      backgroundColor: primaryColor(widget.isDark),
      body: SafeArea(
        child: Column(
          children: [
            researchBar(widget.isDark, widget.isFrench, false, false,
                updateDisplay, contactController),
            Expanded(
              child: (contactList != null)
                  ? ListView.builder(
                      itemBuilder: (ctx, index) {
                        return UserItem(
                          userId: contactList[index]['ID'],
                          userName:
                              '${contactList[index]['firstname']} ${contactList[index]['lastname']}',
                          shopId: contactList[index]['shopId'],
                          profilePictureUrl: contactList[index]
                              ['profilPictureUrl'],
                          myId: widget.myId,
                          isDark: widget.isDark,
                          isContactMerchant: contactList[index]['isMerchant'],
                          isFrench: widget.isFrench,
                          isUserMerchant: widget.isMerchant,
                        );
                      },
                      itemCount: contactList.length,
                    )
                  : Center(
                      child: Text(
                        widget.isFrench ? 'Aucun\nContact' : 'No\nContact',
                        style: TextStyle(
                          color: primaryColor(!widget.isDark),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RebondGrosteque',
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
