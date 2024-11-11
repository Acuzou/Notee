import 'package:cuzou_app/authentication_file/Data/user_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'galeryShop.dart';

// ignore: must_be_immutable
class ModifyPhotoShop extends StatefulWidget {
  static const routeName = "/modify-shop";

  const ModifyPhotoShop({Key key}) : super(key: key);

  @override
  State<ModifyPhotoShop> createState() => _ModifyPhotoShopState();
}

class _ModifyPhotoShopState extends State<ModifyPhotoShop> {
  User auth = FirebaseAuth.instance.currentUser;
  int photoIndex = 0;
  int galeryLength;
  List<QueryDocumentSnapshot> galeryDocs;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 1000,
    );

    if (pickedImage != null) {
      _addPhoto(File(pickedImage.path));
    }
  }

  void _addPhoto(
    File shopPictureFile,
  ) async {
    FocusScope.of(context).unfocus();

    int imageId = 0;

    var dataSnapshot = await FirebaseFirestore.instance
        .collection('shops')
        .doc(auth.uid)
        .collection('galery')
        .get();

    if (dataSnapshot.docs.isNotEmpty) {
      imageId = generatePrimaryKeyFromPhotoShop(dataSnapshot.docs);
    }

    final ref = FirebaseStorage.instance
        .ref()
        .child('shop_image')
        .child('${auth.uid}$imageId.jpg');

    await ref.putFile(shopPictureFile);

    final imageShopUrl = await ref.getDownloadURL();
    //updateData(_profilePictureFile);
    FirebaseFirestore.instance
        .collection('shops')
        .doc(auth.uid)
        .collection('galery')
        .doc('$imageId')
        .set({
      'shopPictureUrl': imageShopUrl,
      'imageId': imageId,
    });
    setState(() {});
    //Navigator.of(context).pop();
  }

  void deleteImage(int imageId, int indexImage) async {
    User auth = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('shops/${auth.uid}/galery')
        .doc('$imageId')
        .delete();

    if (indexImage == 0) {
      var galerySnapshot = await FirebaseFirestore.instance
          .collection('shops/${auth.uid}/galery')
          .get();

      List<QueryDocumentSnapshot> galeryDocs = galerySnapshot.docs;

      await FirebaseFirestore.instance
          .collection('shops')
          .doc(auth.uid)
          .update({
        'shopPictureUrl': galeryDocs[0]['shopPictureUrl'],
      });
    }

    setState(() {});
  }

  void setIndex(currentIndex) {
    photoIndex = currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final bool isFrench = routeArgs['isFrench'];
    final bool isDark = routeArgs['isDark'];
    final Color colorAppBar = routeArgs['colorAppBar'];
    final QueryDocumentSnapshot shopData = routeArgs['shopData'];

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('shops')
            .doc(auth.uid)
            .collection('galery')
            .snapshots(),
        builder: (context, photoSnapshot) {
          if (photoSnapshot.hasError) {
            const Text('Something went wrong.');
          }
          if (photoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          galeryDocs = photoSnapshot.data.docs;

          galeryLength = galeryDocs.length;

          //String _profilPictureUrl = shopData['shopPictureUrl'];

          return Scaffold(
            backgroundColor: primaryColor(isDark),
            extendBody: true,
            appBar: AppBar(
              backgroundColor: shadeColor(colorAppBar, 0.1),
              title:
                  Text(isFrench ? 'Modification photo' : 'Image modification'),
              actions: <Widget>[
                IconButton(
                  icon: const ImageIcon(
                    AssetImage("assets/images/logos/logo_notee/icon_noir.png"),
                    size: 120,
                  ),
                  tooltip: 'Home Page',
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MainScreen.routeName,
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                //Image Uploader
                Column(children: [
                  Stack(
                    children: [
                      GaleryShop(
                        shopData: shopData,
                        width: width,
                        height: height,
                        isDark: isDark,
                        setIndex: setIndex,
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: ElevatedButton(
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
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: Text(
                                      isFrench
                                          ? 'Êtes-vous sûr de vouloir supprimer cette image ?'
                                          : 'Are you sure to delete this picture ?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Palette.orange,
                                        fontFamily: 'RebondGrotesque',
                                        fontSize: 22,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 30,
                                        top: 50),
                                    backgroundColor:
                                        tintColor(Palette.black, 0.01),
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
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                                if (galeryLength == 1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(isFrench
                                                          ? 'Chaque magasin doit au moins avoir une photo.'
                                                          : 'Each shop must have at least one picture.'),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .errorColor,
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                } else {
                                                  deleteImage(
                                                      galeryDocs[photoIndex]
                                                          ['imageId'],
                                                      photoIndex);
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: colorAppBar,
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
                        ),
                      ),
                    ],

                    //),
                  ),
                ]),
                const SizedBox(height: 50),

                //Return and Validate Button
                //Return Button
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: width * 0.5,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: colorAppBar,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 15,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          side: BorderSide(
                            width: 1,
                            color: secondaryColor(!isDark, colorAppBar),
                          ),
                        ),
                        //child: Container(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(Icons.image, color: Palette.black),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              isFrench ? 'Ajouter Image' : 'Add Image',
                              style: TextStyle(
                                color: Palette.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RebondGrotesque',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    //Validate Button
                    SizedBox(
                      width: width * 0.4,
                      child: ElevatedButton(
                        onPressed: () {
                          //_updateData(context, _shopPictureFile);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: colorAppBar,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 15,
                          ),
                          side: BorderSide(
                            width: 1,
                            color: secondaryColor(!isDark, colorAppBar),
                          ),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          isFrench ? '    Valider    ' : '    Validate    ',
                          style: TextStyle(
                            color: Palette.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RebondGrotesque',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                )
              ],
            ),
          );
        });
  }
}
