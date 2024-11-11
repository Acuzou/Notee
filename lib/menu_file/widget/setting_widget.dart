import 'package:flutter/material.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:cuzou_app/main.dart';

// ignore: must_be_immutable
class SettingWidgets extends StatefulWidget {
  bool isDark;
  bool isFrench;
  bool isNotificationOn;
  Function saveSetting;
  Color colorAppBar;

  SettingWidgets(
      {Key key,
      this.isDark,
      this.isFrench,
      this.isNotificationOn,
      this.saveSetting,
      this.colorAppBar})
      : super(key: key);
  @override
  State<SettingWidgets> createState() => _SettingWidgetsState();
}

class _SettingWidgetsState extends State<SettingWidgets> {
  Color textColor;
  Color backgroundColor;
  Color borderColor;
  bool initNotification;
  bool initLanguage;

  @override
  // ignore: must_call_super
  void initState() {
    textColor = secondaryColor(!widget.isDark, widget.colorAppBar);
    backgroundColor = primaryColor(widget.isDark);
    borderColor = secondaryColor(!widget.isDark, widget.colorAppBar);
    initNotification = widget.isNotificationOn;
    initLanguage = widget.isFrench;
  }

  void _setTheme(isDark) {
    setState(() {
      widget.isDark = isDark;
    });
  }

  void _setNotification(isNotifOn) {
    setState(() {
      widget.isNotificationOn = isNotifOn;
    });
  }

  void _setLanguage(isFrench) {
    setState(() {
      widget.isFrench = isFrench;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;

    return Column(
      children: <Widget>[
        SizedBox(
          height: height * 0.02,
        ),
        SwitchListTile(
          title: Text(
            'Notification',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'RebondGrotesque',
            ),
          ),
          value: widget.isNotificationOn,
          subtitle: Text(
            initLanguage
                ? 'Désactiver / Activer les notifications'
                : 'Desactivate / Activate notifications',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontFamily: 'RebondGrotesque',
            ),
          ),
          onChanged: (newValue) {
            _setNotification(newValue);
          },
          activeColor: textColor,
          inactiveThumbColor: tintColor(textColor, 0.8),
          inactiveTrackColor: shadeColor(Palette.blue, 0.8),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        SwitchListTile(
          title: Text(
            initLanguage ? 'Thème' : 'Theme',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'RebondGrotesque',
            ),
          ),
          value: widget.isDark,
          subtitle: Text(
            initLanguage ? 'Clair / Sombre' : 'Light / Dark',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontFamily: 'RebondGrotesque',
            ),
          ),
          onChanged: (newValue) {
            _setTheme(newValue);
          },
          activeColor: textColor,
          inactiveThumbColor: tintColor(textColor, 0.8),
          inactiveTrackColor: shadeColor(Palette.blue, 0.8),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        //Language
        SizedBox(
          height: height * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //French Button

              Text(
                initLanguage ? "Language" : "Langage",
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RebondGrotesque',
                ),
              ),

              //French Button
              ElevatedButton(
                onPressed: () {
                  widget.isFrench
                      ? _setLanguage(widget.isFrench)
                      : _setLanguage(!widget.isFrench);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: backgroundColor,
                  foregroundColor: shadeColor(Palette.secondary, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(
                    width: 2,
                    color: widget.isFrench ? borderColor : backgroundColor,
                  ),
                ),
                child: Image.asset('assets/images/logos/flags/french_flag.png',
                    fit: BoxFit.cover),
              ),

              //English Button
              ElevatedButton(
                onPressed: () {
                  widget.isFrench
                      ? _setLanguage(!widget.isFrench)
                      : _setLanguage(widget.isFrench);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: backgroundColor,
                  foregroundColor: shadeColor(Palette.secondary, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(
                    width: 2,
                    color: widget.isFrench ? backgroundColor : borderColor,
                  ),
                  //padding: const EdgeInsets.all(20),
                  //shape: const StadiumBorder(),
                ),
                child: Image.asset('assets/images/logos/flags/english_flag.png',
                    fit: BoxFit.cover),
              ),
            ],
          ),
        ),
        //Save Button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                width: 1,
                color: borderColor,
              ),
              shape: const StadiumBorder(),
              elevation: 5,
              backgroundColor: primaryColor(widget.isDark),
              foregroundColor: textColor,
            ),
            onPressed: () {
              widget.saveSetting(
                widget.isDark,
                widget.isNotificationOn,
                widget.isFrench,
                context,
              );
              Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.routeName,
                (route) => false,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.save,
                      size: 30, color: primaryColor(!widget.isDark)),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    initLanguage
                        ? 'Sauvegarder ces paramètres'
                        : 'Save settings',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'RebondGrotesque',
                        color: primaryColor(!widget.isDark)),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            // style: ElevatedButton.styleFrom(
            //   //padding: EdgeInsets.all(10),
            //   shape: const StadiumBorder(),
            // ),
          ),
        ),
      ],
    );
  }
}
