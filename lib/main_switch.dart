import 'package:cuzou_app/main.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'menu_file/Screen/menu_screen.dart';
import 'message_file/Screen/contacts_screen.dart';
import 'research_file/Screen/categorie_screen.dart';
import 'news_file/Screen/news_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';

  const MainScreen({Key key}) : super(key: key);
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int indexPage = 1;
  Map<String, Object> routeArgs = {'initialPage': 1, 'message': 'NaN'};

  PageController _pageController;
  bool isInit = true;

  bool isFrench = true;
  bool isDark = true;
  bool isMerchant = true;
  bool isInitStageOne = true;
  bool isInitStageTwo = true;
  bool isInitStageThree = true;

  void reachDataCenter() async {
    final auth = FirebaseAuth.instance.currentUser;
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.uid)
        .get();

    setState(() {
      isFrench = userSnapshot['isFrench'];
      isDark = userSnapshot['isDark'];
      isMerchant = userSnapshot['isMerchant'];
      isInitStageOne = false;
    });

    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   setState(() {});
    // });
  }

  @override
  void initState() {
    // _pageController = PageController(
    //   keepPage: false,
    //   initialPage: indexPage,
    // );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> pages(
    isDark,
    isFrench,
    isMerchant,
  ) {
    return [
      NewsScreen(isDark: isDark, isFrench: isFrench),
      //HomeScreen(isDark, isFrench),

      CategoriesScreen(
        isDark: isDark,
        isFrench: isFrench,
      ),
      ContactScreen(
        isDark: isDark,
        isFrench: isFrench,
        isMerchant: isMerchant,
      ),
    ];
  }

  final items = <Widget>[
    Image.asset(
      'assets/images/logos/navigation_bar_logo/journal.png',
      fit: BoxFit.cover,
      scale: 7,
    ),
    Image.asset(
      'assets/images/logos/navigation_bar_logo/home.png',
      fit: BoxFit.cover,
      scale: 7,
    ),
    Image.asset(
      'assets/images/logos/navigation_bar_logo/lettre.png',
      fit: BoxFit.cover,
      scale: 7,
    ),
  ];

  void setOnMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (notification != null) {
        print('Message also contained a notification: ${message.notification}');

        if (android != null && indexPage != 2) {
          // const AndroidNotificationChannel channel = AndroidNotificationChannel(
          //   'high_importance_channel', // id
          //   'High Importance Notifications', // title
          //   'This channel is used for important notifications.', // description
          //   importance: Importance.max,
          // );

          // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          //   FlutterLocalNotificationsPlugin();

          // await flutterLocalNotificationsPlugin
          //   .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          //   ?.createNotificationChannel(channel);

          //Put this in AndroidManisfest
          //<meta-data
          //android:name="com.google.firebase.messaging.default_notification_channel_id"
          //android:value="high_importance_channel" />

          // flutterLocalNotificationsPlugin.show(
          //   notification.hashCode,
          //   notification.title,
          //   notification.body,
          //   NotificationDetails(
          //     android: AndroidNotificationDetails(
          //       channel.id,
          //       channel.name,
          //       channel.description,
          //       icon: android?.smallIcon,
          //   // other properties...
          //     ),
          //  ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setOnMessageListener();

    if (ModalRoute.of(context).settings.arguments != null) {
      routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
    }

    if (isInit) {
      indexPage = routeArgs['initialPage'];
      _pageController = PageController(
        keepPage: false,
        initialPage: indexPage,
      );
      isInit = false;
    }

    if (isInitStageOne) {
      reachDataCenter();
    }

    if (isInitStageTwo) {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          isInitStageTwo = false;
          isInitStageOne = false;
        });
      });
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: primaryColor(isDark),
      appBar: AppBar(
        title: (indexPage == 1)
            ? ImageIcon(
                //AssetImage("assets/images/logos/logo_notee/logo_blanc.png"),
                const AssetImage(
                    "assets/images/logos/logo_notee/logo_gras_noir.png"),
                size: 100,
                color: Palette.black)
            : (indexPage == 0)
                ? Text(
                    isFrench ? "Journal" : "Feed",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : Text(
                    isFrench ? "Courrier" : 'Message',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
        backgroundColor: (indexPage == 1)
            ? shadeColor(Palette.blue, 0.1)
            : (indexPage == 0)
                ? shadeColor(Palette.orange, 0.1)
                : shadeColor(Palette.pink, 0.1),
        actions: <Widget>[
          Ink(
            child: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(MenuScreen.routeName, arguments: {
                  'colorAppBar': (indexPage == 1)
                      ? Palette.blue
                      : (indexPage == 0)
                          ? Palette.orange
                          : Palette.pink,
                });
              },
              splashColor: (indexPage == 1)
                  ? shadeColor(Palette.blue, 0.2)
                  : (indexPage == 0)
                      ? shadeColor(Palette.orange, 0.2)
                      : shadeColor(Palette.pink, 0.2),
              icon: Icon(
                Icons.menu,
                color: Palette.black,
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(
            () {
              indexPage = index;
              isInitStageTwo = true;
            },
          );
        },
        children: pages(isDark, isFrench, isMerchant),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          color: (indexPage == 1)
              ? shadeColor(Palette.blue, 0.1)
              : (indexPage == 0)
                  ? shadeColor(Palette.orange, 0.1)
                  : shadeColor(Palette.pink, 0.1),
          buttonBackgroundColor: (indexPage == 1)
              ? shadeColor(Palette.blue, 0.1)
              : (indexPage == 0)
                  ? shadeColor(Palette.orange, 0.1)
                  : shadeColor(Palette.pink, 0.1),
          backgroundColor: Colors.transparent,
          height: 60,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          index: indexPage,
          items: items,
          onTap: (index) {
            setState(() {
              indexPage = index;
              _pageController.jumpToPage(indexPage);
              //Faire un pagecontroller.dispose
              isInitStageTwo = true;
            });
          }),
    );

    //TO change the color in the icon
    // bottomNavigationBar: Theme(
    //   data: Theme.of(context).copyWith(
    //     iconTheme: IconThemeData(color: Colors.white),
    //   ),
    //   child: CurvedNavigationBar(...)
  }
}
