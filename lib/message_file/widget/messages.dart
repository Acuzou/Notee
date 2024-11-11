import 'package:cuzou_app/message_file/widget/messages_2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class Messages extends StatefulWidget {
  final QueryDocumentSnapshot conversationReference;
  final int myId;
  final int contactId;
  final bool isDark;
  final bool isFrench;

  const Messages(this.conversationReference, this.myId, this.contactId,
      this.isDark, this.isFrench,
      {Key key})
      : super(key: key);

  @override
  MessagesState createState() => MessagesState();
}

class MessagesState extends State<Messages> {
  List<QueryDocumentSnapshot> chatDocs;
  List<String> _dateList;
  List<bool> _isDateShowList;
  bool isInit = true;
  bool isChanged = false;
  int currentLength = 0;
  bool isVeryInit = true;

  void deleteMessage(int index) async {
    var conversationSnapshot = await FirebaseFirestore.instance
        .collection('chats/${widget.conversationReference.id}/messages')
        .get();

    if (conversationSnapshot.docs.length == 1) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.conversationReference.id)
          .update({'containsMessages': false});
    }

    await FirebaseFirestore.instance
        .collection('chats/${widget.conversationReference.id}/messages')
        .doc(chatDocs[index].id)
        .delete();

    setState(() {});
  }

  void initializeDateMessages(List<QueryDocumentSnapshot> chatDocs) {
    List<bool> isDateShowList = [];
    List<String> dateList = [];
    String currentTime;
    String nextTime;
    String sep;
    String formattedDate;

    if (widget.isFrench) {
      sep = ' à ';
    } else {
      sep = ' at ';
    }

    for (int i = 0; i < chatDocs.length - 1; i++) {
      formattedDate =
          DateFormat.yMMMEd().format(chatDocs[i]['createdAt'].toDate()) +
              sep +
              DateFormat.Hm().format(chatDocs[i]['createdAt'].toDate());
      dateList.add(formattedDate);

      currentTime = formatDate(
          chatDocs[i]['createdAt'].toDate(), [yyyy, '-', mm, '-', dd]);
      nextTime = formatDate(
          chatDocs[i + 1]['createdAt'].toDate(), [yyyy, '-', mm, '-', dd]);

      if (chatDocs[i]['senderId'] != chatDocs[i + 1]['senderId']) {
        isDateShowList.add(true);
      } else {
        if (currentTime == nextTime) {
          isDateShowList.add(false);
        } else {
          isDateShowList.add(true);
        }
      }
    }

    //Ajout du dernière élément
    isDateShowList.add(true);

    if (chatDocs.isNotEmpty) {
      formattedDate = DateFormat.yMMMEd()
              .format(chatDocs[chatDocs.length - 1]['createdAt'].toDate()) +
          sep +
          DateFormat.Hm()
              .format(chatDocs[chatDocs.length - 1]['createdAt'].toDate());
      dateList.add(formattedDate);
    }

    _dateList = dateList;
    _isDateShowList = isDateShowList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/${widget.conversationReference.id}/messages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          chatDocs = chatSnapshot.data.docs;

          //currentLength = chatDocs.length;

          if (isInit) {
            currentLength == chatDocs.length;
            isInit = false;
            initializeDateMessages(chatDocs);
            // if (widget.isFrench) {
            //   initializeDateFormatting('fr_FR', null)
            //       .then((_) => initializeDateMessages(chatDocs));
            // } else {
            //   initializeDateMessages(chatDocs);
            // }
          }

          isChanged = (chatDocs.length != currentLength);

          //isChanged = false;

          if (isChanged) {
            //isChanged = !isChanged;
            currentLength = chatDocs.length;
            initializeDateMessages(chatDocs);
          }

          return MessagesTwo(
            conversationReference: widget.conversationReference,
            myId: widget.myId,
            contactId: widget.contactId,
            isDark: widget.isDark,
            isFrench: widget.isFrench,
            chatDocs: chatDocs,
            deleteMessage: deleteMessage,
            isDateShowList: _isDateShowList,
            dateList: _dateList,
            isInit: isInit,
          );
        });
  }
}
