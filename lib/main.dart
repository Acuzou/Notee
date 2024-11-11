//Firebase imports
import 'package:cuzou_app/authentication_file/Screen/account_creation_screen.dart';
import 'package:cuzou_app/menu_file/Screen/creationShop_screen.dart';
import 'package:cuzou_app/shop_file/widget/modify_photo_shop.dart';
import 'package:cuzou_app/shop_file/widget/modify_shop_info.dart';
import 'package:cuzou_app/news_file/Screen/publication_newsletter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//import 'firebase_options.dart';
import 'main_switch.dart';
import 'package:cuzou_app/menu_file/Screen/favorite_screen.dart';
import 'package:cuzou_app/profile_file/Screen/profile_screen.dart';
import 'package:cuzou_app/shop_file/screen/myshop_screen.dart';
import 'package:cuzou_app/menu_file/Screen/setting_screen.dart';
import 'package:cuzou_app/profile_file/Widget/modify_info.dart';
import 'package:cuzou_app/message_file/Screen/messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
//import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:cuzou_app/menu_file/Screen/menu_screen.dart';

import 'menu_file/Screen/aboutus.dart';
import 'research_file/Screen/shops_list.dart';
import 'shop_file/screen/shop_detail_screen.dart';
import 'research_file/Screen/detail_categorie_screen.dart';
import 'authentication_file/Screen/authentification_screen.dart';
import 'general_widget/QRCode/QRCodeScreen.dart';
import 'general_widget/QRCode/QRScanner.dart';
//import 'main_screen copy.dart';
//import 'main_transition_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("TEST ABC");

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // TODO: handle the received notifications
  } else {
    print('User declined or has not accepted permission');
  }

  runApp(const MainNoteeApp());
}

//Future<void> main() async {
//WidgetsFlutterBinding.ensureInitialized();
// await Firebase.initializeApp();

// runApp(const MainNoteeApp());

//await Firebase.initializeApp().then((value) {
// final messaging = FirebaseMessaging.instance;

//https://blog.logrocket.com/add-flutter-push-notifications-firebase-cloud-messaging/

//FOR IOS
// final settings = await messaging.requestPermission(
//   alert: true,
//   announcement: false,
//   badge: true,
//   carPlay: false,
//   criticalAlert: false,
//   provisional: false,
//   sound: true,
// );
// if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//   print('User granted permission');
//   // TODO: handle the received notifications
// } else {
//   print('User declined or has not accepted permission');
// }

//runApp(const MainNoteeApp());
//});
//}

//Couleur Bleu Clair:  (220, 255, 255)
//Couleur Violet: (225, 225, 255)
//Couleur Orange; (255, 240, 230)
//Couleur Rose: (255, 230, 250)
//Couleur Vert: (225, 255, 225)
//Couleur Noir: (0, 0, 0)

class Palette {
  static Color primary = const Color.fromRGBO(220, 255, 255, 1);
  static Color secondary = const Color.fromRGBO(0, 0, 0, 1);

  static double opacity = 1;

  static Color blue =
      const Color.fromRGBO(220, 255, 255, 1).withOpacity(opacity);
  static Color purple =
      const Color.fromRGBO(225, 225, 255, 1).withOpacity(opacity);
  static Color orange =
      const Color.fromRGBO(255, 240, 230, 1).withOpacity(opacity);
  static Color pink =
      const Color.fromRGBO(255, 230, 255, 1).withOpacity(opacity);
  static Color green =
      const Color.fromRGBO(225, 255, 225, 1).withOpacity(opacity);
  static Color yellow =
      const Color.fromRGBO(255, 255, 230, 1).withOpacity(opacity);
  static Color black = const Color.fromRGBO(0, 0, 0, 1);
  static Color grey = const Color.fromRGBO(230, 230, 230, 1);
  static Color white = const Color.fromRGBO(255, 255, 255, 1);
}

// It is assumed that all messages contain a data field with the key 'type'
Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) {
  // if (message.data['type'] == 'chat') {

  //   Navigator.of(context).pushNamed(
  //   MainScreen.routeName,
  //   arguments: {
  //     'initialPage': 2,
  //     'message': message,
  //   },
  // );
  // }
}

class MainNoteeApp extends StatefulWidget {
  const MainNoteeApp({Key key}) : super(key: key);

  @override
  MainNoteeAppState createState() => MainNoteeAppState();
}

class MainNoteeAppState extends State<MainNoteeApp> {
  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async

    setupInteractedMessage();
  }

  Widget splashScreen() {
    Widget page;

    var authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      page = const AuthentificationScreen(isInit: true);
    } else {
      page = const MainScreen();
    }

    return SplashScreen(
        seconds: 3,
        navigateAfterSeconds: page,
        image: Image.asset('assets/images/logos/anim_fond_noir.gif'),
        photoSize: 70.0,
        backgroundColor: Colors.black,
        styleTextUnderTheLoader: const TextStyle(),
        loaderColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    //MediaQuery
    //Text Scale Factor
    //final double curScaleFactor = MediaQuery.of(context).textScaleFactor;
    //Ex: Text('This changes!', style: TextStyle(fontSize: 20 * curScaleFactor));

    //double appBar.preferredSize.height pour avoir la taille de l'appBar (avec appBar variable AppBar)

    //double MediaQuery.of(context).padding.top pour avoir la taille du StateBar
    //Widget Size Factor
    // Size size = MediaQuery.of(context).size;
    // final double heigth = size.height;
    // final double width = size.width;

    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        //useInheritedMediaQuery: true,
        title: 'Notee',
        theme: ThemeData(
          //primarySwatch(MaterialColor) for appBar,
          canvasColor: Palette.black,
          fontFamily: 'RebondGrotesque',
          scaffoldBackgroundColor: Palette.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          //scaffoldBackgroundColor: const Color.fromRGBO(6, 9, 46, 1),

          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  fontSize: 27,
                  fontFamily: 'RebondGrotesque',
                  color: Palette.black,
                ),
                //Text publication
                bodyText2: TextStyle(
                  fontSize: 17,
                  fontFamily: 'RebondGrotesque',
                  color: Palette.black,
                ),
                //UserName in Message Screen
                headline1: TextStyle(
                  color: Palette.black,
                  fontSize: 22,
                  fontFamily: 'RebondGrotesque',
                ),

                //CategoryName in ResearchScreen
                headline6: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'RebondGrotesque',
                ),

                headline4: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'RebondGrotesque',
                  color: Colors.black,
                ),
              ),
          appBarTheme: AppBarTheme(
            toolbarTextStyle: ThemeData.dark()
                .textTheme
                .copyWith(
                  headline6: TextStyle(
                    fontFamily: 'RebondGrotesque',
                    fontSize: 25,
                    color: Palette.black,
                  ),
                )
                .bodyText2,
            titleTextStyle: ThemeData.dark()
                .textTheme
                .copyWith(
                  headline6: TextStyle(
                    fontFamily: 'RebondGrotesque',
                    fontSize: 25,
                    color: Palette.black,
                  ),
                )
                .headline6,
          ),
          colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: generateMaterialColor(Palette.white))
              .copyWith(
                  secondary: generateMaterialColor(Palette.black).shade600),
        ),

        // home: AuthentificationScreen() or MainScreen(),
        initialRoute: '/', // default is '/'
        routes: {
          '/': (ctx) => splashScreen(),

          //'/': (ctx) => AuthentificationScreen(),
          MenuScreen.routeName: (ctx) => MenuScreen(),
          ShopsListScreen.routeName: (ctx) => ShopsListScreen(
                shopListIndex: 0,
                favoriteShop: const [],
                isDark: true,
                isFrench: true,
                colorAppBar: Palette.blue,
              ),
          ShopDetailScreen.routeName: (ctx) => const ShopDetailScreen(),
          CategorieDetailScreen.routeName: (ctx) =>
              const CategorieDetailScreen(),
          MainScreen.routeName: (ctx) => const MainScreen(),
          //ContactScreen.routeName: (ctx) => ContactScreen(),
          MessageScreen.routeName: (ctx) => const MessageScreen(),
          //CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
          //NewsScreen.routeName: (ctx) => NewsScreen(),
          MyProfile.routeName: (ctx) => const MyProfile(),
          MyShopScreen.routeName: (ctx) => const MyShopScreen(),
          MyFavorite.routeName: (ctx) => MyFavorite(),
          SettingScreen.routeName: (ctx) => const SettingScreen(),
          AccountCreationScreen.routeName: (ctx) =>
              const AccountCreationScreen(),
          AuthentificationScreen.routeName: (ctx) =>
              const AuthentificationScreen(isInit: false),
          ShopCreationScreen.routeName: (ctx) => const ShopCreationScreen(),
          ModifyInfoAccount.routeName: (ctx) => ModifyInfoAccount(),
          ModifyPhotoShop.routeName: (ctx) => const ModifyPhotoShop(),
          ModifyShopInfoAccount.routeName: (ctx) =>
              const ModifyShopInfoAccount(),
          PublicationNews.routeName: (ctx) => const PublicationNews(),
          AboutUsScreen.routeName: (ctx) => const AboutUsScreen(),
          //QRScanner.routeName: (ctx) => const QRScanner(),
          //QRCodeScreen.routeName: (ctx) => QRCodeScreen(),
        },

        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => const MainScreen());
        },
      ),
    );
  }
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

Color primaryColor(bool isDark) {
  if (isDark) {
    return Palette.black;
  } else {
    return Palette.white;
  }
}

Color secondaryColor(bool isDark, Color colorAppBar) {
  if (isDark) {
    return Palette.black;
  } else {
    return colorAppBar;
  }
}

//A finir
//Problème shopId = 0 pour News quand on clique dessus
//TEST pour Google Maps / Telephone / Requette https



//-----



//Regler problème de suppression magasin sur favori users

//Régler problème d'heure message

//Actualiser isSaw directement après avoir lu message dans ContactScreen


//////////////////////////Faire fonctionner sur IPHONE

///////Faire Push Notification pour news fav et message
///////Verifier formule note
///Faire bar de scroll pour listView

///Regler problème de modification de mot de passe
//Publier playstore



//Pour après
//Faire filtre par ville
//Envoyer photo dans les messages
//Vérifier fonctionnement formule score
//Possibilité de bloquer pour commerçant
//Possibilité de renommer un utilisateur

////Possibilité de cibler le groupe utilisateur pour le commerçant
////Année de naissance
//Pouvoir envoyer pieces jointes 
//Permettre recherche par distance
//Créer un jauge de distance sur laquelle on peut voir les magasins
//Gérer la rotation

//Rajouter animation
//Faire filtre pour News + Recherche
//Faire bar de scrollage pour News et Messages

//Mettre Géolocalisation
//Règler les petits problèmes + MediaQuery

//Utiliser Linear Progress indicator pour faire barre de chargement
//Utiliser flutter slidable pour supprimer les favoris

//Pour encore après
//Adapter les magasion suivat la géolocalisation (Ville + Proximité)

//Animation (Liquid Swipe (diff color per page) + ListWheelScrollView + ZoomSubCategorie + HeroShop + LogoAnimation (Waiting + Start))
//Optimisation
//Ameliorer Performance
//Faire les adaptations suivant les devices IOS / Android
//Tester sur l'AppStore sur mon tel
//Add Artificial Intelligence for user préférences (In visibility + Propose New Shop according to taste in categorieItem)
