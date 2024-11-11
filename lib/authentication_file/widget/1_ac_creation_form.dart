// ignore_for_file: file_names

import 'package:cuzou_app/authentication_file/Screen/authentification_screen.dart';
import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';
import '../../research_file/Data/general_data.dart';
import 'cityDialog.dart';

class AccountCreationForm extends StatefulWidget {
  final bool isDark;
  final bool isFrench;
  final bool isLoading;
  final void Function(
    String email,
    String lastName,
    String firstName,
    int phoneNumber,
    int cityId,
  ) savePageOne;

  final String email;
  final String firstName;
  final String lastName;
  final int phoneNumber;
  final int cityId;

  final void Function(int index) setPage;
  final void Function(int size, double fontSize) adaptSize;

  const AccountCreationForm({
    Key key,
    this.isDark,
    this.isFrench,
    this.isLoading,
    this.savePageOne,
    this.setPage,
    this.adaptSize,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.cityId,
  }) : super(key: key);

  @override
  AccountCreationFormState createState() => AccountCreationFormState();
}

class AccountCreationFormState extends State<AccountCreationForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail;
  String _lastName;
  String _firstName;
  int _cityId;
  int _phoneNumber;
  bool isCitySelected = false;

  String _cityText;

  @override
  void initState() {
    if (widget.cityId == null) {
      _cityText =
          widget.isFrench ? "Sélectionner votre ville" : "Select your city";
    } else {
      _cityId = widget.cityId;
      _cityText = getCityName(cityList[widget.cityId]);
      isCitySelected = true;
    }
    super.initState();
  }

  void _submitCity(int cityId, String cityName) {
    setState(() {
      _cityId = cityId;
      _cityText = cityName;
      isCitySelected = !((_cityText == "Sélectionner votre ville") ||
          (_cityText == "Select your city"));
    });
  }

  void _trySubmit(context) {
    bool isValid = _formKey.currentState.validate();

    isValid = isValid && isCitySelected;
    FocusScope.of(context).unfocus();

    if (!isCitySelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isFrench
                ? "Veulliez sélectionner une ville"
                : "You must select a city",
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    if (isValid) {
      _formKey.currentState.save();

      widget.savePageOne(
        _userEmail.trim(),
        _lastName.trim(),
        _firstName.trim(),
        _phoneNumber,
        _cityId,
      );
      widget.setPage(1);
    }

    //Use those values to send our auth request ...
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Center(
      child: Card(
        color: primaryColor(widget.isDark),
        margin:
            EdgeInsets.only(left: width * 0.1, right: width * 0.1, bottom: 5),
        child: Container(
          width: width * 0.80,
          padding: EdgeInsets.only(
              top: 16, left: width * 0.05, right: width * 0.05, bottom: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardAppearance:
                      widget.isDark ? Brightness.dark : Brightness.light,
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return widget.isFrench
                          ? 'Entrez un email valide'
                          : 'Enter a valid email';
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
                          color: secondaryColor(!widget.isDark, Palette.orange),
                          width: 4.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: secondaryColor(!widget.isDark, Palette.orange),
                          width: 2.0),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: tintColor(Palette.black, 0.1)),
                  ),
                  //onTap: () => widget.adaptTitleSize(100, 0),
                  onSaved: (value) {
                    _userEmail = value;
                  },
                  initialValue: widget.email,
                  // onFieldSubmitted: (value) {
                  //   widget.adaptTitleSize(13, 26);
                  // },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardAppearance:
                      widget.isDark ? Brightness.dark : Brightness.light,
                  key: const ValueKey('lastname'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return widget.isFrench
                          ? 'Entrez un nom valide'
                          : 'Enter a valid lastname';
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
                          color: secondaryColor(!widget.isDark, Palette.orange),
                          width: 4.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: secondaryColor(!widget.isDark, Palette.orange),
                          width: 2.0),
                    ),
                    hintText: widget.isFrench ? 'Nom' : 'Lastname',
                    hintStyle: TextStyle(color: tintColor(Palette.black, 0.1)),
                  ),
                  onSaved: (value) {
                    _lastName = value;
                  },
                  initialValue: widget.lastName,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardAppearance:
                      widget.isDark ? Brightness.dark : Brightness.light,
                  key: const ValueKey('firstname'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return widget.isFrench
                          ? 'Entrez un prénom valide'
                          : 'Enter a valid firstname';
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
                          color: secondaryColor(!widget.isDark, Palette.orange),
                          width: 4.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: secondaryColor(!widget.isDark, Palette.orange),
                          width: 2.0),
                    ),
                    hintText: widget.isFrench ? 'Prénom' : 'Firstname',
                    hintStyle: TextStyle(color: tintColor(Palette.black, 0.1)),
                  ),
                  onSaved: (value) {
                    _firstName = value;
                  },
                  initialValue: widget.firstName,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardAppearance:
                      widget.isDark ? Brightness.dark : Brightness.light,
                  key: const ValueKey('phonenumber'),
                  validator: (value) {
                    if ((value.isEmpty) && (value.length != 10)) {
                      return widget.isFrench
                          ? 'Entrez un numéro de téléphone valide'
                          : 'Enter a valid phone number';
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
                          color: secondaryColor(!widget.isDark, Palette.orange),
                          width: 4.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: secondaryColor(!widget.isDark, Palette.orange),
                          width: 2.0),
                    ),
                    hintText: widget.isFrench
                        ? 'Numéro de téléphone'
                        : 'Phone number',
                    hintStyle: TextStyle(color: tintColor(Palette.black, 0.1)),
                  ),
                  onSaved: (value) {
                    _phoneNumber = int.parse(value);
                  },
                  initialValue: (widget.phoneNumber == null)
                      ? ''
                      : widget.phoneNumber.toString(),
                ),
                const SizedBox(
                  height: 15,
                ),

                SizedBox(
                  width: width * 0.71,
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
                          cityId: 0,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isDark
                          ? isCitySelected
                              ? Palette.black
                              : Palette.orange
                          : Palette.orange,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 12,
                        bottom: 12,
                      ),
                      shape: const StadiumBorder(),
                      side: BorderSide(
                        width: 2,
                        color: shadeColor(Palette.orange, 0.4),
                      ),
                    ),
                    child: Text(
                      _cityText,
                      style: TextStyle(
                        color: widget.isDark
                            ? isCitySelected
                                ? Palette.orange
                                : Palette.black
                            : Palette.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),

                // onSaved: (value) {
                //   _cityId = int.parse(value);
                // },

                if (widget.isLoading)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AuthentificationScreen.routeName,
                              (route) => false,
                              arguments: {
                                'isFrench': widget.isFrench,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.orange,
                            padding: const EdgeInsets.all(11),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.adaptSize(13, 26);
                            _trySubmit(context);
                            //widget.setPage(1);
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
                            widget.isFrench
                                ? 'Continuer inscription'
                                : 'Continue registration',
                            style: TextStyle(
                              color: Palette.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 15,
                      color: secondaryColor(!widget.isDark, Palette.orange),
                    ),
                    Icon(
                      Icons.circle_outlined,
                      size: 10,
                      color: secondaryColor(!widget.isDark, Palette.orange),
                    ),
                    Icon(
                      Icons.circle_outlined,
                      size: 10,
                      color: secondaryColor(!widget.isDark, Palette.orange),
                    ),
                    Icon(
                      Icons.circle_outlined,
                      size: 10,
                      color: secondaryColor(!widget.isDark, Palette.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
