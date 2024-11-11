import 'package:cuzou_app/research_file/Model/shop.dart';

class UserData {
  final int userId;
  final int shopId;
  final int phoneNumber;
  final String email;
  final City city;
  final String lastName;
  final String firstName;
  final bool isDark;
  final bool isFrench;
  final bool isMerchant;

  UserData({
    this.shopId,
    this.userId,
    this.phoneNumber,
    this.email,
    this.city,
    this.lastName,
    this.firstName,
    this.isDark,
    this.isFrench,
    this.isMerchant,
  });
}
