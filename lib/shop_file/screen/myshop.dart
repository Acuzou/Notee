import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/shop_file/widget/galeryShop.dart';
import 'package:cuzou_app/news_file/Screen/news_shop.dart';
import 'package:cuzou_app/news_file/Screen/publication_newsletter.dart';
import 'package:cuzou_app/shop_file/screen/shop_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/shop_file/widget/coordonnee_item.dart';
import 'package:cuzou_app/shop_file/widget/schedule/my_schedule_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';
import 'package:cuzou_app/research_file/Model/coordonnee.dart';
import 'package:flutter/services.dart';
import '../widget/rate_chart.dart';
import '../widget/scoreSimpleDialog.dart';
import '../widget/modify_photo_shop.dart';
import '../widget/modify_shop_info.dart';

// ignore: must_be_immutable
class MyShop extends StatefulWidget {
  final int myId;
  final int shopId;
  final bool isDark;
  final bool isFrench;
  final Color color;

  const MyShop(
      {Key key, this.myId, this.shopId, this.isDark, this.isFrench, this.color})
      : super(key: key);

  @override
  MyShopState createState() => MyShopState();
}

class MyShopState extends State<MyShop> {
  bool isInfo;
  bool isFrench;
  bool isDark;
  Color color;
  int shopId;
  int myId;

  String _title;
  String _address;
  String _email;
  int _phoneNumber;
  int _cityId;
  int _subCatId;
  String _presentationContent;
  String _website;
  double _rate;

  //A adpater
  bool isOpen = true;

  @override
  void initState() {
    isFrench = widget.isFrench;
    isDark = widget.isDark;
    color = widget.color;
    shopId = widget.shopId;
    myId = widget.myId;
    isInfo = true;
    super.initState();
  }

  void setIndex(int index) {}

  void _deleteShop(context) async {
    try {
      User auth = FirebaseAuth.instance.currentUser;

      //Suppression dans le compte User
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.uid)
          .update({
        'isMerchant': false,
        'shopId': 0,
      });

      //Suppression dans les favories
      var userSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      //A verifier
      for (int i = 0; i < userSnapshot.docs.length; i++) {
        await FirebaseFirestore.instance
            .collection("users/${userSnapshot.docs[i].id}/favorite")
            .doc('$shopId')
            .delete();
      }

      //Suppression du magasin
      var shopSnapshot =
          await FirebaseFirestore.instance.collection("shops").get();
      var shop =
          shopSnapshot.docs.firstWhere((shop) => shop['shopId'] == shopId);

      await FirebaseFirestore.instance
          .collection("shops")
          .doc(shop.id)
          .delete();

      Navigator.of(context)
          .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('shops').snapshots(),
      builder: (context, shopSnapshot) {
        if (shopSnapshot.hasError) {
          const Text('Something went wrong.');
        }
        if (shopSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<QueryDocumentSnapshot> shopsDocs = shopSnapshot.data.docs;
        QueryDocumentSnapshot shopData =
            shopsDocs.firstWhere((shop) => shop['shopId'] == shopId);

        _title = shopData['title'];
        _address = shopData['address'];
        _email = shopData['email'];
        _phoneNumber = shopData['phoneNumber'];
        _cityId = shopData['cityId'];
        _subCatId = shopData['subCatId'];
        _presentationContent = shopData['presentationContent'];
        _website = shopData['website'];
        _rate = shopData['rate'].toDouble();
        //double _score = shopData['score'];

        Coordonnee coordonnee = Coordonnee(
          emailAddress: _email,
          geographicAddress: _address,
          phoneNumber: _phoneNumber,
          website: _website,
        );

        return SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: <Widget>[
              //Mettre plusieurs photos qui peuvent swiper horizontalement
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                    ),
                    child: RateChart(
                      shopDoc: shopData,
                      myId: myId,
                      sizeRate: 30,
                      isDark: isDark,
                      color: Palette.blue,
                      isUpdate: false,
                    ),
                  ),

                  //Mettre plusieurs photos qui peuvent swiper horizontalement
                ],
              ),

              GaleryShop(
                shopData: shopData,
                width: width,
                height: height,
                isDark: isDark,
                setIndex: setIndex,
              ),

              const SizedBox(
                height: 20,
              ),
              //Note Button
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: width * 0.45,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ScoreSimpleDialog(
                                      _rate, isDark, isFrench);
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              width: 1,
                              color: Palette.black,
                            ),
                            shape: const StadiumBorder(),
                            backgroundColor: color,
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.star),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                isFrench ? 'Note' : 'Grade',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'RebondGrotesque',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        width: width * 0.05,
                      ),

                      //Apercu
                      SizedBox(
                        height: 40,
                        width: width * 0.45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ShopDetailScreen.routeName,
                              arguments: {
                                'shopId': shopId,
                                'isFrench': isFrench,
                                'isDark': isDark,
                                'categoryColor': Palette.blue,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              width: 1,
                              color: Palette.black,
                            ),
                            shape: const StadiumBorder(),
                            backgroundColor: color,
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.remove_red_eye),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                isFrench ? 'Aperçu' : 'Overview',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'RebondGrotesque',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Delete Shop Button
                      SizedBox(
                        height: 40,
                        width: width * 0.45,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: Text(
                                      isFrench
                                          ? 'Êtes-vous sûr de vouloir supprimer votre magasin ?'
                                          : 'Are you sure to delete your store ?',
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
                                                _deleteShop(context);
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
                            side: BorderSide(
                              width: 1,
                              color: Palette.black,
                            ),
                            backgroundColor: color,
                            shape: const StadiumBorder(),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.edit),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                isFrench ? 'Supprimer' : 'Delete',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'RebondGrotesque',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      //Edit Button
                      SizedBox(
                        height: 40,
                        width: width * 0.45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                ModifyPhotoShop.routeName,
                                arguments: {
                                  'shopId': shopId,
                                  'isFrench': isFrench,
                                  'isDark': isDark,
                                  'shopData': shopData,
                                  'colorAppBar': color,
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              width: 1,
                              color: Palette.black,
                            ),
                            backgroundColor: color,
                            shape: const StadiumBorder(),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.photo),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                isFrench ? 'Photo' : 'Image',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'RebondGrotesque',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: width * 0.4,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: isDark
                              ? primaryColor(!isInfo)
                              : primaryColor(isInfo),
                        ),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isInfo = true;
                        });
                      },
                      child: Text(
                        'Infos',
                        style: TextStyle(
                          color: primaryColor(!isDark),
                          fontFamily: 'RebondGrotesque',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: isDark
                              ? primaryColor(isInfo)
                              : primaryColor(!isInfo),
                        ),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isInfo = false;
                        });
                      },
                      child: Text(
                        isFrench ? 'Journal' : 'Feed',
                        style: TextStyle(
                          color: primaryColor(!isDark),
                          fontFamily: 'RebondGrotesque',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              //Coordonnee And Horaire Item
              isInfo
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              width: width * 0.9,
                              child: Text(
                                _presentationContent,
                                style: TextStyle(
                                  color: secondaryColor(
                                    !isDark,
                                    color,
                                  ),
                                  fontSize: 18,
                                  fontFamily: 'RebondGrotesque',
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            CoordonneeItem(
                              coordonneeShop: coordonnee,
                              city: cityList[_cityId],
                              color: color,
                              isFrench: isFrench,
                              isDark: isDark,
                              isOpen: isOpen,
                              subCatId: _subCatId,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 5,
                              child: ElevatedButton(
                                onPressed: (() {
                                  Navigator.of(context).pushNamed(
                                    ModifyShopInfoAccount.routeName,
                                    arguments: {
                                      'isDark': isDark,
                                      'colorAppBar': color,
                                      'isFrench': isFrench,
                                      'postalAdress': _address,
                                      'emailAdress': _email,
                                      'website': _website,
                                      'phoneNumber': _phoneNumber,
                                      'cityId': _cityId,
                                      'subCatId': _subCatId,
                                    },
                                  );
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color,
                                  padding: const EdgeInsets.all(10),
                                  shape: const CircleBorder(),
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
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: height * 0.48,
                          child: MyScheduleView(
                            isModifiable: true,
                            color: color,
                            isFrench: isFrench,
                            isDark: isDark,
                          ),
                        ),
                        Text(
                          isFrench
                              ? 'Cliquez sur les horaires pour les modifier !'
                              : 'Click on schedule button to edit !',
                          style: TextStyle(
                            color: primaryColor(!isDark),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  : //Publication Button
                  Column(
                      children: [
                        Container(
                          width: 360,
                          height: 60,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                PublicationNews.routeName,
                                arguments: {
                                  'isDark': isDark,
                                  'colorAppBar': color,
                                  'shopId': shopId,
                                  'title': _title,
                                  'isFrench': isFrench,
                                  'shopData': shopData,
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              elevation: 10,
                              shape: const StadiumBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(Icons.edit),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  isFrench
                                      ? 'Publier dans le Journal'
                                      : 'Publish in the Feed',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //NewsShop
                        NewsShop(
                          isMyNews: true,
                          isDark: isDark,
                          isFrench: isFrench,
                          shopReference: shopData,
                          shopsDocs: shopsDocs,
                        )
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }
}
