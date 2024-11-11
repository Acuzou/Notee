import 'package:cuzou_app/research_file/Model/shop.dart';

class User {
  final int id;
  final String userName;
  //idShop = 0 si ce n'est pas un commerçant
  final int shopId;
  final City cityUser;
  final int phoneNumber;
  final String emailAdresse;
  final String profilPictureUrl;
  final bool isBan;
  final List<int> contacts;

  User({
    this.id,
    this.userName,
    this.shopId,
    this.cityUser,
    this.phoneNumber,
    this.emailAdresse,
    this.profilPictureUrl,
    this.isBan,
    this.contacts,
  });
}
