import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../research_file/Data/data_function.dart';
import '../Data/user_function.dart';

class NewMessage extends StatefulWidget {
  final QueryDocumentSnapshot conversationReference;
  final int myId;
  final int contactId;
  final bool isDark;
  final bool isFrench;
  final bool isUserMerchant;
  final bool isContactMerchant;
  final String isUserIdIndexSaw;
  final void Function() refreshPage;

  const NewMessage({
    Key key,
    this.conversationReference,
    this.myId,
    this.contactId,
    this.isDark,
    this.isFrench,
    this.isUserMerchant,
    this.isContactMerchant,
    this.isUserIdIndexSaw,
    this.refreshPage,
  }) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  int _myId = 0;
  int _contactId = 0;

  void _sendMessage() async {
    _controller.clear();

    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;

    //isSaw State
    String isContactIdIndexSaw;
    if (widget.isUserIdIndexSaw == 'isUserIdOneSaw') {
      isContactIdIndexSaw = 'isUserIdTwoSaw';
    } else {
      isContactIdIndexSaw = 'isUserIdOneSaw';
    }

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.conversationReference.id)
        .update({
      'containsMessages': true,
      isContactIdIndexSaw: false,
    });

    //Actualisation Contact dans Users
    bool isContact = await isContactFunction(user.uid, _contactId);

    if (!isContact) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('contact')
          .doc(_contactId.toString())
          .set({'contactId': _contactId});

      String contactUid = await getUidFromId(_contactId);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(contactUid)
          .collection('contact')
          .doc(_myId.toString())
          .set({'contactId': _myId});
    }

    //Envoie du message
    bool mustBeResponded = false;

    await FirebaseFirestore.instance
        .collection('chats/${widget.conversationReference.id}/messages')
        .add({
      'content': _enteredMessage,
      'imageMessageUrl': '',
      'createdAt': Timestamp.now(),
      'senderId': _myId,
      'receiverId': _contactId,
      'mustBeResponded': ((widget.isUserMerchant == false) &&
          (widget.isContactMerchant == true)),
    });

    //Actualisation du score
    var chatsSnapshot = await FirebaseFirestore.instance
        .collection('chats/${widget.conversationReference.id}/messages')
        .orderBy('createdAt', descending: true)
        .get();

    QueryDocumentSnapshot previousChat = chatsSnapshot.docs[0];

    mustBeResponded = previousChat['mustBeResponded'];

    if (widget.isUserMerchant && mustBeResponded) {
      await FirebaseFirestore.instance
          .collection('chats/${widget.conversationReference.id}/messages')
          .doc(previousChat.id)
          .update({'mustBeResponded': false});

      var shopsSnapshot =
          await FirebaseFirestore.instance.collection("shops").get();

      var shopsDocs = shopsSnapshot.docs;

      var shopUserDoc = shopsDocs.firstWhere((shop) => user.uid == shop.id);

      //Calcul du nouveau temps de réponse moyen au message du commerçant
      //mn = sum(a_i) avec i allant de 1 à n
      double mn = shopUserDoc['meanResponseTime'];
      double n = shopUserDoc['nbResponses'];

      //rt = a_n+1
      DateTime previousDateChat = previousChat['createdAt'].toDate();
      DateTime now = DateTime.now();
      double rt = now.difference(previousDateChat).inMinutes.toDouble();

      double meanResponseTime = ((n * mn) + rt) / (n + 1);

      double rate = getRate(
          shopUserDoc['nbPublications'],
          shopUserDoc['nbFavorites'],
          shopUserDoc['meanResponseTime'],
          shopUserDoc['subCatId'],
          shopsDocs);

      await FirebaseFirestore.instance
          .collection('shops')
          .doc(user.uid)
          .update({
        'nbResponses': shopUserDoc['nbResponses'] + 1,
        'meanResponseTime': meanResponseTime,
        'rate': rate,
      });
    }

    widget.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    _myId = widget.myId;
    _contactId = widget.contactId;

    return Container(
        color: primaryColor(widget.isDark),
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                  keyboardAppearance:
                      widget.isDark ? Brightness.dark : Brightness.light,
                  controller: _controller,
                  style: TextStyle(color: primaryColor(!widget.isDark)),
                  //obscureText: true,
                  decoration: InputDecoration(
                    fillColor: widget.isDark
                        ? shadeColor(Palette.grey, 0.9)
                        : shadeColor(Palette.grey, 0.1),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: shadeColor(Palette.blue, 0.3), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Palette.blue, width: 1.0),
                    ),
                    hintText: widget.isFrench
                        ? 'Votre message ...'
                        : 'Your message...',
                    hintStyle: TextStyle(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                    ),
                  ),
                  
                  onChanged: (value) {
                    //_enteredMessage = value;
                     setState(() {
                       _enteredMessage = value;
                     });
                  }
                  ,
                  
                  ),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor(!widget.isDark),
                  width: 2,
                ),
              ),
              child: IconButton(
                //color: shadeColor(Palette.blue, 0.5),
                disabledColor: shadeColor(Palette.blue, 0.4),
                color: widget.isDark
                    ? Palette.blue
                    : shadeColor(Palette.blue, 0.6),
                iconSize: 30,
                icon: const Icon(
                  Icons.send,
                ),
                splashColor: shadeColor(Palette.grey, 0.2),
                splashRadius: 30,
                //Color when the IconButton is pressed
                highlightColor: widget.isDark
                    ? shadeColor(Palette.blue, 0.2)
                    : shadeColor(Palette.blue, 0.4),
                onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              ),
            )
          ],
        ));
  }
}
