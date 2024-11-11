import 'package:flutter/material.dart';
//import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_screen2.dart';

class MyProfile extends StatefulWidget {
  static const routeName = '/my-profile';

  const MyProfile({Key key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final Color colorAppBar = routeArgs['colorAppBar'] as Color;
    final bool isDark = routeArgs['isDark'] as bool;
    final bool isFrench = routeArgs['isFrench'] as bool;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            const Text('Something went wrong.');
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var auth = FirebaseAuth.instance.currentUser;
          final usersDocs = userSnapshot.data.docs;
          var userData =
              usersDocs.firstWhere((user) => user['email'] == auth.email);

          //UserData userData = getUserData(userData)

          return ProfileScreen2(
            userData: userData,
            isDark: isDark,
            isFrench: isFrench,
            colorAppBar: colorAppBar,
          );
        });
  }
}
