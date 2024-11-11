import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/message_file/widget/user_item_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserItem extends StatelessWidget {
  final int userId;
  final int myId;
  final String userName;
  final int shopId;
  final String profilePictureUrl;
  final bool isDark;
  final bool isContactMerchant;
  final bool isUserMerchant;
  final bool isFrench;

  final Color colorWidget = Palette.primary;
  //shopName == 'Utilisateur'

  UserItem({
    Key key,
    this.userId,
    this.userName,
    this.shopId,
    this.profilePictureUrl,
    this.myId,
    this.isDark,
    this.isContactMerchant,
    this.isUserMerchant,
    this.isFrench,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<QueryDocumentSnapshot> chatDocs = chatSnapshot.data.docs;

          QueryDocumentSnapshot conversationReference;

          for (int i = 0; i < chatDocs.length; i++) {
            if (((chatDocs[i]['userIdOne'] == myId) &&
                    (chatDocs[i]['userIdTwo'] == userId)) ||
                ((chatDocs[i]['userIdTwo'] == myId) &&
                    (chatDocs[i]['userIdOne'] == userId))) {
              conversationReference = chatDocs[i];
            }
          }

          bool isSaw = true;
          if (conversationReference != null) {
            if (conversationReference['userIdOne'] == myId) {
              isSaw = conversationReference['isUserIdOneSaw'];
            } else {
              isSaw = conversationReference['isUserIdTwoSaw'];
            }

            // print(conversationReference['userIdOne']);
            // print(conversationReference['userIdTwo']);
            // print(isSaw);
          }

          return UserItemModel(
            userId: userId,
            myId: myId,
            userName: userName,
            shopId: shopId,
            profilePictureUrl: profilePictureUrl,
            isDark: isDark,
            isContactMerchant: isContactMerchant,
            isUserMerchant: isUserMerchant,
            isFrench: isFrench,
            conversationReference: conversationReference,
            isSaw: isSaw,
          );
        });
  }
}
