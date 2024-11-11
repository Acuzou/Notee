// ignore_for_file: file_names

import 'package:cuzou_app/main.dart';

import 'package:flutter/material.dart';

class ShopCreationFormFive extends StatefulWidget {
  static String routeName = 'shop-creation-form-one';
  final bool isLoading;
  final bool isDark;
  final bool isFrench;
  final void Function(
    String content,
  ) savePageFive;

  final void Function(BuildContext ctx, bool isDark, bool isFrench)
      submitCreationForm;
  final void Function(int index) setPage;

  const ShopCreationFormFive(this.isLoading, this.isDark, this.isFrench,
      this.savePageFive, this.setPage, this.submitCreationForm,
      {Key key})
      : super(key: key);

  @override
  ShopCreationFormFiveState createState() => ShopCreationFormFiveState();
}

class ShopCreationFormFiveState extends State<ShopCreationFormFive> {
  final _formKey = GlobalKey<FormState>();
  String _presentationContent = '';

  void _trySubmit() {
    bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      widget.savePageFive(_presentationContent);
      widget.submitCreationForm(
        context,
        widget.isDark,
        widget.isFrench,
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
          width: width * 0.90,
          decoration: BoxDecoration(
            color: primaryColor(widget.isDark),
          ),
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      right: height * 0.01,
                      top: height * 0.01,
                      bottom: height * 0.01),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: primaryColor(!widget.isDark),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.isFrench
                        ? 'Présentez votre magasin !'
                        : 'Introduce our shop ! ',
                    style: TextStyle(
                      color: primaryColor(!widget.isDark),
                      fontFamily: 'RebondGrotesque',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: height * 0.4,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        keyboardAppearance:
                            widget.isDark ? Brightness.dark : Brightness.light,
                        style: TextStyle(
                          color: primaryColor(!widget.isDark),
                          fontFamily: 'RebondGrotesque',
                          fontSize: 18,
                          height: 1,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),

                          fillColor: widget.isDark
                              ? tintColor(Palette.black, 0.1)
                              : shadeColor(Palette.white, 0.1),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: shadeColor(Palette.orange, 0.4),
                                width: 2.0),
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10),
                          //   borderSide:
                          //       BorderSide(color: Palette.orange, width: 2.0),
                          // ),

                          hintText: '...',
                          hintStyle: TextStyle(
                            color: shadeColor(Palette.white, 0.1),
                            fontFamily: 'RebondGrotesque',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: widget.isFrench ? 'Contenu' : 'Content',
                          labelStyle: TextStyle(
                            color: shadeColor(Palette.white, 0.1),
                            fontFamily: 'RebondGrotesque',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (value) {
                          _presentationContent = value;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                            widget.setPage(2);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            backgroundColor: Palette.orange,
                            padding: const EdgeInsets.all(11),
                            shape: const CircleBorder(),
                            side: BorderSide(
                              width: 1,
                              color: secondaryColor(
                                  !widget.isDark, Palette.orange),
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
                            //widget.setPage(2);
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
                              color: secondaryColor(
                                  !widget.isDark, Palette.orange),
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
                    Icon(Icons.circle_outlined,
                        size: 10, color: Palette.orange),
                    Icon(Icons.circle_outlined,
                        size: 10, color: Palette.orange),
                    Icon(Icons.circle_outlined,
                        size: 10, color: Palette.orange),
                    Icon(
                      Icons.circle,
                      size: 15,
                      color: Palette.orange,
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
