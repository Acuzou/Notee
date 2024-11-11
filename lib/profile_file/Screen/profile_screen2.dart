import 'package:cuzou_app/main_switch.dart';
import 'package:flutter/material.dart';
import '../../general_widget/data_widget.dart';
import '../Widget/modify_info.dart';
import 'dart:io';
import 'package:cuzou_app/research_file/Data/general_data.dart';
import 'package:cuzou_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuzou_app/authentication_file/Data/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen2 extends StatefulWidget {
  QueryDocumentSnapshot userData;
  bool isDark;
  bool isFrench;
  Color colorAppBar;

  ProfileScreen2({
    Key key,
    this.userData,
    this.isDark,
    this.isFrench,
    this.colorAppBar,
  }) : super(key: key);

  @override
  State<ProfileScreen2> createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2> {
  bool isDefaultProfilPhoto = false;
  bool isHovering = false;
  bool isProfileScreen = true;

  bool isDark;
  bool isFrench;
  Color colorAppBar;

  @override
  void initState() {
    super.initState();

    isDark = widget.isDark;
    isFrench = widget.isFrench;
    colorAppBar = widget.colorAppBar;
  }

  Future<NetworkImage> getImage(String profilPictureUrl) async {
    return NetworkImage(profilPictureUrl);
  }

  void _keepDefaultImage() async {
    //final pickedImageFile = File('assets/images/logos/logo_profile.png')

    // var bytes = await rootBundle.load('assets/images/logos/logo_profile.png');
    // String tempPath = (await getTemporaryDirectory()).path;
    // File file = File('$tempPath/logo_profile.png');
    // await file.writeAsBytes(
    //     bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    // File pickedImageFile = file;

    setState(() {
      isDefaultProfilPhoto = true;
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 500,
    );

    if (pickedImage != null) {
      _updateData(File(pickedImage.path));

      isDefaultProfilPhoto = false;
    }
  }

  void _updateData(
    File profilePictureFile,
  ) async {
    FocusScope.of(context).unfocus();

    User auth = FirebaseAuth.instance.currentUser;

    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('${auth.uid}.jpg');

    await ref.putFile(profilePictureFile);

    final imageShopUrl = await ref.getDownloadURL();
    //updateData(_profilePictureFile);
    await FirebaseFirestore.instance.collection('users').doc(auth.uid).update({
      'profilPictureUrl': imageShopUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    double radius = height * 0.11;

    String firstName = widget.userData['firstname'];
    String lastName = widget.userData['lastname'];
    String profilPictureUrl = widget.userData['profilPictureUrl'];
    int cityId = widget.userData['cityId'];
    String cityName = getCityName(cityList[cityId]);
    String emailAdress = widget.userData['email'];
    int phoneNumber = widget.userData['phoneNumber'];

    return Scaffold(
      backgroundColor: primaryColor(isDark),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: shadeColor(colorAppBar, 0.1),
        title: Text(isFrench ? 'Mon Profil' : 'My Profile'),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
            height: height * 0.9,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.08,
                ),

                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: width * 0.02,
                      ),
                      SizedBox(
                        height: radius * 2 + 6,
                        width: radius * 2 + 6,
                        child: FutureBuilder(
                            future: getImage(profilPictureUrl),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                //if (snapshot.hasData) {
                                return drawerHeader(radius, isDark, false,
                                    colorAppBar, snapshot.data);
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: height * 0.04),
                            child: TextButton.icon(
                              onPressed: _pickImage,
                              icon: Icon(Icons.image,
                                  color: secondaryColor(!isDark, colorAppBar)),
                              label: Text(
                                isFrench ? 'Changer d\'image' : 'Change image',
                                style: TextStyle(
                                  color: secondaryColor(!isDark, colorAppBar),
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
                                  width: 1,
                                  color: secondaryColor(!isDark, colorAppBar),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.02),
                            width: width * 0.5,
                            child: TextButton.icon(
                              onPressed: _keepDefaultImage,
                              icon: Icon(Icons.person,
                                  color: secondaryColor(!isDark, colorAppBar)),
                              label: Text(
                                isFrench ? 'Supprimer Photo' : 'Delete Photo',
                                style: TextStyle(
                                  color: secondaryColor(!isDark, colorAppBar),
                                  fontSize: 15,
                                ),
                                softWrap: true,
                              ),
                              // style: TextButton.styleFrom(
                              //   padding: const EdgeInsets.only(
                              //     left: 20,
                              //     right: 20,
                              //     top: 15,
                              //     bottom: 15,
                              //   ),
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(20)),
                              //   side: BorderSide(
                              //     width: 4,
                              //     color: (!isDefaultProfilPhoto)
                              //         ? primaryColor(isDark)
                              //         : colorAppBar,
                              //   ),
                              //),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //Coordonnee User
                Flexible(
                  flex: 7,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: width * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  bottom: 5, top: 10, right: 10),
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: colorAppBar,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: <Widget>[
                                  //UserName
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Palette.secondary,
                                            width: 3,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              isFrench
                                                  ? 'Nom d\'usage :'
                                                  : 'Username : ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Palette.secondary,
                                                fontFamily: 'RebondGrotesque',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '$firstName $lastName',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Palette.secondary,
                                                fontSize: 20,
                                                fontFamily: 'RebondGrotesque',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  //Ville Par Défault
                                  Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Palette.secondary,
                                            width: 3,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              isFrench
                                                  ? 'Localisation : '
                                                  : 'Location : ',
                                              style: TextStyle(
                                                color: Palette.secondary,
                                                fontFamily: 'RebondGrotesque',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              cityName,
                                              style: TextStyle(
                                                color: Palette.secondary,
                                                fontSize: 20,
                                                fontFamily: 'RebondGrotesque',
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  //Email Adress
                                  Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Palette.secondary,
                                            width: 3,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              isFrench
                                                  ? 'Adresse Email :'
                                                  : 'Email Address : ',
                                              style: TextStyle(
                                                color: Palette.secondary,
                                                fontFamily: 'RebondGrotesque',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              emailAdress,
                                              style: TextStyle(
                                                color: Palette.secondary,
                                                fontSize: 19,
                                                fontFamily: 'RebondGrotesque',
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Phone Number
                                  Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Palette.secondary,
                                            width: 3,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              isFrench
                                                  ? 'Téléphone :'
                                                  : 'Phone Number',
                                              style: TextStyle(
                                                color: Palette.secondary,
                                                fontFamily: 'RebondGrotesque',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                getPhoneNumberText(phoneNumber),
                                                style: TextStyle(
                                                  color: Palette.secondary,
                                                  fontSize: 20,
                                                  fontFamily: 'RebondGrotesque',
                                                ),
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: height * 0.05,
                        right: -5,
                        child: ElevatedButton(
                          onPressed: (() {
                            Navigator.of(context).pushNamed(
                              ModifyInfoAccount.routeName,
                              arguments: {
                                'isDark': isDark,
                                'isFrench': isFrench,
                                'colorAppBar': colorAppBar,
                                'userData': widget.userData,
                              },
                            );
                            setState(() {
                              isProfileScreen = false;
                            });
                          }),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: colorAppBar,
                            padding: const EdgeInsets.all(10),
                            shape: const CircleBorder(),
                            side: BorderSide(
                              width: 1,
                              color: secondaryColor(!isDark, colorAppBar),
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Palette.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
