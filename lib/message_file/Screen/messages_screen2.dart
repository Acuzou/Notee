import 'package:flutter/material.dart';
import 'package:cuzou_app/message_file/widget/messages.dart';
import 'package:cuzou_app/message_file/widget/new_message.dart';
import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageScreen2 extends StatefulWidget {
  final bool isDark;
  final bool isFrench;
  final String profilePhoto;
  final String contactName;
  final int contactId;
  final int myId;
  final bool isUserMerchant;
  final bool isContactMerchant;
  final String isUserIdIndexSaw;
  final QueryDocumentSnapshot conversationReference;

  const MessageScreen2({
    Key key,
    this.isDark,
    this.isFrench,
    this.profilePhoto,
    this.contactName,
    this.contactId,
    this.myId,
    this.conversationReference,
    this.isUserMerchant,
    this.isContactMerchant,
    this.isUserIdIndexSaw,
  }) : super(key: key);

  @override
  MessageScreenState2 createState() => MessageScreenState2();
}

class MessageScreenState2 extends State<MessageScreen2> {
  
  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    return Scaffold(
      backgroundColor: primaryColor(widget.isDark),
      appBar: AppBar(
        backgroundColor: shadeColor(Palette.pink, 0.1),
        title: Center(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Palette.pink,
                backgroundImage: widget.profilePhoto == 'Default_Profile_Photo'
                    ? const AssetImage('assets/images/logos/logo_profile.png')
                    : NetworkImage(widget.profilePhoto),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: width * 0.4,
                child: Text(
                  widget.contactName,
                  style: TextStyle(
                    color: Palette.black,
                    fontFamily: 'RebondGrotesque',
                    fontSize: 20,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const ImageIcon(
              AssetImage("assets/images/logos/logo_notee/icon_noir.png"),
              size: 120,
            ),
            tooltip: 'Home Page',
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainScreen.routeName, ((route) => false));
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      extendBody: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //MessageItem(messageSelectedd[index])

            //Flux de message
            Expanded(
              child: Messages(
                widget.conversationReference,
                widget.myId,
                widget.contactId,
                widget.isDark,
                widget.isFrench,
              ),
            ),

            //TextField pour nouveau message
            NewMessage(
              conversationReference: widget.conversationReference,
              myId: widget.myId,
              contactId: widget.contactId,
              isDark: widget.isDark,
              isFrench: widget.isFrench,
              isUserIdIndexSaw: widget.isUserIdIndexSaw,
              isUserMerchant: widget.isUserMerchant,
              isContactMerchant: widget.isContactMerchant,
              refreshPage: refreshPage,
            ),

            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
