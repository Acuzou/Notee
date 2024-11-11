import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import '../widget/image_picker.dart';
import 'package:date_format/date_format.dart';
import 'dart:io';

class PublicationNews2 extends StatelessWidget {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  Color colorAppBar;
  bool isDark;
  bool isFrench;
  bool hasImage;
  File imageNewsFile;
  Function(File image) pickedImage;
  Function(DateTime dateNews, String titleNews, String content) submitData;

  PublicationNews2({
    Key key,
    this.colorAppBar,
    this.isDark,
    this.isFrench,
    this.pickedImage,
    this.submitData,
    this.hasImage,
    this.imageNewsFile,
  }) : super(key: key);

  final DateTime _dateNews = DateTime.now();

  String _titleNews = "";
  String _content = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? tintColor(Palette.black, 0.1) : Palette.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: height * 0.85,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  right: height * 0.01,
                  top: height * 0.01,
                  bottom: height * 0.01),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: primaryColor(!isDark),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  right: BorderSide(
                    color: primaryColor(!isDark),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 8,
                    child: TextField(
                      controller: _controller1,
                      keyboardAppearance:
                          isDark ? Brightness.dark : Brightness.light,
                      style: TextStyle(
                        color: primaryColor(!isDark),
                        fontFamily: 'RebondGrotesque',
                        fontSize: 18,
                        height: 1,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),

                        fillColor: isDark
                            ? tintColor(Palette.black, 0.1)
                            : shadeColor(Palette.white, 0.1),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: shadeColor(Palette.orange, 0.4),
                              width: 3.0),
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10),
                        //   borderSide: BorderSide(
                        //       color: Palette.orange, width: 2.0),
                        // ),
                        hintText: '...',
                        hintStyle: TextStyle(
                          color: primaryColor(!isDark),
                          fontFamily: 'RebondGrotesque',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        labelText: isFrench ? 'Titre' : 'Title',
                        labelStyle: TextStyle(
                          color: primaryColor(!isDark),
                          fontFamily: 'RebondGrotesque',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (value) {
                        _titleNews = value;
                      },
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Column(
                      children: [
                        Text(
                          formatDate(
                            _dateNews,
                            [HH, ':', nn],
                          ),
                          style: TextStyle(
                            color: primaryColor(!isDark),
                          ),
                        ),
                        Text(
                          formatDate(
                            _dateNews,
                            [d, ' ', MM, ' '],
                          ),
                          style: TextStyle(
                            color: primaryColor(!isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    //15 lignes max d'écriture
                    TextField(
                      controller: _controller2,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      keyboardAppearance:
                          isDark ? Brightness.dark : Brightness.light,
                      style: TextStyle(
                        color: primaryColor(!isDark),
                        fontFamily: 'RebondGrotesque',
                        fontSize: 18,
                        height: 1,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),

                        fillColor: isDark
                            ? tintColor(Palette.black, 0.1)
                            : shadeColor(Palette.white, 0.1),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: shadeColor(Palette.orange, 0.4),
                              width: 3.0),
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10),
                        //   borderSide:
                        //       BorderSide(color: Palette.orange, width: 2.0),
                        // ),

                        hintText: '...',
                        hintStyle: TextStyle(
                          color: primaryColor(!isDark),
                          fontFamily: 'RebondGrotesque',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        labelText: isFrench ? 'Contenu' : 'Content',
                        labelStyle: TextStyle(
                          color: primaryColor(!isDark),
                          fontFamily: 'RebondGrotesque',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (value) {
                        _content = value;
                      },
                    ),
                    hasImage
                        ? ClipRect(
                            child: Container(
                              height: 275,
                              width: width * 0.9,
                              margin: EdgeInsets.only(top: height * 0.01),
                              decoration: BoxDecoration(
                                color: Palette.orange,
                                image: DecorationImage(
                                    image: FileImage(imageNewsFile),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            Container(
              // margin: EdgeInsets.only(top: height * 0.01),
              padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: ImagePickerWidget(
                        isNewsPhoto: true,
                        imagePickFn: pickedImage,
                        isDark: isDark,
                        colorAppBar: colorAppBar,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor(!isDark),
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      //color: shadeColor(Palette.blue, 0.5),
                      disabledColor: shadeColor(colorAppBar, 0.4),
                      color:
                          isDark ? colorAppBar : shadeColor(colorAppBar, 0.6),
                      iconSize: 30,
                      icon: const Icon(
                        Icons.send,
                      ),
                      splashColor: shadeColor(Palette.grey, 0.2),
                      splashRadius: 30,
                      //Color when the IconButton is pressed
                      highlightColor: isDark
                          ? shadeColor(colorAppBar, 0.2)
                          : shadeColor(colorAppBar, 0.4),
                      onPressed: () {
                        submitData(
                          _dateNews,
                          _titleNews,
                          _content,
                        );

                        _controller1.clear();
                        _controller2.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
