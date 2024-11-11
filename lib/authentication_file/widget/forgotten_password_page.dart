import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';

class ForgottenPasswordPage extends StatefulWidget {
  //Pointe vers _submitAuthForm
  final bool isLoading;
  final void Function(
    String email,
    BuildContext ctx,
  ) submitPasswordModification;
  final void Function() returnAuthForm;
  final void Function(
    int size,
  ) adaptSize;
  final bool isFrench;

  const ForgottenPasswordPage(this.isLoading, this.submitPasswordModification,
      this.returnAuthForm, this.adaptSize, this.isFrench,
      {Key key})
      : super(key: key);
  @override
  ForgottenPasswordPageState createState() => ForgottenPasswordPageState();
}

class ForgottenPasswordPageState extends State<ForgottenPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';

  final FocusNode focus = FocusNode(debugLabel: 'focus1');

  @override
  void initState() {
    focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    if (focus.hasFocus) {
      widget.adaptSize(100);
    } else {
      widget.adaptSize(25);
    }
  }

  @override
  void dispose() {
    super.dispose();
    focus.removeListener(_onFocusChange);
    focus.dispose();
  }

  void _trySubmit(context) {
    final bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      //Enlever le trim pour tester les erreurs
      widget.submitPasswordModification(
        _userEmail.trim(),
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
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: Text(
                widget.isFrench
                    ? 'Entrez votre adresse email\npour réinitialiser votre mot passe'
                    : 'Enter your email\n to reset your password',
                style: TextStyle(
                    color: Palette.white,
                    fontFamily: "RebondGrotesque",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    focusNode: focus,
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                                widget.returnAuthForm();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.orange,
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 15, left: 5, right: 5),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                widget.isFrench ? 'Retour' : 'Return',
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
                                _trySubmit(context);
                                //Navigator.of(context).pushNamedAndRemoveUntil(
                                //MainScreen.routeName, (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.orange,
                                padding: const EdgeInsets.all(15),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                widget.isFrench ? 'Valider' : 'Validate',
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
          ],
        ),
      ),
    );
  }
}
