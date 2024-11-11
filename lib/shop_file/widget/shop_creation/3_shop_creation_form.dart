// ignore_for_file: file_names

import 'package:cuzou_app/authentication_file/widget/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import 'dart:io';

class ShopCreationFormThree extends StatefulWidget {
  final bool isLoading;
  final bool isDark;
  final bool isFrench;
  final void Function(
    File imageFile,
  ) savePageThree;

  final void Function(int index) setPage;

  const ShopCreationFormThree(this.isLoading, this.isDark, this.isFrench,
      this.savePageThree, this.setPage,
      {Key key})
      : super(key: key);

  @override
  ShopCreationFormThreeState createState() => ShopCreationFormThreeState();
}

class ShopCreationFormThreeState extends State<ShopCreationFormThree> {
  final _formKey = GlobalKey<FormState>();

  // ignore: prefer_typing_uninitialized_variables
  var _shopImageFile;

  void _pickedImage(File image) {
    _shopImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_shopImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isFrench
              ? 'Ajouter une image s\'il vous plait !'
              : 'Please, add a image !'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      //Enlever le trim pour tester les erreurs
      widget.savePageThree(
        _shopImageFile,
      );
      //widget.setPage(3);
      widget.setPage(2);
    }

    //Use those values to send our auth request ...
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: width * 0.80,
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //SubCatList

                //Image Uploader
                UserImagePicker(
                  isProfilPhoto: false,
                  imagePickFn: _pickedImage,
                  initialImage: 'creation_compte',
                  isFrench: widget.isFrench,
                ),

                const SizedBox(height: 14.2),

                if (widget.isLoading)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Return Button
                      Flexible(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.setPage(0);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            backgroundColor: Palette.orange,
                            padding: const EdgeInsets.all(11),
                            shape: const CircleBorder(),
                            side: BorderSide(
                              width: 1,
                              color: secondaryColor(
                                  !widget.isDark, Palette.orange),
                            ),
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
                            _trySubmit();
                            //widget.setPage(2);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            backgroundColor: Palette.orange,
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 15,
                              bottom: 15,
                            ),
                            shape: const StadiumBorder(),
                            side: BorderSide(
                              width: 1,
                              color: secondaryColor(
                                  !widget.isDark, Palette.orange),
                            ),
                          ),
                          child: Text(
                            widget.isFrench
                                ? '      Continuer      '
                                : '      Continue      ',
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
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle_outlined,
                        size: 10, color: Palette.orange),
                    Icon(Icons.circle, size: 15, color: Palette.orange),
                    Icon(
                      Icons.circle_outlined,
                      size: 10,
                      color: Palette.orange,
                    ),
                    Icon(Icons.circle_outlined,
                        size: 10, color: Palette.orange),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
