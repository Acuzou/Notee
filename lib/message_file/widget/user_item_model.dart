import 'dart:async';

import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';
import '../Screen/messages_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserItemModel extends StatefulWidget {
  final int userId;
  final int myId;
  final String userName;
  final int shopId;
  final String profilePictureUrl;
  final bool isDark;
  final bool isContactMerchant;
  final bool isUserMerchant;
  final bool isFrench;
  final QueryDocumentSnapshot conversationReference;
  final bool isSaw;

  const UserItemModel({
    Key key,
    this.userId,
    this.userName,
    this.shopId,
    this.profilePictureUrl,
    this.myId,
    this.isDark,
    this.isContactMerchant,
    this.isUserMerchant,
    this.conversationReference,
    this.isFrench,
    this.isSaw,
  }) : super(key: key);

  @override
  UserItemModelState createState() => UserItemModelState();
}

class UserItemModelState extends State<UserItemModel> {
  void selectContact(BuildContext context) {
    Navigator.of(context).pushNamed(
      MessageScreen.routeName,
      arguments: {
        'contactId': widget.userId,
        'contactName': widget.userName,
        'shopId': widget.shopId,
        'photo': widget.profilePictureUrl,
        'myId': widget.myId,
        'isDark': widget.isDark,
        'isFrench': widget.isFrench,
        'isUserMerchant': widget.isUserMerchant,
        'isContactMerchant': widget.isContactMerchant,
      },
    );
  }

  String contactName;
  String lastMessage;
  bool boldFont;

  @override
  // ignore: must_call_super
  void initState() {
    contactName = widget.userName;
    lastMessage = '';
    boldFont = !widget.isSaw;
    super.initState();
  }

  @override
  void dispose() {
    contactName = null;
    lastMessage = null;
    super.dispose();
  }

  Future<void> setContactInfo(shopId) async {
    String lastMessageLocal;
    String shopName = "";
    //bool _boldFont;

    var shopSnapshot =
        await FirebaseFirestore.instance.collection("shops").get();

    for (int i = 0; i < shopSnapshot.docs.length; i++) {
      if (shopId == shopSnapshot.docs[i]['shopId']) {
        if ((shopId != 0) && (widget.userId != 0)) {
          shopName = shopSnapshot.docs[i]['title'];
        }
      }
    }

    if (widget.conversationReference['containsMessages']) {
      var conversationSnapshot = await FirebaseFirestore.instance
          .collection('chats/${widget.conversationReference.id}/messages')
          .orderBy('createdAt', descending: true)
          .get();

      if (conversationSnapshot.docs[0]['senderId'] == widget.myId) {

        lastMessageLocal = "Vous : ${conversationSnapshot.docs[0]['content']}";
        boldFont = false;
        
      } else {
        lastMessageLocal = conversationSnapshot.docs[0]['content'];
        boldFont = !widget.isSaw;
        
      }
    } else {
      lastMessageLocal = (widget.isFrench) ? 'Pas de Message' : 'No Message';
      boldFont = false;
    }


    if (mounted) {
      setState(() {
        if ((shopName != null) && (widget.userId != 0)) {
          contactName = '$shopName / ${widget.userName}';
        }
      });
      lastMessage = lastMessageLocal;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double width = size.width;

    setContactInfo(widget.shopId);

    return Container(
      color: primaryColor(widget.isDark),
      child: Column(
        children: [
          Material(
            color: primaryColor(widget.isDark),
            child: InkWell(
              splashColor: Palette.pink,
              onTap: () => selectContact(context),
              child: Card(
                shadowColor: primaryColor(widget.isDark),
                color: primaryColor(widget.isDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                margin: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 2 * width / 10,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  //backgroundImage: NetworkImage(''),
                                  backgroundImage:
                                      NetworkImage(widget.profilePictureUrl),
                                  radius: 30,
                                  backgroundColor: Palette.white,
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 9 * width / 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.isContactMerchant
                                        ? contactName
                                        : widget.userName,
                                    style: TextStyle(
                                      color: primaryColor(!widget.isDark),
                                      fontSize: 20,
                                      fontWeight: (boldFont)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    lastMessage,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: primaryColor(!widget.isDark)
                                          .withOpacity(0.6),
                                      fontWeight: (boldFont)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   width: width / 6,
                          //   child: Icon(
                          //     Icons.circle,
                          //     color: (boldFont)
                          //         ? primaryColor(!widget.isDark)
                          //         : primaryColor(widget.isDark),
                          //     size: 20,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.93,
            child: Divider(
              thickness: 1,
              color: primaryColor(!widget.isDark),
              //endIndent: 20,
            ),
          ),
        ],
      ),
    );
  }

  // String getShopName(shopId) {
  //   Shop selectedShop = dataShops.firstWhere((shop) => (shop.id == shopId));

  //   return (selectedShop.title);
  // }
}
