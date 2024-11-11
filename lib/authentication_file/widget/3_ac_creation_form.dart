// ignore_for_file: file_names

import 'package:cuzou_app/main.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cuzou_app/authentication_file/widget/user_image_picker.dart';

class AccountCreationFormThree extends StatefulWidget {
  //Pointe vers _submitAuthForm
  final bool isLoading;
  final bool isDark;
  final bool isFrench;
  final void Function(File photo) savePageThree;

  final File profilePhoto;

  final void Function(int index) setPage;

  const AccountCreationFormThree({
    Key key,
    this.isLoading,
    this.isDark,
    this.isFrench,
    this.savePageThree,
    this.setPage,
    this.profilePhoto,
  }) : super(key: key);

  @override
  AccountCreationFormThreeState createState() =>
      AccountCreationFormThreeState();
}

class AccountCreationFormThreeState extends State<AccountCreationFormThree> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  File _profilImageFile;

  @override
  void initState() {
    if (widget.profilePhoto != null) {
      _profilImageFile = widget.profilePhoto;
    }

    super.initState();
  }

  void _pickedImage(File image) {
    _profilImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_profilImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ajouter une image s\'il vous plait !'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      //Enlever le trim pour tester les erreurs
      widget.savePageThree(
        _profilImageFile,
      );
      widget.setPage(3);
    }

    //Use those values to send our auth request ...
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: primaryColor(widget.isDark),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 10, right: 10, bottom: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //SubCatList
                  const SizedBox(height: 40),

                  //Image Uploader
                  UserImagePicker(
                    isProfilPhoto: true,
                    imagePickFn: _pickedImage,
                    initialImage: 'creation_compte',
                    isFrench: widget.isFrench,
                    isDark: widget.isDark,
                  ),

                  const SizedBox(height: 56),

                  if (widget.isLoading)
                    const CircularProgressIndicator()
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Return Button
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.setPage(1);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.orange,
                              padding: const EdgeInsets.all(11),
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        //Continuer Button
                        Flexible(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: () {
                              _trySubmit();
                              //widget.setPage(3);
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
                              widget.isFrench
                                  ? 'Continuer inscription'
                                  : 'Continue registration',
                              style: TextStyle(
                                color: Palette.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        size: 10,
                        color: secondaryColor(!widget.isDark, Palette.orange),
                      ),
                      Icon(
                        Icons.circle_outlined,
                        size: 10,
                        color: secondaryColor(!widget.isDark, Palette.orange),
                      ),
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: secondaryColor(!widget.isDark, Palette.orange),
                      ),
                      Icon(
                        Icons.circle_outlined,
                        size: 10,
                        color: secondaryColor(!widget.isDark, Palette.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
