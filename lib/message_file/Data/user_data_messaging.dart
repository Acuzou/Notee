import 'package:flutter/material.dart';
import '../Model/user.dart';
import 'package:cuzou_app/research_file/Model/shop.dart';

Image defaultProfilePicture =
    Image.asset('assets/images/logos/logo_profile.png');

List<int> totalContact() {
  List<int> totalContacts = [];
  for (int i = 0; i < 14; i++) {
    totalContacts.add(i);
  }
  return (totalContacts);
}

final List<User> dataUsers = [
  User(
    id: 0,
    userName: 'Alexandre Cuzou',
    shopId: 0,
    cityUser: City.Nantes,
    phoneNumber: 687066151,
    emailAdresse: 'alexandrecuzou@gmail.com',
    profilPictureUrl: 'assets/images/logos/photoPP.jpg',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 1,
    userName: 'User1',
    shopId: 0,
    cityUser: City.Paris,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 2,
    userName: 'User2',
    shopId: 1,
    cityUser: City.Paris,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 3,
    userName: 'User3',
    shopId: 2,
    cityUser: City.Nantes,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 4,
    userName: 'User4',
    shopId: 3,
    cityUser: City.Nantes,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 5,
    userName: 'User5',
    shopId: 4,
    cityUser: City.Nantes,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 6,
    userName: 'User6',
    shopId: 5,
    cityUser: City.Nantes,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 10,
    userName: 'User10',
    shopId: 0,
    cityUser: City.Nantes,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 11,
    userName: 'User11',
    shopId: 0,
    cityUser: City.Nantes,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 12,
    userName: 'User12',
    shopId: 6,
    cityUser: City.Nantes,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 13,
    userName: 'User13',
    shopId: 7,
    cityUser: City.Nantes,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
  User(
    id: 14,
    userName: 'User14',
    shopId: 8,
    cityUser: City.Nantes,
    phoneNumber: 111111111,
    emailAdresse: 'defaultEmailAdresse@gmail.com',
    profilPictureUrl: 'assets/images/logos/logo_profile.png',
    isBan: false,
    contacts: totalContact(),
  ),
];
