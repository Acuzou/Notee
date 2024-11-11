import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/message_file/Screen/messages_screen.dart';
import 'package:cuzou_app/research_file/Model/coordonnee.dart';
import 'package:cuzou_app/research_file/Model/horaire.dart';
import 'package:cuzou_app/research_file/widget/favorite_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import '../widget/galeryShop.dart';
import '../widget/schedule/horaire_view.dart';
import '../widget/rate_chart.dart';
import '../widget/coordonnee_item.dart';
import '../../research_file/Model/shop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../research_file/Data/data_function.dart';
import '../../research_file/Data/general_data.dart';
import 'package:cuzou_app/news_file/Screen/news_shop.dart';

class ShopDetailScreen extends StatefulWidget {
  static const routeName = '/shop-detail';

  const ShopDetailScreen({Key key}) : super(key: key);

  @override
  ShopDetailScreenState createState() => ShopDetailScreenState();
}

class ShopDetailScreenState extends State<ShopDetailScreen> {
  bool favoriteState;
  bool isInfo;

  double myRating = 0;
  String contactName;
  String profilPictureUrl;
  int myId;
  Map<Jour, List<Heure>> horaire;
  bool isInit = true;
  bool isMerchant = false;

  @override
  // ignore: must_call_super
  void initState() {
    horaire = horaireExample.getHoraires();
    favoriteState = false;
    isInfo = true;
  }

  void _getInfo(int shopId, dynamic shopSelected) async {
    try {
      var auth = FirebaseAuth.instance.currentUser;
      var users = await FirebaseFirestore.instance.collection("users").get();

      final List<QueryDocumentSnapshot> usersDocs = users.docs;
      QueryDocumentSnapshot userShop =
          usersDocs.firstWhere((user) => user['shopId'] == shopId);

      // if (shopId != 0) {
      //   userShop = usersDocs.firstWhere((user) => user['shopId'] == shopId);
      // } else {
      //   userShop = usersDocs
      //       .firstWhere((user) => user['email'] == 'alexandrecuzou@gmail.com');
      // }

      QueryDocumentSnapshot me =
          usersDocs.firstWhere((user) => user['email'] == auth.email);

      var favoriteShop = await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.uid)
          .collection('favorite')
          .get();

      bool favState = false;
      for (int i = 0; i < favoriteShop.docs.length; i++) {
        if (favoriteShop.docs[i]['shopId'] == shopId) {
          favState = true;
        }
      }

      var horaireList = await FirebaseFirestore.instance
          .collection("shops")
          .doc(shopSelected.id)
          .collection('horaire')
          .get();

      setState(() {
        contactName = "${userShop['firstname']} ${userShop["lastname"]}";
        profilPictureUrl = userShop['profilPictureUrl'];
        myId = me['ID'];
        horaire = getHoraire(horaireList, false);
        favoriteState = favState;
        isInit = false;
        isMerchant = me['isMerchant'];
      });
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

  List<bool> dayClickedList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  //For coherent Object implementation
  void setIndex(int currentIndex) {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    final routeArg =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    final int shopId = routeArg['shopId'] as int;
    final bool isFrench = routeArg['isFrench'] as bool;
    final bool isDark = routeArg['isDark'] as bool;
    final Color categoryColor = routeArg['categoryColor'] as Color;

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
          print("TEST");
          print(shopId);
          print(isDark);
          print(isFrench);
          print("FIN TEST");

          final List<QueryDocumentSnapshot> shopsDocs = shopSnapshot.data.docs;
          QueryDocumentSnapshot shopSelected =
              shopsDocs.firstWhere((shop) => shop['shopId'] == shopId);

          // if (horaire == horaireExample.getHoraires()) {
          //   _getHoraire(shopSelected);
          // }

          //TEST si shopId = 0 existe toujours
          print("SUP TEST");

          if (isInit) {
            _getInfo(shopId, shopSelected);
          }

          Shop selectedShop = Shop(
            shopId: shopSelected['shopId'] as int,
            userSavId: shopSelected['userSavId'] as int,
            subCatId: shopSelected['subCatId'] as int,
            title: shopSelected['title'] as String,
            city: cityList[shopSelected['cityId'] as int],
            rate: shopSelected['rate'].toDouble(),
            imageUrl: shopSelected['shopPictureUrl'] as String,
            horaire: Horaire(horaire),
            coordonnee: Coordonnee(
              emailAddress: shopSelected['email'],
              geographicAddress: shopSelected['address'],
              phoneNumber: shopSelected['phoneNumber'],
              website: shopSelected['website'],
            ),
            isBan: false,
            presentationContent: shopSelected['presentationContent'],
          );

          bool shopOpen = openningBool(selectedShop);

          return Scaffold(
            backgroundColor: primaryColor(isDark),
            appBar: AppBar(
              backgroundColor: shadeColor(categoryColor, 0.1),
              title: Text(
                selectedShop.title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
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
            body: //RefreshIndicator(
                //onRefresh: _refresh,
                //child:
                SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 11,
                          child: RateChart(
                            shopDoc: shopSelected,
                            myId: myId,
                            sizeRate: 30,
                            isDark: isDark,
                            color: categoryColor,
                            isUpdate: true,
                          ),
                        ),

                        //Favorite Button
                        Flexible(
                          flex: 2,
                          child: FavoriteButton(
                            isDark: isDark,
                            favoriteState: favoriteState,
                            shopId: shopId,
                            shopsDocs: shopsDocs,
                            shopSelected: shopSelected,
                          ),
                        )
                      ]),

                  //Mettre plusieurs photos qui peuvent swiper horizontalement
                  Stack(
                    children: <Widget>[
                      //ImageShop
                      SizedBox(
                        height: height * 0.35,
                        child: GaleryShop(
                          shopData: shopSelected,
                          width: width,
                          height: height,
                          isDark: isDark,
                          setIndex: setIndex,
                        ),
                      ),

                      //State Button
                      Positioned(
                        top: 10,
                        left: 30,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Palette.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                shopOpen
                                    ? isFrench
                                        ? 'Ouvert'
                                        : 'Open'
                                    : isFrench
                                        ? 'Fermé'
                                        : 'Closed',
                                style: TextStyle(
                                    color: categoryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'RebondGrotesque'),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                shopOpen ? Icons.circle : Icons.circle_outlined,
                                color: categoryColor,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Conversation Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: width * 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              MessageScreen.routeName,
                              arguments: {
                                'contactId': selectedShop.userSavId,
                                'contactName': contactName,
                                'shopId': shopId,
                                'photo': profilPictureUrl,
                                'myId': myId,
                                'isDark': isDark,
                                'isFrench': isFrench,
                                'isContactMerchant': true,
                                'isUserMerchant': isMerchant,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              width: 1,
                              color: Palette.black,
                            ),
                            backgroundColor: categoryColor,
                            shape: const StadiumBorder(),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.message),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                isFrench ? 'Converser' : 'Chat',
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

                  isInfo
                      ? //Coordonnee And Horaire Item
                      Column(
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
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  width: width * 0.9,
                                  child: Text(
                                    selectedShop.presentationContent,
                                    style: TextStyle(
                                      color: secondaryColor(
                                        !isDark,
                                        categoryColor,
                                      ),
                                      fontSize: 18,
                                      fontFamily: 'RebondGrotesque',
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            CoordonneeItem(
                              coordonneeShop: selectedShop.coordonnee,
                              city: selectedShop.city,
                              color: categoryColor,
                              isFrench: isFrench,
                              isDark: isDark,
                              isOpen: shopOpen,
                              subCatId: selectedShop.subCatId,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            HoraireView(
                              isModifiable: false,
                              color: categoryColor,
                              isFrench: isFrench,
                              isDark: isDark,
                              horaire: horaire,
                              dayClickedList: dayClickedList,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : //NewsShop
                      NewsShop(
                          isMyNews: false,
                          isDark: isDark,
                          isFrench: isFrench,
                          shopReference: shopSelected,
                          shopsDocs: shopsDocs)
                ],
              ),
            ),
          );
        });
  }
}

//color: tintColor(Palette.primary, 0.7),