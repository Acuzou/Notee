// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:cuzou_app/news_file/data/shop_function.dart';
import 'package:cuzou_app/main.dart';


class QRCodeItem extends StatelessWidget {
  final QRCodeModel myQRCode;
  final bool isFrench;
  final bool isDark;
  final Color colorAppBar;

  const QRCodeItem({
    Key key,
    this.myQRCode, 
    this.colorAppBar,
    this.isFrench,
    this.isDark,
  }) : super(key: key);

  


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Material( 
      color: primaryColor(isDark),
      child: InkWell(
        splashColor: colorAppBar,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.005),
          width: width * 0.9,
          height: height * 0.1,
          child: ElevatedButton(
            //autofocus: true, //Fucking Autofocus //Cause du problème du clavier
            //hoverColor: shadeColor(Palette.primary, 0.6),
            onPressed: () { 
        Navigation.of(context).pushNamed(
          QRCodeScreen.routeName, 
          arguments: { 
            'myQRCode': myQRCode, 
            'isDark': isDark, 
            'isFrench': isFrench,
            'colorAppBar': colorAppBar,
          }
          )
      }
          style: ElevatedButton.styleFrom( 
            elevation: 2, 
            backgroundColor: colorAppBar,

            padding: const EdgeInsets.all(10),
            shape: const RectangleBorder(),
            side: BorderSide(
                  width: 1,
                  color: Palette.black,
                )),

            // final int qrcodeId;
  // final int myId;
  // final int shopId;
  // final int reducValue;
  // final DateTime createdAt;
  // final String data;
            child: Row( 
              mainAxisAlignement: MainAxisAlignment.center,
              children: [ 

                //Icons QRCode
                SizedBox( 
                  width: width * 0.1, 
                  child: Icons(Icons.camera),
                )

                //Nom Magasin
                SizedBox(
                  width: width * 0.4,
                  child: Text( 
                  getShopNameFromId(shopId), 
                  style: TextStyle( 
                    color: Palette.black, 
                    fontSize: 16, 
                    fontFamily: 'RebondGrotesque',
                  )
                )
                )
                
                SizedBox( 
                  width: width * 0.2,
                  child: Text( 
                    '${myQRCode.reducValue} €', 
                    style: TextStyle( 
                      color: Palette.black, 
                      fontSize: 18, 
                      fontFamily: 'RebondGrotesque',
                  ),
                ),),


                SizedBox( 
                  width: width * 0.2, 
                  child: Column(
                    children: [
                            Text(
                                        formatDate(
                                          myQRCode.createdAt,
                                          [HH, ':', nn],
                                        ),
                                        style: TextStyle(
                                          color: primaryColor(!isDark),
                                          fontSize: 16, 
                                          fontFamily: 'RebondGrotesque',
                                        ),
                                      ),
                                      Text(
                                        formatDate(
                                          myQRCode.createdAt,
                                          [d, ' ', MM, ' '],
                                        ),
                                        style: TextStyle(
                                          color: primaryColor(!isDark),
                                          fontSize: 16, 
                                          fontFamily: 'RebondGrotesque',
                                        ),
                                      ),
                                    ],
                                  ),
                )


              ]
            )
          )
      ),),),
    );
  }
}
