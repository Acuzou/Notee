import 'package:cuzou_app/authentication_file/Screen/account_creation_screen.dart';
import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  //Pointe vers _submitAuthForm
  final bool isLoading;
  final void Function(
    String email,
    String password,
    BuildContext ctx,
  ) sumbitFn;
  final void Function() forgottenPasswordClicked;
  final void Function(int size) adaptSize;
  final bool isFrench;

  const AuthForm(this.isLoading, this.sumbitFn, this.forgottenPasswordClicked,
      this.adaptSize, this.isFrench,
      {Key key})
      : super(key: key);
  @override
  AuthFormState createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userPassword = '';
  bool _passwordVisible;

  final List<FocusNode> _focusList = [
    FocusNode(debugLabel: 'focus1'),
    FocusNode(debugLabel: 'focus2'),
  ];
  int _focusIndex;

  @override
  // ignore: must_call_super
  void initState() {
    for (int i = 0; i < _focusList.length; i++) {
      _focusList[i].addListener(_onFocusChange);
    }
    _passwordVisible = false;
  }

  void _onFocusChange() {
    if (_focusList[_focusIndex].hasFocus) {
      widget.adaptSize(100);
    } else {
      widget.adaptSize(25);
    }
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      //Enlever le trim pour tester les erreurs
      widget.sumbitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        context,
      );
    }

    //Use those values to send our auth request ...
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    return Center(
      child: Container(
        width: width * 0.8,
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    focusNode: _focusList[0],
                    key: const ValueKey('id'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return widget.isFrench
                            ? 'Entrez un identifiant valide'
                            : 'Enter a valid identifier';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: shadeColor(Palette.orange, 0.3), width: 4.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Palette.orange, width: 2.0),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: tintColor(Palette.secondary, 0.1),
                        fontFamily: 'RebondGrotesque',
                      ),
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    onTap: () {
                      _focusIndex = 0;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      focusNode: _focusList[1],
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return widget.isFrench
                              ? 'Le mot de passe doit avoir au moins 7 caractères'
                              : 'The password must have at least 7 characters';
                        }
                        return null;
                      },
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: shadeColor(Palette.orange, 0.3),
                              width: 4.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Palette.orange, width: 2.0),
                        ),
                        hintText: widget.isFrench ? 'Mot de passe' : 'Password',
                        hintStyle: TextStyle(
                          color: tintColor(Palette.secondary, 0.1),
                          fontFamily: 'RebondGrotesque',
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Palette.secondary,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      onTap: () {
                        _focusIndex = 1;
                      }),
                  const SizedBox(height: 25),
                  if (widget.isLoading)
                    const CircularProgressIndicator()
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: width * 0.33,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    AccountCreationScreen.routeName,
                                    arguments: {
                                      'isFrench': widget.isFrench,
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.orange,
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 15, left: 5, right: 5),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                widget.isFrench
                                    ? 'Créer un compte'
                                    : 'Register',
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
                            width: width * 0.33,
                            child: ElevatedButton(
                              onPressed: () {
                                _trySubmit();
                                //Navigator.of(context).pushNamedAndRemoveUntil(
                                //MainScreen.routeName, (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.orange,
                                padding: const EdgeInsets.all(15),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                widget.isFrench ? 'Se connecter' : 'Login',
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
                  TextButton(
                    child: Text(
                      widget.isFrench
                          ? 'Mot de passe oublié'
                          : 'Forgotten password ',
                      style: TextStyle(
                        color: Palette.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      widget.forgottenPasswordClicked();
                      // ignore: unused_local_variable
                      // UserCredential authResult;
                      // authResult = await _auth.signInWithEmailAndPassword(
                      //   email: 'alexandrecuzou@gmail.com',
                      //   password: '123motdepasse',
                      // );
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //     MainScreen.routeName, (route) => false);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
