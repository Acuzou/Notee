// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:cuzou_app/authentication_file/Screen/authentification_screen.dart';
import 'package:cuzou_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Data/menu_data.dart';
import 'package:cuzou_app/research_file/Model/shop.dart';

// ignore: must_be_immutable
class MenuItemNotee extends StatefulWidget {
  final IconData icon;
  final String title;
  final int itemId;
  final int myId;
  final int shopId;
  final bool isDark;
  final Color colorAppBar;
  final bool isFrench;

  const MenuItemNotee({
    Key key,
    this.icon,
    this.title,
    this.itemId,
    this.myId,
    this.shopId,
    this.isDark,
    this.colorAppBar,
    this.isFrench,
  }) : super(key: key);

  @override
  MenuItemNoteeState createState() => MenuItemNoteeState();
}

class MenuItemNoteeState extends State<MenuItemNotee> {
  final List<String> itemList = menuPages;
  bool isInit = true;
  bool isHovering = false;
  Color colorItem;

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
        AuthentificationScreen.routeName, (route) => false,
        arguments: {
          'isFrench': widget.isFrench,
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    if (isInit || !isHovering) {
      colorItem = widget.colorAppBar;
      isInit = false;
    }

    return Material(
      color: primaryColor(widget.isDark),
      child: InkWell(
        splashColor: widget.colorAppBar,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.01),
          width: width * 0.5,
          child: ElevatedButton(
            //autofocus: true, //Fucking Autofocus //Cause du problème du clavier
            //hoverColor: shadeColor(Palette.primary, 0.6),
            onPressed: () {
              widget.itemId != 4
                  ? Navigator.of(context)
                      .pushNamed(itemList[widget.itemId], arguments: {
                      'shopId': widget.shopId,
                      'myId': widget.myId,
                      'type': SubCat.Default,
                      'isDark': widget.isDark,
                      'colorAppBar': widget.colorAppBar,
                      'isFrench': widget.isFrench,
                    })
                  : logout();
            },
            onHover: (hovering) {
              setState(() => isHovering = hovering);
            },
            style: ElevatedButton.styleFrom(
                elevation: 4,
                backgroundColor: widget.itemId == 4
                    ? secondaryColor(!widget.isDark,
                        isHovering ? shadeColor(colorItem, 0.2) : colorItem)
                    : secondaryColor(widget.isDark,
                        isHovering ? shadeColor(colorItem, 0.2) : colorItem),
                padding: const EdgeInsets.all(10),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 1,
                  color: widget.isDark ? widget.colorAppBar : Palette.black,
                )),
            // child: AnimatedContainer(
            //   duration: const Duration(milliseconds: 200),
            //   curve: Curves.ease,
            //   //padding: EdgeInsets.all(isHovering ? 15 : 8),
            //   decoration: BoxDecoration(
            //     color: widget.itemId == 5
            //         ? widget.isHovering
            //             ? tintColor(
            //                 secondaryColor(!widget.isDark, widget.colorAppBar),
            //                 0.4,
            //               )
            //             : secondaryColor(!widget.isDark, widget.colorAppBar)
            //         : widget.isHovering
            //             ? tintColor(
            //                 secondaryColor(widget.isDark, widget.colorAppBar),
            //                 0.4,
            //               )
            //             : secondaryColor(widget.isDark, widget.colorAppBar),
            //   ),
            //   child:
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   widget.icon,
                //   color: (widget.isDark) ? Colors.white : Colors.black,
                // ),
                // const SizedBox(width: 20),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.itemId == 4
                        ? secondaryColor(widget.isDark, widget.colorAppBar)
                        : secondaryColor(!widget.isDark, widget.colorAppBar),
                    fontSize: 18,
                    fontFamily: 'RebondGrotesque',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
