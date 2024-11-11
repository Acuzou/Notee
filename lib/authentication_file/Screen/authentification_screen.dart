// ignore_for_file: use_build_context_synchronously

import 'package:cuzou_app/authentication_file/widget/auth_form.dart';
import 'package:cuzou_app/authentication_file/widget/forgotten_password_page.dart';
import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthentificationScreen extends StatefulWidget {
  static const routeName = '/authentification-screen-route';

  final bool isInit;

  const AuthentificationScreen({Key key, this.isInit}) : super(key: key);
  @override
  AuthentificationScreenState createState() => AuthentificationScreenState();
}

class AuthentificationScreenState extends State<AuthentificationScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool _isFrench = true;
  Color borderColor = Palette.blue;
  final bool _isDark = true;
  bool _showLanguageButton = false;

  bool _showPasswordForgottenPage = false;

  int pageSize = 25;
  bool _seeModalRoute = false;

  @override
  void initState() {
    super.initState();
    if (widget.isInit) {
      _isFrench = widget.isInit;
    } else {
      _seeModalRoute = true;
    }
  }

  void _adaptSize(int newSize) {
    setState(() {
      pageSize = newSize;
    });
  }

  void _setLanguageButton(showLanguageButton) {
    setState(() {
      _showLanguageButton = showLanguageButton;
    });
  }

  void _setLanguage(isFrench) {
    setState(() {
      _isFrench = isFrench;
      _seeModalRoute = false;
    });
  }

  void _forgottenPasswordClicked() {
    setState(() {
      _showPasswordForgottenPage = true;
    });
  }

  void _returnAuthForm() {
    setState(() {
      _showPasswordForgottenPage = false;
    });
  }

  void _submitPasswordModification(
    String email,
    BuildContext ctx,
  ) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      String message = _isFrench
          ? 'Un lien pour réinitialiser votre\nmot de passe vous a été envoyé par mail !\nVeuilliez vérifiez vos spam'
          : 'link has been sent to your\nemail for password reset !\n Please check your spam';

      ScaffoldMessenger.of(ctx).showSnackBar(
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
    }).catchError((error) {
      String message = 'An error occured, pleased check your credentials !';
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Palette.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    });

    setState(() {
      _showPasswordForgottenPage = false;
    });
  }

  void _submitAuthForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.of(ctx)
          .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
    } on PlatformException catch (err) {
      var message = 'An error occured, pleased check your credentials !';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Palette.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException {
      var message = _isFrench
          ? 'Identification invalide, veuillez recommencer !'
          : 'Invalid authentification, please try again !';

      // if (err.message != null) {
      //   message = err.message;
      // }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Palette.black,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_seeModalRoute) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      _isFrench = routeArgs['isFrench'] as bool;
    }

    return Scaffold(
      backgroundColor: Palette.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Flexible(
              flex: 1,
              child: SizedBox(height: 40),
            ),
            Flexible(
              flex: 30,
              child: Container(
                margin: const EdgeInsets.only(top: 50, bottom: 50),
                height: 90,
                child: Image.asset(
                    'assets/images/logos/logo_notee/logo_blanc.png',
                    fit: BoxFit.cover),
              ),
            ),
            Flexible(
              flex: pageSize,
              child: (_showPasswordForgottenPage)
                  ? ForgottenPasswordPage(
                      isLoading,
                      _submitPasswordModification,
                      _returnAuthForm,
                      _adaptSize,
                      _isFrench,
                    )
                  : AuthForm(
                      isLoading,
                      _submitAuthForm,
                      _forgottenPasswordClicked,
                      _adaptSize,
                      _isFrench,
                    ),
            ),
            Flexible(
              flex: 5,
              child: Stack(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Center(
                      //heightFactor: 10,
                      child: Container(
                        margin: const EdgeInsets.only(right: 40),
                        child: IconButton(
                            onPressed: () {
                              _setLanguageButton(!_showLanguageButton);
                            },
                            icon: Icon(
                              Icons.language,
                              size: 40,
                              color: Palette.white,
                            )),
                      ),
                    )
                  ]),
                  (_showLanguageButton)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //French Button
                            Container(
                              height: 60,
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  _isFrench
                                      ? _setLanguage(_isFrench)
                                      : _setLanguage(!_isFrench);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      shadeColor(Palette.secondary, 1),
                                  backgroundColor: primaryColor(_isDark),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(
                                    width: 2,
                                    color: _isFrench
                                        ? borderColor
                                        : primaryColor(_isDark),
                                  ),
                                ),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Image.asset(
                                      'assets/images/logos/flags/french_flag.png',
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),

                            //English Button
                            Container(
                              height: 60,
                              margin: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  _isFrench
                                      ? _setLanguage(!_isFrench)
                                      : _setLanguage(_isFrench);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      shadeColor(Palette.secondary, 1),
                                  elevation: 5,
                                  backgroundColor: primaryColor(_isDark),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(
                                    width: 2,
                                    color: _isFrench
                                        ? primaryColor(_isDark)
                                        : borderColor,
                                  ),
                                  //padding: const EdgeInsets.all(20),
                                  //shape: const StadiumBorder(),
                                ),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Image.asset(
                                      'assets/images/logos/flags/english_flag.png',
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
