import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  final bool isProfilPhoto;
  final String initialImage;
  final bool isFrench;
  final bool isDark;

  const UserImagePicker({
    Key key,
    this.isProfilPhoto,
    this.imagePickFn,
    this.initialImage,
    this.isFrench,
    this.isDark,
  }) : super(key: key);
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  bool isDefaultProfilPhoto;

  @override
  void initState() {
    super.initState();
    if (widget.initialImage == 'creation_compte') {
      isDefaultProfilPhoto = false;
    } else {
      isDefaultProfilPhoto = true;
    }
  }

  void _keepDefaultImage() async {
    //final pickedImageFile = File('assets/images/logos/logo_profile.png')

    var bytes = await rootBundle.load('assets/images/logos/logo_profile.png');
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/logo_profile.png');
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    File pickedImageFile = file;

    widget.imagePickFn(pickedImageFile);
    setState(() {
      _pickedImage = pickedImageFile;
      isDefaultProfilPhoto = true;
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: (widget.isProfilPhoto) ? 70 : 100,
      maxWidth: (widget.isProfilPhoto) ? 700 : 1000,
    );

    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);

      widget.imagePickFn(pickedImageFile);
      setState(() {
        isDefaultProfilPhoto = false;
        _pickedImage = pickedImageFile;
      });
    } else {
      _keepDefaultImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    double radius = 70;

    if ((!widget.isProfilPhoto)) {
      //Partie pour Photo magasin
      return Column(children: [
        Container(
          height: height * 0.35,
          width: width * 0.75,
          decoration: BoxDecoration(
            color: Palette.orange,
            image: DecorationImage(
                image: _pickedImage != null
                    ? FileImage(_pickedImage)
                    : (widget.initialImage == 'creation_compte')
                        ? const AssetImage(
                            "assets/images/logos/default_shop.png")
                        : NetworkImage(widget.initialImage),
                fit: BoxFit.cover),
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image, color: primaryColor(!widget.isDark)),
          label: Text(
            widget.isFrench ? 'Ajouter Image' : 'Add Image',
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(
              width: 2,
              color: secondaryColor(!widget.isDark, Palette.orange),
            ),
          ),
        ),
      ]);
    } else {
      //Partie photo de profil
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: radius + 4,
                backgroundColor: Palette.orange,
                child: CircleAvatar(
                  radius: radius,
                  backgroundColor: Palette.white,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage)
                      : (widget.initialImage == 'creation_compte')
                          ? const AssetImage(
                              "assets/images/logos/logo_profile.png")
                          : NetworkImage(widget.initialImage),
                ),
              ),
              SizedBox(
                width: width * 0.04,
              ),
              TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image, color: primaryColor(!widget.isDark)),
                label: Text(
                  widget.isFrench ? 'Ajouter Image' : 'Add Image',
                  style: TextStyle(
                    color: primaryColor(!widget.isDark),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(
                    width: 2,
                    color: secondaryColor(!widget.isDark, Palette.orange),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: (widget.initialImage == 'creation_compte')
                ? height * 0.025
                : height * 0.08,
          ),
          TextButton.icon(
            onPressed: _keepDefaultImage,
            icon: Icon(Icons.person, color: primaryColor(!widget.isDark)),
            label: Text(
              (widget.initialImage == 'creation_compte')
                  ? widget.isFrench
                      ? 'Conserver l\'image par défault'
                      : 'Keep default image'
                  : widget.isFrench
                      ? 'Reprendre l\'image par défault'
                      : 'Keep default image',
              style: TextStyle(
                color: primaryColor(!widget.isDark),
                fontSize: 16,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 15,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              side: BorderSide(
                width: 2,
                color: (isDefaultProfilPhoto)
                    ? secondaryColor(!widget.isDark, Palette.orange)
                    : secondaryColor(widget.isDark, Palette.orange),
              ),
            ),
          ),
        ],
      );
    }
  }
}
