// ignore_for_file: file_names

import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';

class AccountCreationFormTwo extends StatefulWidget {
  final bool isLoading;
  final bool isFrench;
  final bool isDark;
  final void Function(
    String password,
  ) savePageTwo;

  final String passWord;
  final bool isPasswordEntered;

  final void Function(int index) setPage;
  final void Function(int size, double fontSize) adaptSize;

  const AccountCreationFormTwo({
    Key key,
    this.isDark,
    this.isFrench,
    this.isLoading,
    this.savePageTwo,
    this.setPage,
    this.adaptSize,
    this.passWord,
    this.isPasswordEntered,
  }) : super(key: key);

  @override
  AccountCreationFormTwoState createState() => AccountCreationFormTwoState();
}

class AccountCreationFormTwoState extends State<AccountCreationFormTwo> {
  final _formKey = GlobalKey<FormState>();
  String _userPassword = "";
  bool _passwordVisibleOne;
  bool _passwordVisibleTwo;
  // final List<FocusNode> _focusList = [
  //   FocusNode(debugLabel: 'focus1'),
  //   FocusNode(debugLabel: 'focus2'),
  // ];
  // int _focusIndex;

  @override
  void initState() {
    _userPassword = widget.passWord;
    // for (int i = 0; i < _focusList.length; i++) {
    //   _focusList[i].addListener(_onFocusChange);
    // }
    _passwordVisibleOne = false;
    _passwordVisibleTwo = false;
    super.initState();
  }

  // void _onFocusChange() {
  //   if (_focusList[_focusIndex].hasFocus) {
  //     widget.adaptSize(100, 0);
  //   } else {
  //     widget.adaptSize(13, 26);
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   for (int i = 0; i < _focusList.length; i++) {
  //     _focusList[i].removeListener(_onFocusChange);
  //     _focusList[i].dispose();
  //   }
  // }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      //Enlever le trim pour tester les erreurs
      widget.savePageTwo(
        _userPassword.trim(),
      );
      widget.setPage(2);
    }

    //Use those values to send our auth request ...
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return Center(
      child: Card(
        color: primaryColor(widget.isDark),
        margin:
            EdgeInsets.only(left: width * 0.1, right: width * 0.1, bottom: 5),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 16, left: width * 0.05, right: width * 0.05, bottom: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 54),
                  Text(
                    widget.isFrench
                        ? 'Veuillez saisir votre\nmot de passe'
                        : 'Please insert\nyour password',
                    style: TextStyle(
                      color: primaryColor(!widget.isDark),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    //focusNode: _focusList[0],
                    textInputAction: TextInputAction.next,
                    keyboardAppearance:
                        widget.isDark ? Brightness.dark : Brightness.light,
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return widget.isFrench
                            ? 'Le mot de passe doit avoir au moins 7 caractères'
                            : 'The password must have at least 7 characters';
                      }
                      return null;
                    },
                    obscureText: !_passwordVisibleOne,
                    decoration: InputDecoration(
                      fillColor: Palette.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color:
                                secondaryColor(!widget.isDark, Palette.orange),
                            width: 4.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color:
                                secondaryColor(!widget.isDark, Palette.orange),
                            width: 2.0),
                      ),
                      hintText: widget.isFrench ? 'Mot de passe' : 'Password',
                      hintStyle:
                          TextStyle(color: tintColor(Palette.black, 0.1)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisibleOne
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Palette.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisibleOne = !_passwordVisibleOne;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      _userPassword = value;
                    },
                    // onTap: () {
                    //   _focusIndex = 0;
                    // },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    //focusNode: _focusList[1],
                    keyboardAppearance:
                        widget.isDark ? Brightness.dark : Brightness.light,
                    key: const ValueKey('conf_passeword'),
                    validator: (value) {
                      if ((value.trim() != _userPassword.trim())) {
                        return widget.isFrench
                            ? 'Confirmation de mot de passe invalide'
                            : 'Invalid password confirmation';
                      }
                      return null;
                    },
                    obscureText: !_passwordVisibleTwo,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: Palette.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color:
                                secondaryColor(!widget.isDark, Palette.orange),
                            width: 4.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color:
                                secondaryColor(!widget.isDark, Palette.orange),
                            width: 2.0),
                      ),
                      hintText: widget.isFrench
                          ? 'Confirmation du mot de passe'
                          : 'Password confirmation',
                      hintStyle:
                          TextStyle(color: tintColor(Palette.black, 0.1)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisibleTwo
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Palette.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisibleTwo = !_passwordVisibleTwo;
                          });
                        },
                      ),
                    ),
                    onSaved: (value) {},
                    // onTap: () {
                    //   _focusIndex = 1;
                    // },
                  ),
                  const SizedBox(
                    height: 57,
                  ),
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
                              widget.setPage(0);
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
                              _trySubmit();
                              //widget.setPage(2);
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
                        Icons.circle_outlined,
                        size: 10,
                        color: secondaryColor(!widget.isDark, Palette.orange),
                      ),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
