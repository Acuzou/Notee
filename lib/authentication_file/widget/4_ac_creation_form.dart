// ignore_for_file: file_names

import 'package:cuzou_app/main.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Data/user_data.dart';

class AccountCreationFormFour extends StatefulWidget {
  //Pointe vers _submitAuthForm
  final bool isFrench;
  final bool isDark;
  final bool isLoading;
  final void Function(
    bool isDark,
    int userId,
  ) savePageFour;

  final void Function(int index) setPage;

  final void Function(BuildContext ctx) submitCreationForm;

  final void Function(bool isLight) setThemeLight;

  const AccountCreationFormFour({
    Key key,
    this.isDark,
    this.isFrench,
    this.isLoading,
    this.savePageFour,
    this.setPage,
    this.submitCreationForm,
    this.setThemeLight,
  }) : super(key: key);
  @override
  AccountCreationFormFourState createState() => AccountCreationFormFourState();
}

class AccountCreationFormFourState extends State<AccountCreationFormFour> {
  final _formKey = GlobalKey<FormState>();

  bool _isDark = true;
  int _userId = 0;

  @override
  void initState() {
    _isDark = widget.isDark;
    super.initState();
  }

  void setTheme(bool newTheme) {
    setState(() {
      _isDark = newTheme;
      widget.setThemeLight(newTheme);
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      //Enlever le trim pour tester les erreurs
      widget.savePageFour(
        _isDark,
        _userId,
      );
      widget.submitCreationForm(context);
    }

    //Use those values to send our auth request ...
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<QueryDocumentSnapshot> usersDocs = userSnapshot.data.docs;

          _userId = generatePrimaryKeyFromUser(usersDocs);

          return Center(
            child: Card(
              color: primaryColor(_isDark),
              margin: EdgeInsets.only(
                  left: width * 0.1, right: width * 0.1, bottom: 5),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 16,
                      left: width * 0.05,
                      right: width * 0.05,
                      bottom: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.isFrench
                              ? 'Quel thème préférez-vous ?'
                              : 'What theme do you prefer ?',
                          style: TextStyle(
                            color: primaryColor(!_isDark),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    widget.isFrench
                                        ? 'Thème sombre'
                                        : 'Dark Theme',
                                    style: TextStyle(
                                      color: primaryColor(!_isDark),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  ElevatedButton(
                                    onPressed: () {
                                      _isDark
                                          ? setTheme(_isDark)
                                          : setTheme(!_isDark);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor(_isDark),
                                      foregroundColor: primaryColor(!_isDark),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      side: BorderSide(
                                        width: 2,
                                        color: _isDark
                                            ? Palette.blue
                                            : Palette.white,
                                      ),
                                    ),
                                    child: Container(
                                      height: 160,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20),

                                      //child: Container(),
                                      child: Image.asset(
                                          'assets/images/logos/darkthemeexample.png',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                              // VerticalDivider(
                              //     thickness: 2, color: primaryColor(!_isDark)),
                              Column(
                                children: [
                                  Text(
                                    widget.isFrench
                                        ? 'Thème clair'
                                        : 'Light Theme',
                                    style: TextStyle(
                                      color: primaryColor(!_isDark),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  ElevatedButton(
                                    onPressed: () {
                                      _isDark
                                          ? setTheme(!_isDark)
                                          : setTheme(_isDark);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor(_isDark),
                                      foregroundColor: primaryColor(!_isDark),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      side: BorderSide(
                                          width: 2, color: Palette.black),
                                    ),
                                    child: Container(
                                      height: 160,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(
                                      //     color: Palette.secondary,
                                      //     width: 2,
                                      //   ),
                                      // ),
                                      //child: Container(),
                                      child: Image.asset(
                                          'assets/images/logos/lightthemeexample.png',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        // Language(
                        //     _isFrench, setLanguage, Colors.black, Palette.primary),
                        const SizedBox(
                          height: 20,
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
                                    widget.setPage(2);
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
                                    _trySubmit();
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
                                      color: Palette.secondary,
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
                              color: secondaryColor(!_isDark, Palette.orange),
                            ),
                            Icon(
                              Icons.circle_outlined,
                              size: 10,
                              color: secondaryColor(!_isDark, Palette.orange),
                            ),
                            Icon(
                              Icons.circle_outlined,
                              size: 10,
                              color: secondaryColor(!_isDark, Palette.orange),
                            ),
                            Icon(
                              Icons.circle,
                              size: 15,
                              color: secondaryColor(!_isDark, Palette.orange),
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
        });
  }
}
