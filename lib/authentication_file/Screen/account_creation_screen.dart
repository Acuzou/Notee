import 'package:cuzou_app/main.dart';
import 'package:cuzou_app/main_switch.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/1_ac_creation_form.dart';
import '../widget/3_ac_creation_form.dart';
import '../widget/2_ac_creation_form.dart';
import '../widget/4_ac_creation_form.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AccountCreationScreen extends StatefulWidget {
  static const String routeName = '/account-creation-form-screen';

  const AccountCreationScreen({Key key}) : super(key: key);
  @override
  AccountCreationScreenState createState() => AccountCreationScreenState();
}

class AccountCreationScreenState extends State<AccountCreationScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  int pageIndex = 0;

  bool _isDark;
  Color borderColor = Palette.blue;
  bool _isFrench;
  File _profilePictureFile;

  String _userEmail;
  String _userPassword;
  String _lastName;
  String _firstName;
  int _phoneNumber;

  int _cityId;

  @override
  void initState() {
    _isDark = true;
    super.initState();
  }

  int _userId = 0;
  int pageSize = 13;
  double fontSizeTitle = 26;

  void adaptSize(int newSize, double newfontSize) {
    setState(() {
      pageSize = newSize;
      fontSizeTitle = newfontSize;
    });
  }

  void _setThemeLight(isDark) {
    setState(() {
      _isDark = isDark;
      borderColor = secondaryColor(!isDark, Palette.blue);
    });
  }

  void _setPage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void _savePageOne(String email, String lastName, String firstName,
      int phoneNumber, int cityId) {
    _userEmail = email;
    _lastName = lastName;
    _firstName = firstName;
    _phoneNumber = phoneNumber;
    _cityId = cityId;
  }

  void _savePageTwo(String password) {
    _userPassword = password;
  }

  void _savePageThree(File photoFile) {
    _profilePictureFile = photoFile;
  }

  void _savePageFour(bool isDark, int userId) {
    _isDark = isDark;
    _userId = userId;
  }

  void _submitCreationForm(
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        isLoading = true;
      });

      var message = _isFrench
          ? 'Création de compte Notee en cours... \nAssurez-vous d\'être connecté(e) à Internet !'
          : 'Creation of Notee account in processing... \nMake sure to be connected on the Internet !';

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
          backgroundColor: Colors.green,
        ),
      );

      authResult = await _auth.createUserWithEmailAndPassword(
        email: _userEmail,
        password: _userPassword,
      );

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${authResult.user.uid}jpg');

      await ref.putFile(_profilePictureFile);

      final imageShopUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .set({
        'ID': _userId,
        'email': _userEmail,
        'lastname': _lastName,
        'firstname': _firstName,
        'phoneNumber': _phoneNumber,
        'cityId': _cityId,
        'isMerchant': false,
        'shopId': 0,
        'isFrench': _isFrench,
        'isDark': _isDark,
        'isNotificationOn': true,
        'isBan': false,
        'profilPictureUrl': imageShopUrl
      });

      authResult = await _auth.signInWithEmailAndPassword(
          email: _userEmail, password: _userPassword);

      // ignore: use_build_context_synchronously
      Navigator.of(ctx)
          .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
    } on PlatformException catch (err) {
      var message = 'An error occured, pleased check your credentials !';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
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
    Size size = MediaQuery.of(context).size;
    double height = size.height;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    _isFrench = routeArgs['isFrench'] as bool;

    List<Widget> pages = [
      AccountCreationForm(
        isDark: _isDark,
        isFrench: _isFrench,
        isLoading: isLoading,
        savePageOne: _savePageOne,
        setPage: _setPage,
        adaptSize: adaptSize,
        email: _userEmail,
        lastName: _lastName,
        firstName: _firstName,
        phoneNumber: _phoneNumber,
        cityId: _cityId,
        //_onChange,
      ),
      AccountCreationFormTwo(
        isDark: _isDark,
        isFrench: _isFrench,
        isLoading: isLoading,
        savePageTwo: _savePageTwo,
        setPage: _setPage,
        adaptSize: adaptSize,
        passWord: _userPassword,
      ),
      AccountCreationFormThree(
        isDark: _isDark,
        isFrench: _isFrench,
        isLoading: isLoading,
        savePageThree: _savePageThree,
        setPage: _setPage,
        profilePhoto: _profilePictureFile,
      ),
      AccountCreationFormFour(
        isDark: _isDark,
        isFrench: _isFrench,
        isLoading: isLoading,
        savePageFour: _savePageFour,
        setPage: _setPage,
        submitCreationForm: _submitCreationForm,
        setThemeLight: _setThemeLight,
      )
    ];

    return Scaffold(
      backgroundColor: primaryColor(_isDark),
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: height * 1.01,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Text(
                        _isFrench
                            ? 'Création de votre\ncompte Notee'
                            : 'Creation of your\nNotee account',
                        style: TextStyle(
                          color: (_isDark) ? Palette.orange : Palette.black,
                          fontSize: fontSizeTitle,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Text(
                    //   'compte Notee',
                    //   style: TextStyle(
                    //     color: (_isDark) ? Palette.orange : Palette.black,
                    //     fontSize: 28,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 30),
                pages[pageIndex],
                //SizedBox(height: 20),
                // Flexible(
                //   flex: 3,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       IconButton(
                //         iconSize: 50,
                //         icon: Icon(
                //           Icons.help,
                //           color: (_isDark) ? Palette.orange : Palette.black,
                //           // size: 50,
                //         ),
                //         onPressed: () {},
                //         autofocus: true,
                //       ),
                //       const SizedBox(
                //         width: 30,
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
