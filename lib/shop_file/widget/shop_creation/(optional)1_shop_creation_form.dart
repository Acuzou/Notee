// ignore_for_file: file_names

import 'package:cuzou_app/research_file/Model/shop.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';

class ShopCreationForm extends StatefulWidget {
  static String routeName = 'shop-creation-form-one';
  final bool isLoading;
  final bool isDark;
  final void Function(
    int visibilityId,
  ) savePageOne;

  final void Function(int index) setPage;

  // ignore: use_key_in_widget_constructors
  const ShopCreationForm(
    this.isLoading,
    this.isDark,
    this.savePageOne,
    this.setPage,
  );

  @override
  ShopCreationFormState createState() => ShopCreationFormState();
}

class ShopCreationFormState extends State<ShopCreationForm> {
  int visibilityId;

  void _submitVisibility(int visibilityIndex) {
    setState(() {
      visibilityId = visibilityIndex;
    });
  }

  void _trySubmit() {
    bool isValid = (visibilityId != null);
    FocusScope.of(context).unfocus();

    if (isValid) {
      widget.savePageOne(
        visibilityId,
      );
      widget.setPage(1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Veulliez sélectionner un abonnement !"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    //Use those values to send our auth request ...
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: width * 0.80,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //DiamondButton
              ElevatedButton(
                  onPressed: () {
                    _submitVisibility(3);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.all(10),
                    side: !(visibilityId == 3)
                        ? BorderSide(
                            width: 2,
                            color: Palette.orange,
                          )
                        : BorderSide(
                            width: 5,
                            color: Palette.blue,
                          ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                        child: Image(
                            image: AssetImage(
                                visibilityImageURL(VisibilityShop.Diamond)),
                            fit: BoxFit.cover),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Abonnement Diamond',
                              style: TextStyle(
                                color: Palette.orange,
                                fontSize: 16,
                                fontFamily: 'RebondGrotesque',
                              ),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 5),
                          Text(
                            'Prix : X.XX € / mois',
                            style: TextStyle(
                              color: Palette.orange,
                              fontSize: 16,
                              fontFamily: 'RebondGrotesque',
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(height: 5),
              //GoldButton
              ElevatedButton(
                  onPressed: () {
                    _submitVisibility(2);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.all(10),
                    side: !(visibilityId == 2)
                        ? BorderSide(
                            width: 2,
                            color: Palette.orange,
                          )
                        : BorderSide(
                            width: 5,
                            color: Palette.blue,
                          ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                        child: Image(
                            image: AssetImage(
                                visibilityImageURL(VisibilityShop.Gold)),
                            fit: BoxFit.cover),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Abonnement Gold',
                              style: TextStyle(
                                color: Palette.orange,
                                fontSize: 16,
                                fontFamily: 'RebondGrotesque',
                              ),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 5),
                          Text(
                            'Prix : X.XX € / mois',
                            style: TextStyle(
                              color: Palette.orange,
                              fontSize: 16,
                              fontFamily: 'RebondGrotesque',
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(height: 5),
              //SilverButton
              ElevatedButton(
                  onPressed: () {
                    _submitVisibility(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.all(10),
                    side: !(visibilityId == 1)
                        ? BorderSide(
                            width: 2,
                            color: Palette.orange,
                          )
                        : BorderSide(
                            width: 5,
                            color: Palette.blue,
                          ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                        child: Image(
                            image: AssetImage(
                                visibilityImageURL(VisibilityShop.Silver)),
                            fit: BoxFit.cover),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Abonnement Silver',
                              style: TextStyle(
                                color: Palette.orange,
                                fontSize: 16,
                                fontFamily: 'RebondGrotesque',
                              ),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 5),
                          Text(
                            'Prix : X.XX € / mois',
                            style: TextStyle(
                              color: Palette.orange,
                              fontSize: 16,
                              fontFamily: 'RebondGrotesque',
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(height: 5),
              //Bronze Abonnement
              ElevatedButton(
                  onPressed: () {
                    _submitVisibility(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.all(10),
                    side: !(visibilityId == 0)
                        ? BorderSide(
                            width: 2,
                            color: Palette.orange,
                          )
                        : BorderSide(
                            width: 5,
                            color: Palette.blue,
                          ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                        child: Image(
                            image: AssetImage(
                                visibilityImageURL(VisibilityShop.Bronze)),
                            fit: BoxFit.cover),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Abonnement Cooper',
                              style: TextStyle(
                                color: Palette.orange,
                                fontSize: 16,
                                fontFamily: 'RebondGrotesque',
                              ),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 5),
                          Text(
                            'Prix : 0.00 € / mois',
                            style: TextStyle(
                              color: Palette.orange,
                              fontSize: 16,
                              fontFamily: 'RebondGrotesque',
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),

              const SizedBox(
                height: 10,
              ),
              if (widget.isLoading)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Return Button
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Palette.orange,
                          padding: const EdgeInsets.all(11),
                          shape: const CircleBorder(),
                          side: BorderSide(
                            width: 1,
                            color:
                                secondaryColor(!widget.isDark, Palette.orange),
                          ),
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
                          _trySubmit();
                          //widget.setPage(1);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Palette.orange,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 15,
                          ),
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            width: 1,
                            color:
                                secondaryColor(!widget.isDark, Palette.orange),
                          ),
                        ),
                        child: Text(
                          '      Continuer      ',
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    size: 15,
                    color: Palette.orange,
                  ),
                  Icon(Icons.circle_outlined, size: 10, color: Palette.orange),
                  Icon(Icons.circle_outlined, size: 10, color: Palette.orange),
                  Icon(Icons.circle_outlined, size: 10, color: Palette.orange),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
