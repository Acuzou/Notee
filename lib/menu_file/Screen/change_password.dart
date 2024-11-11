// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';

// ignore: must_be_immutable
class ChangePasswordPage extends StatefulWidget {
  static String routeName = '/change-password-page';

  Color colorAppBar;
  bool isFrench;
  bool isDark;
  double width;
  Function(int index) setPage;

  ChangePasswordPage(
      this.colorAppBar, this.isFrench, this.isDark, this.setPage, this.width,
      {Key key})
      : super(key: key);

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  static final _formKey = GlobalKey<FormState>();
  String _userCurrentPassword = '';
  String _userNewPassword = '';
  bool _passwordVisibleOne;
  bool _passwordVisibleTwo;
  bool _passwordVisibleThree;

  bool isFrench;
  bool isDark;
  Color colorAppBar;

  // final List<FocusNode> _focusList = [
  //   FocusNode(debugLabel: 'focus1'),
  //   FocusNode(debugLabel: 'focus2'),
  //   FocusNode(debugLabel: 'focus3'),
  // ];
  //int _focusIndex;
  int pageSize = 25;

  @override
  void initState() {
    //for (int i = 0; i < _focusList.length; i++) {
    //_focusList[i].addListener(_onFocusChange);
    //}
    _passwordVisibleOne = false;
    _passwordVisibleTwo = false;
    _passwordVisibleThree = false;

    colorAppBar = widget.colorAppBar;
    isDark = widget.isDark;
    isFrench = widget.isFrench;

    super.initState();
  }

  // void _onFocusChange() {
  //   if (_focusList[_focusIndex].hasFocus) {
  //     setState(() {
  //       pageSize = 100;
  //     });
  //   } else {
  //     setState(() {
  //       pageSize = 25;
  //     });
  //   }
  // }

  //@override
  // void dispose() {
  //   super.dispose();
  //   for (int i = 0; i < _focusList.length; i++) {
  //     _focusList[i].removeListener(_onFocusChange);
  //     _focusList[i].dispose();
  //   }
  // }

  void _trySubmit(bool isFrench, BuildContext context) async {
    bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    //Vérifie sur le mot de passe tapé est le bon
    var auth = FirebaseAuth.instance.currentUser;
    var authCredentials = EmailAuthProvider.credential(
        email: auth.email, password: _userCurrentPassword.trim());

    try {
      var authResult = await auth.reauthenticateWithCredential(authCredentials);

      isValid = isValid && (authResult.user != null);

      if (isValid) {
        _formKey.currentState.save();

        String message = isFrench
            ? 'Le changement de votre mot de passe a fonctionné'
            : 'The change of your password worked';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(
                color: Palette.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
          ),
        );

        auth.updatePassword(_userNewPassword);

        Navigator.of(context).pop();
      } else {
        String message = isFrench
            ? 'Le mot de passe actuel écrit est erroné'
            : 'Your current password written is wrong';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(
                color: Palette.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    } catch (e) {
      String message = isFrench
          ? 'Une erreur est arrivée !\nVeulliez vérifier votre justificatif'
          : 'An error occurs !\n Please, check your credential';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Palette.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //width: width * 0.80,
        padding: EdgeInsets.only(
            top: 16,
            left: widget.width * 0.05,
            right: widget.width * 0.05,
            bottom: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 40,
              ),
              child: Text(
                isFrench
                    ? 'Entrez votre mot de passe\npour le réinitialiser'
                    : 'Enter your password\n to reset it',
                style: TextStyle(
                    color: primaryColor(!isDark),
                    fontFamily: "RebondGrotesque",
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Flexible(
            flex: pageSize,
            child: Container(
              width: widget.width * 0.8,
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                        //focusNode: _focusList[0],
                        key: const ValueKey('current_password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return isFrench
                                ? 'Le mot de passe doit avoir au moins 7 caractères'
                                : 'The password must have at least 7 characters';
                          }
                          return null;
                        },
                        obscureText: !_passwordVisibleOne,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: secondaryColor(
                                    !widget.isDark, Palette.orange),
                                width: 4.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: secondaryColor(
                                    !widget.isDark, Palette.orange),
                                width: 2.0),
                          ),
                          hintText: isFrench
                              ? 'Mot de passe actuel'
                              : 'Current password',
                          hintStyle: TextStyle(
                            color: tintColor(Palette.secondary, 0.1),
                            fontFamily: 'RebondGrotesque',
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisibleOne
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Palette.secondary,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisibleOne = !_passwordVisibleOne;
                              });
                            },
                          ),
                        ),
                        onSaved: (value) {
                          _userCurrentPassword = value;
                        },
                        onTap: () {
                          //_focusIndex = 0;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        //focusNode: _focusList[1],
                        key: const ValueKey('new_password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return isFrench
                                ? 'Le mot de passe doit avoir au moins 7 caractères'
                                : 'The password must have at least 7 characters';
                          }
                          return null;
                        },
                        obscureText: !_passwordVisibleTwo,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: secondaryColor(
                                    !widget.isDark, Palette.orange),
                                width: 4.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: secondaryColor(
                                    !widget.isDark, Palette.orange),
                                width: 2.0),
                          ),
                          hintText: isFrench
                              ? 'Nouveau mot de passe'
                              : 'New password',
                          hintStyle: TextStyle(
                            color: tintColor(Palette.secondary, 0.1),
                            fontFamily: 'RebondGrotesque',
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisibleTwo
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Palette.secondary,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisibleTwo = !_passwordVisibleTwo;
                              });
                            },
                          ),
                        ),
                        onSaved: (value) {
                          _userNewPassword = value;
                        },
                        onTap: () {
                          //_focusIndex = 1;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        //focusNode: _focusList[2],
                        key: const ValueKey('conf_password'),
                        validator: (value) {
                          if (value != _userNewPassword) {
                            return isFrench
                                ? 'Confirmation de mot de passe invalide'
                                : 'Invalid password confirmation';
                          }
                          return null;
                        },
                        obscureText: !_passwordVisibleThree,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: secondaryColor(
                                    !widget.isDark, Palette.orange),
                                width: 4.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: secondaryColor(
                                    !widget.isDark, Palette.orange),
                                width: 2.0),
                          ),
                          hintText: isFrench ? 'Mot de passe' : 'Password',
                          hintStyle: TextStyle(
                            color: tintColor(Palette.secondary, 0.1),
                            fontFamily: 'RebondGrotesque',
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisibleThree
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Palette.secondary,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisibleThree = !_passwordVisibleThree;
                              });
                            },
                          ),
                        ),
                        onSaved: (value) {},
                        onTap: () {
                          //_focusIndex = 2;
                        }),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: widget.width * 0.33,
                            child: ElevatedButton(
                              onPressed: () {
                                widget.setPage(0);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor: widget.colorAppBar,
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 15,
                                  bottom: 15,
                                ),
                                shape: const StadiumBorder(),
                                side: BorderSide(
                                  width: 1,
                                  color: secondaryColor(
                                      !widget.isDark, widget.colorAppBar),
                                ),
                              ),
                              child: Text(
                                isFrench ? 'Retour' : 'Return',
                                style: TextStyle(
                                  color: Palette.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: widget.width * 0.33,
                            child: ElevatedButton(
                              onPressed: () {
                                _trySubmit(isFrench, context);
                                //Navigator.of(context).pushNamedAndRemoveUntil(
                                //MainScreen.routeName, (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor: widget.colorAppBar,
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 15,
                                  bottom: 15,
                                ),
                                shape: const StadiumBorder(),
                                side: BorderSide(
                                  width: 1,
                                  color: secondaryColor(
                                      !widget.isDark, widget.colorAppBar),
                                ),
                              ),
                              child: Text(
                                isFrench ? 'Valider' : 'Validate',
                                style: TextStyle(
                                  color: Palette.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
