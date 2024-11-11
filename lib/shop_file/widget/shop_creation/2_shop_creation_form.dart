// ignore_for_file: file_names

import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/authentication_file/widget/cityDialog.dart';
import 'package:cuzou_app/research_file/Model/shop.dart';
import 'categorySimpleDialog.dart';
import 'package:cuzou_app/research_file/Data/general_data.dart';

class ShopCreationFormTwo extends StatefulWidget {
  static String routeName = 'shop-creation-form-one';
  final bool isLoading;
  final bool isDark;
  final bool isFrench;
  final void Function(
    String email,
    String title,
    String adress,
    String website,
    int phoneNumber,
    int subcatIndex,
    int cityId,
  ) savePageTwo;

  final GlobalKey<FormState> formKey;

  final void Function(int index) setPage;

  const ShopCreationFormTwo(this.isLoading, this.isDark, this.isFrench,
      this.savePageTwo, this.setPage, this.formKey,
      {Key key})
      : super(key: key);

  @override
  ShopCreationFormTwoState createState() => ShopCreationFormTwoState();
}

class ShopCreationFormTwoState extends State<ShopCreationFormTwo> {
  //static final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _title = '';
  String _adress = '';
  String _website = '';
  int _phoneNumber = 0;
  int _cityId = 0;
  String _cityText;
  bool isCitySelected = false;
  bool isInit = true;

  bool autofocus = false;

  final myController = TextEditingController();
  //FocusNode nodeFirst = FocusNode();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _submitCity(int cityId, String cityName) {
    setState(() {
      _cityId = cityId;
      _cityText = cityName;
      isCitySelected = (_cityText != "Ville") && (_cityText != 'City');
    });
  }

  String _subCatText;
  SubCat _subCatSelected = SubCat.Default;
  bool isSubCatSelected = false;

  void _submitCategory(SubCat subCat, String subCatText) {
    setState(() {
      _subCatSelected = subCat;
      _subCatText = subCatText;
      isSubCatSelected = (_subCatSelected != SubCat.Default);
    });
  }

  void _trySubmit() {
    bool isValid = widget.formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    isValid = isValid && (isSubCatSelected) && (isCitySelected);

    if (!isSubCatSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Veulliez sélectionner une catégorie !"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
    if (!isCitySelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Veulliez sélectionner une ville !"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    int subCatIndex = getSubCatIndex(_subCatSelected);

    if (isValid) {
      widget.formKey.currentState.save();

      widget.savePageTwo(
        _email.trim(),
        _title.trim(),
        _adress.trim(),
        _website.trim(),
        _phoneNumber,
        subCatIndex,
        _cityId,
      );
      //widget.setPage(2);
      widget.setPage(1);
    }

    //Use those values to send our auth request ...
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    if (isInit) {
      _cityText = widget.isFrench ? 'Ville' : 'City';
      _subCatText = widget.isFrench ? 'Catégorie' : 'Category';
      isInit = false;
    }

    return Center(
      child: Container(
        width: width * 0.80,
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                //focusNode: nodeFirst,
                // onTap: () {
                //   //FocusScope.of(context).requestFocus(nodeFirst);
                //   autofocus = true;
                // },
                // autofocus: autofocus,
                // controller: myController,
                keyboardAppearance:
                    widget.isDark ? Brightness.dark : Brightness.light,
                key: const ValueKey('title'),
                validator: (value) {
                  if (value.isEmpty) {
                    if (widget.isFrench) {
                      return 'Entrez un nom valide s\'il vous plait !';
                    } else {
                      return 'Please, enter a valid name !';
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 1.0),
                  ),
                  // labelText: 'Nom',
                  // labelStyle:
                  //     TextStyle(color: shadeColor(Palette.black, 0.1)),
                  hintText: widget.isFrench ? 'Nom' : 'Name',
                  hintStyle: TextStyle(
                    color: tintColor(Palette.black, 0.1),
                    fontFamily: 'RebondGrotesque',
                  ),
                ),
                // onChanged: (value) {
                //   setState((){
                //     _title = value;
                //   });
                // },
                onSaved: (value) {
                  _title = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardAppearance:
                    widget.isDark ? Brightness.dark : Brightness.light,
                key: const ValueKey('email'),
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    if (widget.isFrench) {
                      return 'Entrez un email valide s\'il vous plait !';
                    } else {
                      return 'Please, enter a valid email !';
                    }
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 1.0),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: tintColor(Palette.black, 0.1),
                    fontFamily: 'RebondGrotesque',
                  ),
                ),
                onSaved: (value) {
                  _email = value;
                },
                // onFieldSubmitted: (value) {
                //   widget.onChange(false);
                // },
                // onChanged: (value) {
                //   widget.onChange(true);
                // },
              ),
              const SizedBox(
                height: 10,
              ),

              TextFormField(
                keyboardAppearance:
                    widget.isDark ? Brightness.dark : Brightness.light,
                key: const ValueKey('adresse'),
                validator: (value) {
                  if (value.isEmpty) {
                    if (widget.isFrench) {
                      return 'Entrez une adresse valide s\'il vous plait !';
                    } else {
                      return 'Please, enter a valid address !';
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 1.0),
                  ),
                  hintText: widget.isFrench ? 'Adresse' : 'Address',
                  hintStyle: TextStyle(
                    color: tintColor(Palette.black, 0.1),
                    fontFamily: 'RebondGrotesque',
                  ),
                ),
                onSaved: (value) {
                  _adress = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),

              //Phone Number TextField
              TextFormField(
                keyboardAppearance:
                    widget.isDark ? Brightness.dark : Brightness.light,
                key: const ValueKey('phonenumber'),
                validator: (value) {
                  if ((value.isEmpty) && (value.length != 10)) {
                    if (widget.isFrench) {
                      return 'Entrez un numéro valide s\'il vous plait !';
                    } else {
                      return 'Please, enter a valid phone number !';
                    }
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 1.0),
                  ),
                  hintText:
                      widget.isFrench ? 'Numéro de téléphone' : 'Phone number',
                  hintStyle: TextStyle(
                    color: tintColor(Palette.black, 0.1),
                    fontFamily: 'RebondGrotesque',
                  ),
                ),
                onSaved: (value) {
                  _phoneNumber = int.parse(value);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardAppearance:
                    widget.isDark ? Brightness.dark : Brightness.light,
                key: const ValueKey('website'),
                validator: (value) {
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: secondaryColor(!widget.isDark, Palette.blue),
                        width: 1.0),
                  ),
                  hintText: widget.isFrench
                      ? 'Site Web (Facultatif)'
                      : 'Website (Facultative)',
                  hintStyle: TextStyle(
                    color: tintColor(Palette.black, 0.1),
                    fontFamily: 'RebondGrotesque',
                  ),
                ),
                onSaved: (value) {
                  _website = value;
                },
              ),

              const SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //SubCategorie Simple Dialogue
                  SizedBox(
                    width: width * 0.35,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialogCategory(
                            width: width,
                            height: height,
                            catIndex: 0,
                            isCatPage: true,
                            submitCategory: _submitCategory,
                            isFrench: widget.isFrench,
                            subCatId: 0,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSubCatSelected ? Palette.black : Palette.orange,
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 12,
                          bottom: 12,
                        ),
                        side: BorderSide(
                          width: 1,
                          color: primaryColor(!widget.isDark),
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        _subCatText,
                        style: TextStyle(
                          color:
                              isSubCatSelected ? Palette.orange : Palette.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RebondGrotesque',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  //City Choice Button
                  SizedBox(
                    width: width * 0.35,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialogCity(
                            width: width,
                            height: height,
                            submitCity: _submitCity,
                            isFrench: widget.isFrench,
                            color: Palette.orange,
                            cityId: _cityId,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isCitySelected ? Palette.black : Palette.orange,
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 12,
                          bottom: 12,
                        ),
                        side: BorderSide(
                          width: 1,
                          color: primaryColor(!widget.isDark),
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        _cityText,
                        style: TextStyle(
                            color:
                                isCitySelected ? Palette.orange : Palette.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RebondGrotesque'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
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
                          widget.isFrench
                              ? '      Continuer      '
                              : '      Continue      ',
                          style: TextStyle(
                            color: Palette.black,
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
                  Icon(Icons.circle, size: 15, color: Palette.orange),
                  Icon(
                    Icons.circle_outlined,
                    size: 10,
                    color: Palette.orange,
                  ),
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
