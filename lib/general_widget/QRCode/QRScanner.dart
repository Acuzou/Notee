// import 'package:cuzou_app/general_widget/QR%20Code/QRCodeItem.dart';
// import 'package:cuzou_app/main.dart';
// import 'package:cuzou_app/main_switch.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// class QRScanner extends StatefulWidget {
//   static const routeName = '/my_qr_code'
//   @override
//   State<StatefulWidget> createState() => QRScannerState();
// }

// class QRScannerState extends State<QRScanner> {
//   Color colorAppBar;
//   bool isFrench;
//   bool isDark;
//   bool isQRCodeScan;
//   List<QRCodeModel> myQRCodeList;

//   //QRViewController controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   @override
//   void initState() {
//     super.initState();
//     //_checkCameraPermissions();
//     isQRCodeScan = false;
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void _checkCameraPermissions() async {
//     if (await Permission.camera.isGranted) {
//       //Si la permission est déjà accordée
//       _initializeCamera();
//     } else {
//       //Sinon je demande la permission
//       PermissionStatus status = await Permission.camera.request();
//       if (status.isGranted) {
//         _initializeCamera();
//       } else {
//         print('Permission de la camera refusée');
//       }
//     }
//   }

//   void _initializeCamera() {
//     controller = QRViewController(
//       qrKey: qrKey,
//       onScanned: _onQRScanned,
//     );
//     controller?.initialize();
//   }

//   void _onQRScanned(String data) {
//     //Gestion des données du code QR scanné
//     print('Données du code QR : $data');

//     //Arete le scanner après avoir scanné un code
//     controller?.pauseCamera();
//   }

//   List<QRCodeModel> getQRCodeList(int myId, int shopId) { 

    
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final double width = size.width;
//     final double height = size.height;

//     final routeArg =
//         ModalRoute.of(context).settings.arguments as Map<String, Object>;

//     colorAppBar = routeArg['colorAppBar'] as Color;
//     isFrench = routeArg['isFrench'] as bool;
//     isDark = routeArg['isDark'] as bool;
//     shopId = routeArg['shopId'] as int;
//     myId = routeArg['myId'] as int;

//     myQRCodeList = getQRCodeList(myId, shopId);

//     return Scaffold(
//       backgroundColor: primaryColor(isDark),
//       appBar: AppBar(
//         backgroundColor: shadeColor(colorAppBar, 0.1),
//         title: const Text(
//           'QR Scanner',
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
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   width: width * 0.4,
//                   margin: const EdgeInsets.symmetric(vertical: 5),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         width: 2,
//                         color: isDark
//                             ? primaryColor(isQRCodeScan)
//                             : primaryColor(!isQRCodeScan),
//                       ),
//                     ),
//                   ),
//                   child: TextButton(
//                     onPressed: () {
//                       setState(() {
//                         isQRCodeScan = false;
//                       });
//                     },
//                     child: Text(
//                       isFrench ? 'Ma liste QR Code' : 'My QR Code list',
//                       style: TextStyle(
//                         color: primaryColor(!isDark),
//                         fontFamily: 'RebondGrotesque',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: width * 0.4,
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         width: 2,
//                         color: isDark
//                             ? primaryColor(!isQRCodeScan)
//                             : primaryColor(isQRCodeScan),
//                       ),
//                     ),
//                   ),
//                   child: TextButton(
//                     onPressed: () {
//                       setState(() {
//                         isQRCodeScan = true;
//                       });
//                     },
//                     child: Text(
//                       isFrench ? 'Scan QR Code' : 'QR Code Scanner',
//                       style: TextStyle(
//                         color: primaryColor(!isDark),
//                         fontFamily: 'RebondGrotesque',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             isQRCodeScan
//                 ? Expanded(
//                     child: QRView(
//                         key: qrKey,
//                         onQRViewCreated: (controller) {
//                           this.controller = controller;
//                         }),
//                   )
//                 : ListView.builder(
//                     itemCount: myQRCodeList.lenght,
//                     itemBuilder: (context, index) {
//                       return const QRCodeItem( 
//                         'myQRCode': myQRCodeList[index],
//                         'isFrench': isFrench, 
//                         'isDark': isDark, 
//                         'colorAppBar': colorAppBAr,
//                       );
//                     },
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
