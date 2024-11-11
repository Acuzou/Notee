//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'messages_screen2.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/message-screen';

  const MessageScreen({Key key}) : super(key: key);

  @override
  MessageScreenState createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen> {
  bool isInit = true;

  // @override
  // void initState() {
  //   final fbm = FirebaseMessaging.instance;
  //   fbm.requestPermission();

  //   FirebaseMessaging.onMessage.listen((message) {
  //     print(message);
  //     return;
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     print(message);
  //     return;
  //   });
  //   fbm.subscribeToTopic('chats');

  //   super.initState();
  // }
  

  void setSawState(
    QueryDocumentSnapshot conversationReference,
    String isUserIdIndexSaw,
    bool isMe,
  ) async {
    if (isMe) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(conversationReference.id)
          .update({
        'isUserIdOneSaw': true,
        'isUserTwoSaw': true,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(conversationReference.id)
          .update({isUserIdIndexSaw: true});
    }
  }

  void _createConversationDocument(
    BuildContext ctx,
    int senderId,
    int receiverId,
  ) async {
    try {
      //User auth = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('chats').add({
        'userIdOne': senderId,
        'userIdTwo': receiverId,
        'containsMessages': false,
        'isUserIdOneSaw': true,
        'isUserIdTwoSaw': true,
      });
    } on PlatformException catch (err) {
      var message = 'An error occured, pleased check your credentials !';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }
  }

  // void actualizeConversation() {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    int contactId = routeArgs['contactId'] as int;
    final contactName = routeArgs['contactName'] as String;
    final profilePhoto = routeArgs['photo'] as String;
    int myId = routeArgs['myId'] as int;
    bool isDark = routeArgs['isDark'] as bool;
    bool isFrench = routeArgs['isFrench'] as bool;
    bool isUserMerchant = routeArgs['isUserMerchant'] as bool;
    bool isContactMerchant = routeArgs['isContactMerchant'] as bool;

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

          bool conversationExists = false;
          String isUserIdIndexSaw;

          for (int i = 0; i < chatDocs.length; i++) {
            if ((chatDocs[i]['userIdOne'] == myId) &&
                (chatDocs[i]['userIdTwo'] == contactId)) {
              conversationExists = true;
              conversationReference = chatDocs[i];
              isUserIdIndexSaw = 'isUserIdOneSaw';
            }

            if ((chatDocs[i]['userIdTwo'] == myId) &&
                (chatDocs[i]['userIdOne'] == contactId)) {
              conversationExists = true;
              conversationReference = chatDocs[i];
              isUserIdIndexSaw = 'isUserIdTwoSaw';
            }
          }

          if (!conversationExists) {
            _createConversationDocument(context, myId, contactId);
            conversationReference = chatDocs.firstWhere((chat) =>
                (chat['userIdOne'] == myId) &&
                (chat['userIdTwo'] == contactId));
          } else {
            if (isInit) {
              setSawState(
                conversationReference,
                isUserIdIndexSaw,
                (myId == contactId),
              );
              isInit = false;
            }
          }

          // _messageId = generatePrimaryKey(messagesDocs);

          return MessageScreen2(
            isDark: isDark,
            isFrench: isFrench,
            profilePhoto: profilePhoto,
            contactName: contactName,
            contactId: contactId,
            myId: myId,
            isUserMerchant: isUserMerchant,
            isContactMerchant: isContactMerchant,
            isUserIdIndexSaw: isUserIdIndexSaw,
            conversationReference: conversationReference,
          );
        });
  }
}
