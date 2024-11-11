// import 'package:flutter/material.dart';
// import 'package:cuzou_app/shop_file/data/shop_function.dart';


// class QRCodeScreen extends StatelessWidget { 
//   final static routeName = '/Qr-Code-Screen';

//   @override 
//   Widget build(BuildContext context) { 

//     Size size = MediaQuery.of(context).size;
//     final double width = size.width;
//     final double height = size.height;

//     final routeArg =
//         ModalRoute.of(context).settings.arguments as Map<String, Object>;

//     final Color colorAppBar = routeArg['colorAppBar'] as Color;
//     final bool isFrench = routeArg['isFrench'] as bool;
//     final bool isDark = routeArg['isDark'] as bool;
//     final QRCodeModel myQRCode = routeArg['myQRCode'] as QRCodeModel;

//     return
//       Scaffold(
//       backgroundColor: primaryColor(isDark),
//       appBar: AppBar(
//         backgroundColor: shadeColor(colorAppBar, 0.1),
//         title: const Text(
//           isFrench ? 'Mon QRCode' : 'MyQRCode',
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: const ImageIcon(
//               AssetImage("assets/images/logos/logo_notee/icon_noir.png"),
//               size: 120,
//             ),
//             tooltip: 'Home Page',
//             onPressed: () {
//               Navigator.of(context).pushNamedAndRemoveUntil(
//                 MainScreen.routeName,
//                 (route) => false,
//               );
//             },
//           ),
//           const SizedBox(width: 10),
//         ],
//       ),
//       body: //RefreshIndicator(
//           //onRefresh: _refresh,
//           //child:
//           SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.center,

//           children: [

//             //Titre
//             Text( 
//               isFrench ? 'Bon de Réduction' : 'Reduction Value', 
//               style: TextStyle( 
//                 color: primaryColor(!isDark), 
//                 fontSize: 20,
//                 fontFamily: 'RebondGrotesque', 
//               ),
//             ),

//             //Nom Magasin
//             Text( 
//               getShopNameFromId(myQRCode.shopId), 
//               style: TextStyle( 
//                 color: primaryColor(!isDark), 
//                 fontSize: 18,
//                 fontFamily: 'RebondGrotesque', 
//               ),
//             ),

//             //CreatedAt
//             Row( 
//               children: [
//                             Text(
//                                         formatDate(
//                                           myQRCode.createdAt,
//                                           [HH, ':', nn],
//                                         ),
//                                         style: TextStyle(
//                                           color: primaryColor(!isDark),
//                                           fontSize: 16, 
//                                           fontFamily: 'RebondGrotesque',
//                                         ),
//                                       ),
//                                       Text(
//                                         formatDate(
//                                           myQRCode.createdAt,
//                                           [d, ' ', MM, ' '],
//                                         ),
//                                         style: TextStyle(
//                                           color: primaryColor(!isDark),
//                                           fontSize: 16, 
//                                           fontFamily: 'RebondGrotesque',
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                 //Valeur Reduction
            
//             Text( 
//               getShopName(myQRCode.shopId), 
//               style: TextStyle( 
//                 color: primaryColor(!isDark), 
//                 fontSize: 18,
//                 fontFamily: 'RebondGrotesque', 
//               ),
//             ),

//             //Affichage QRCode
//             Card( 
//               width : width * 0.8,
//               heigh : width * 0.8,
//               child: Container(),
//             ),

//             //Reference
//             Text( 
//               //Mettre texte en Majuscule
//               myQRCode.qrCodeReference, 
//               style: TextStyle( 
//                 color: primaryColor(!isDark), 
//                 fontSize: 18,
//                 fontFamily: 'RebondGrotesque', 
//               ),
//             )

//           ],),),
//     );
//   }

// }