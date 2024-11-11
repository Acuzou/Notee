import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/message_file/widget/triangle_paint.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final Key keyMessage;
  final String message;
  final bool isMe;
  final bool autoConversation;
  final bool isDark;
  final bool isFrench;
  final bool isDateShow;
  final String dateTimeFormatted;
  final int index;
  final Function(int index) deleteMessage;

  const MessageBubble({
    Key key,
    this.message,
    this.isMe,
    this.autoConversation,
    this.isDark,
    this.keyMessage,
    this.isDateShow,
    this.dateTimeFormatted,
    this.isFrench,
    this.index,
    this.deleteMessage,
  }) : super(key: key);

  @override
  MessageBubbleState createState() => MessageBubbleState();
}

class MessageBubbleState extends State<MessageBubble> {
  bool showDeleteButton = false;
  bool isDark;
  bool isFrench;
  bool isMe;
  bool isDateShow;
  String dateTimeFormatted;
  String message;
  int indexLongPress = 0;

  @override
  void initState() {
    isDark = widget.isDark;
    isFrench = widget.isFrench;
    isMe = widget.isMe;
    message = widget.message;
    isDateShow = widget.isDateShow;
    dateTimeFormatted = widget.dateTimeFormatted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double width = size.width;

    return Stack(
      children: [
        GestureDetector(
          onLongPress: () {
            if (isMe) {
              setState(() {
                indexLongPress += 1;

                if (indexLongPress % 2 == 0) {
                  showDeleteButton = false;
                } else {
                  showDeleteButton = true;
                }
              });
            }
          },
          child: (widget.autoConversation)
              ? Column(
                  children: <Widget>[
                    isDateShow
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              // formatDate(
                              //   createdAt,
                              //   [HH, ':', nn],
                              // ),
                              dateTimeFormatted,
                              style: TextStyle(
                                color: primaryColor(!isDark),
                                fontFamily: 'RebondGrotesque',
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: isMe ? width * 0.25 : 0,
                        ),
                        Flexible(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? shadeColor(
                                          (showDeleteButton)
                                              ? Palette.blue
                                              : Palette.pink,
                                          0.1)
                                      : isDark
                                          ? shadeColor(Palette.grey, 0.9)
                                          : shadeColor(Palette.grey, 0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20),
                                    bottomLeft: isMe
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                    bottomRight: !isMe
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                  ),
                                ),
                                //width: width / 1.618,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: isMe
                                        ? Palette.black
                                        : primaryColor(!isDark),
                                    fontSize: 20,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              isMe
                                  ? Positioned(
                                      bottom: 4,
                                      right: 12,
                                      child: CustomPaint(
                                        painter: ChatBubbleTriangle(
                                            isMe, isDark, showDeleteButton),
                                      ))
                                  : Positioned(
                                      bottom: 4,
                                      left: 12,
                                      child: CustomPaint(
                                        painter: ChatBubbleTriangle(
                                            isMe, isDark, showDeleteButton),
                                      ))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: !isMe ? width * 0.25 : 0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: !isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: !isMe ? width * 0.25 : 0,
                        ),
                        Flexible(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: !isMe
                                      ? shadeColor(
                                          (showDeleteButton)
                                              ? Palette.blue
                                              : Palette.pink,
                                          0.1)
                                      : isDark
                                          ? shadeColor(Palette.grey, 0.9)
                                          : shadeColor(Palette.grey, 0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20),
                                    bottomLeft: !isMe
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                    bottomRight: isMe
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                  ),
                                ),
                                //width: width / 1.618,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: isMe
                                        ? primaryColor(!isDark)
                                        : Palette.black,
                                    fontSize: 20,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              !isMe
                                  ? Positioned(
                                      bottom: 4,
                                      right: 12,
                                      child: CustomPaint(
                                        painter: ChatBubbleTriangle(
                                            !isMe, isDark, showDeleteButton),
                                      ))
                                  : Positioned(
                                      bottom: 4,
                                      left: 12,
                                      child: CustomPaint(
                                        painter: ChatBubbleTriangle(
                                            !isMe, isDark, showDeleteButton),
                                      ))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: isMe ? width * 0.25 : 0,
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    isDateShow
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              // formatDate(
                              //   createdAt,
                              //   [HH, ':', nn],
                              // ),
                              dateTimeFormatted,
                              style: TextStyle(
                                color: primaryColor(!isDark),
                                fontFamily: 'RebondGrotesque',
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: isMe ? width * 0.25 : 0,
                        ),
                        Flexible(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? shadeColor(
                                          (showDeleteButton)
                                              ? Palette.blue
                                              : Palette.pink,
                                          0.1)
                                      : isDark
                                          ? shadeColor(Palette.grey, 0.9)
                                          : shadeColor(Palette.grey, 0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20),
                                    bottomLeft: isMe
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                    bottomRight: !isMe
                                        ? const Radius.circular(20)
                                        : const Radius.circular(0),
                                  ),
                                ),
                                //width: width / 1.618,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: isMe
                                        ? Palette.black
                                        : primaryColor(!isDark),
                                    fontSize: 20,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              isMe
                                  ? Positioned(
                                      bottom: 4,
                                      right: 12,
                                      child: CustomPaint(
                                        painter: ChatBubbleTriangle(
                                            isMe, isDark, showDeleteButton),
                                      ))
                                  : Positioned(
                                      bottom: 4,
                                      left: 12,
                                      child: CustomPaint(
                                        painter: ChatBubbleTriangle(
                                            isMe, isDark, showDeleteButton),
                                      ))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: !isMe ? width * 0.25 : 0,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
        (showDeleteButton)
            ? Positioned(
                bottom: 0,
                left: 30,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: Text(
                              isFrench
                                  ? 'Êtes-vous sûr de vouloir supprimer votre message ?'
                                  : 'Are you sure to delete your message ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Palette.orange,
                                fontFamily: 'RebondGrotesque',
                                fontSize: 22,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 30, top: 50),
                            backgroundColor: tintColor(Palette.black, 0.01),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //Return Button
                                  Flexible(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Palette.orange,
                                        padding: const EdgeInsets.all(10),
                                        shape: const CircleBorder(),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back,
                                        size: 30,
                                      ),
                                    ),
                                  ),

                                  //Continuer Button
                                  Flexible(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.deleteMessage(widget.index);
                                        showDeleteButton = false;
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Palette.orange,
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 15,
                                        ),
                                        shape: const StadiumBorder(),
                                      ),
                                      child: Text(
                                        isFrench ? 'Valider' : 'Accept',
                                        style: TextStyle(
                                          color: Palette.secondary,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'RebondGrotesque',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: shadeColor(Palette.blue, 0.2),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: Icon(
                    Icons.delete,
                    size: 30,
                    color: Palette.black,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
