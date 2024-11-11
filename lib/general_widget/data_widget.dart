import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';

Hero researchBar(
  bool isDark,
  bool isFrench,
  bool isHomeButton,
  bool isCityResearch,
  Function(String value) updateDisplay,
  TextEditingController controller,
) {

  double topPadding;
  double bottomPadding;
  if (isCityResearch) { 
    topPadding = 0;
    bottomPadding = 20;
  } else { 
    topPadding = 15;
    bottomPadding = 10;
  }
  return Hero(
    tag: 'Searching',
    child: Material(
      color: primaryColor(isDark),
      child: Container(
        color: isCityResearch
            ? tintColor(Palette.black, 0.01)
            : primaryColor(isDark),
        padding:
            EdgeInsets.only(right: 10, left: 10, top: topPadding, bottom: bottomPadding),
        child: TextField(
          keyboardAppearance: isDark ? Brightness.dark : Brightness.light,
          style: TextStyle(
            color: primaryColor(!isDark),
            fontFamily: 'RebondGrotesque',
            fontSize: 18,
            height: 1,
          ),
          //obscureText: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: (isCityResearch)
                  ? Palette.orange
                  : (isDark)
                      ? shadeColor(Palette.white, 0.3)
                      : tintColor(Palette.black, 0.3),
            ),
            fillColor: primaryColor(isDark),
            filled: true,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                  color: (isCityResearch)
                      ? Palette.orange
                      : primaryColor(!isDark).withOpacity(0.7),
                  width: 1.0),
            ),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(50),
            //   borderSide: BorderSide(
            //       color: primaryColor(!isDark).withOpacity(1), width: 1.2),
            // ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                  color: primaryColor(!isDark).withOpacity(0.7), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                  color: (isCityResearch)
                      ? Palette.orange
                      : primaryColor(!isDark).withOpacity(1),
                  width: 2),
            ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(50),
            //   borderSide: BorderSide(
            //       color: primaryColor(!isDark).withOpacity(0.7), width: 1.0),
            // ),
            hintText: isFrench ? 'Rechercher' : 'Search',
            hintStyle: TextStyle(
              color: shadeColor(primaryColor(!isDark), 0.4),
            ),
          ),
          controller: controller,

          //onChanged: (val) => titleInput = val,
          //onSubmitted: (_) => researchShop,
          enabled: !isHomeButton,
          onChanged: (value) => updateDisplay(value),
          //initialValue: initialValue,
          // onTap: () {
          //   print("IS TAPPED");
          // }),
        ),
      ),
    ),
  );
}

Hero drawerHeader(
  double radius,
  bool isDark,
  bool isDefaultProfilPhoto,
  Color color,
  NetworkImage networkImage,
) {
  return Hero(
    tag: 'DrawerHeader',
    child: CircleAvatar(
        radius: radius,
        backgroundColor: color,
        backgroundImage:
            // _profilePictureFile != null
            //     ? FileImage(_profilePictureFile)
            //     :
            (isDefaultProfilPhoto)
                ? const AssetImage("assets/images/logos/logo_profile.png")
                : networkImage,
      
    ),
  );
}

