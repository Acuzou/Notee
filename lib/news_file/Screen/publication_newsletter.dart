// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import '../../research_file/Data/data_function.dart';
import 'package:cuzou_app/authentication_file/Data/user_data.dart';
import 'publication_newsletter2.dart';

class PublicationNews extends StatefulWidget {
  static const routeName = "/publication_news";

  const PublicationNews({Key key}) : super(key: key);

  @override
  PublicationNewsState createState() => PublicationNewsState();
}

class PublicationNewsState extends State<PublicationNews> {
  String _imageNewsUrl = 'No image';
  File _imageNewsFile;
  int _shopId;
  String _titleShop;
  bool hasImage = false;
  bool _isDark;
  bool _isFrench;

  QueryDocumentSnapshot _shopData;

  void _pickedImage(File image) {
    setState(() {
      _imageNewsFile = image;
      hasImage = true;
    });
  }

  void _submitData(
    DateTime dateNews,
    String titleNews,
    String content,
  ) async {
    FocusScope.of(context).unfocus();

    if (titleNews != "") {
      try {
        dynamic shopsSnapshot =
            await FirebaseFirestore.instance.collection('shops').get();
        List<QueryDocumentSnapshot> shopsDocs = shopsSnapshot.docs;

        User auth = FirebaseAuth.instance.currentUser;

        var dataNews = await FirebaseFirestore.instance
            .collection('shops')
            .doc(auth.uid)
            .collection('news')
            .get();

        int newsId = generatePrimaryKeyFromNewsShop(dataNews.docs);

        if (!(_imageNewsFile == null)) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('news_image')
              .child('shop_${_shopId}_news_$newsId.jpg');

          await ref.putFile(_imageNewsFile);

          _imageNewsUrl = await ref.getDownloadURL();
        }

        await FirebaseFirestore.instance
            .collection('shops')
            .doc(auth.uid)
            .collection('news')
            .add({
          'titleNews': titleNews,
          'titleShop': _titleShop,
          'shopId': _shopId,
          'createdAt': dateNews,
          'content': content,
          'imageNewsUrl': _imageNewsUrl,
          'newsId': newsId,
        });

        await FirebaseFirestore.instance
            .collection('shops')
            .doc(_shopData.id)
            .update({'nbPublications': _shopData['nbPublications'] + 1});

        double rate = getRate(
            _shopData['nbPublications'],
            _shopData['nbFavorites'],
            _shopData['meanResponseTime'].toDouble(),
            _shopData['subCatId'],
            shopsDocs);

        await FirebaseFirestore.instance
            .collection('shops')
            .doc(_shopData.id)
            .update({'rate': rate});

        Navigator.of(context).pop();
      } on PlatformException catch (err) {
        var message = 'An error occured, pleased check your credentials !';

        if (err.message != null) {
          message = err.message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Veulliez remplir votre publication !"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final Color colorAppBar = routeArgs['colorAppBar'] as Color;
    _isDark = routeArgs['isDark'] as bool;
    _isFrench = routeArgs['isFrench'] as bool;
    _shopData = routeArgs['shopData'];
    _shopId = routeArgs['shopId'] as int;
    _titleShop = routeArgs['title'] as String;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor(_isDark),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: shadeColor(colorAppBar, 0.1),
        title: Text(
          _isFrench ? 'Publication Journal' : 'Newspaper Publication',
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
        child: PublicationNews2(
          colorAppBar: colorAppBar,
          isDark: _isDark,
          isFrench: _isFrench,
          pickedImage: _pickedImage,
          submitData: _submitData,
          hasImage: hasImage,
          imageNewsFile: _imageNewsFile,
        ),
      ),
    );
  }
}
