import 'package:cuzou_app/message_file/widget/message_bubble.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesTwo extends StatefulWidget {
  final QueryDocumentSnapshot conversationReference;
  final int myId;
  final int contactId;
  final bool isDark;
  final bool isFrench;
  final bool isInit;
  final List<QueryDocumentSnapshot> chatDocs;
  final List<bool> isDateShowList;
  final List<String> dateList;
  final Function(int index) deleteMessage;

  const MessagesTwo({
    Key key,
    this.conversationReference,
    this.myId,
    this.isDark,
    this.isFrench,
    this.isInit,
    this.contactId,
    this.chatDocs,
    this.deleteMessage,
    this.isDateShowList,
    this.dateList,
  }) : super(key: key);

  @override
  MessagesTwoState createState() => MessagesTwoState();
}

class MessagesTwoState extends State<MessagesTwo> {
  int indexDeleting;

  List<QueryDocumentSnapshot> chatDocs;

  @override
  Widget build(BuildContext context) {
    bool isAutoChat = (widget.myId == widget.contactId);

    chatDocs = widget.chatDocs;

    return ListView.builder(
      reverse: true,
      itemCount: chatDocs.length,
      itemBuilder: (ctx, index) {
        return MessageBubble(
          message: chatDocs[index]['content'],
          isMe: chatDocs[index]['senderId'] == widget.myId,
          autoConversation: isAutoChat,
          isDark: widget.isDark,
          isFrench: widget.isFrench,
          keyMessage: ValueKey(chatDocs[index].id),
          //isDateShow: false,
          //dateTimeFormatted: '',
          isDateShow: (!widget.isInit) ? widget.isDateShowList[index] : false,
          dateTimeFormatted: (!widget.isInit) ? widget.dateList[index] : '',
          deleteMessage: widget.deleteMessage,
          index: index,
        );
      },
    );
  }
}
