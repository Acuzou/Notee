import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  final bool isNewsPhoto;
  final bool isDark;
  final Color colorAppBar;

  const ImagePickerWidget({
    Key key,
    this.isNewsPhoto,
    this.imagePickFn,
    this.isDark,
    this.colorAppBar,
  }) : super(key: key);
  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 1000,
    );

    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);

      widget.imagePickFn(pickedImageFile);
    }
    //  else {
    //   _keepDefaultImage();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: _pickImage,
      icon: Icon(Icons.image, color: primaryColor(!widget.isDark)),
      label: Text(
        'Ajouter Image',
        style: TextStyle(
          color: primaryColor(!widget.isDark),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'RebondGrotesque',
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 15,
          bottom: 15,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(
          width: 2,
          color: secondaryColor(!widget.isDark, widget.colorAppBar),
        ),
      ),
    );
  }
}
