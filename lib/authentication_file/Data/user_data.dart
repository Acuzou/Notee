import 'package:cuzou_app/research_file/Model/shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<int, List<Object>> dataCity = {
  //_cityId : [_cityName, _postalCode]
  0: [
    'Paris',
    75000,
    City.Paris,
  ],
  1: [
    'Lyon',
    69001,
    City.Lyon,
  ],
  2: [
    'Marseille',
    13000,
    City.Marseille,
  ],
  3: [
    'Nantes',
    44000,
    City.Nantes,
  ],
  4: [
    'Rennes',
    35000,
    City.Rennes,
  ],
  5: [
    'Cannes',
    06400,
    City.Rennes,
  ]
};

String getCityNameFromData(int cityId) {
  return dataCity[cityId][0];
}

List<Shop> favoriteShopData = [];

String getPhoneNumberText(int phoneNumber) {
  String strPhoneNumber = phoneNumber.toString();

  List<String> listPhoneNumber = ['0'];

  for (int i = 0; i < strPhoneNumber.length; i++) {
    listPhoneNumber.add(strPhoneNumber[i]);
  }

  strPhoneNumber = '';
  for (int i = 0; i < listPhoneNumber.length; i++) {
    if ((i % 2 == 0) && (i != 0)) {
      strPhoneNumber += ' ';
    }
    strPhoneNumber += listPhoneNumber[i];
  }

  return strPhoneNumber;
  //return '0${(phoneNumber - (phoneNumber % 100000000))/100000000} ${(phoneNumber - (phoneNumber % 1000000))/1000000} ${phoneNumber} ${phoneNumber} ${phoneNumber}';
}

int generatePrimaryKeyFromUser(List<QueryDocumentSnapshot> dataDocs) {
  int id = 0;

  List<int> userIdList = [];

  for (int i = 0; i < dataDocs.length; i++) {
    userIdList.add(dataDocs[i].get('ID'));
  }

  for (int i = 0; i < dataDocs.length; i++) {
    if (userIdList.contains(id)) {
      id += 1;
    } else {
      return id;
    }
  }
  return id;
}

int generatePrimaryKeyFromShop(List<QueryDocumentSnapshot> dataDocs) {
  int id = 0;

  List<int> shopIdList = [];

  for (int i = 0; i < dataDocs.length; i++) {
    shopIdList.add(dataDocs[i].get('shopId'));
  }

  for (int i = 0; i < dataDocs.length; i++) {
    if (shopIdList.contains(id)) {
      id += 1;
    } else {
      return id;
    }
  }
  return id;
}

int generatePrimaryKeyFromNewsShop(List<QueryDocumentSnapshot> dataDocs) {
  int id = 0;

  List<int> newsIdList = [];

  for (int i = 0; i < dataDocs.length; i++) {
    newsIdList.add(dataDocs[i]['newsId']);
  }

  for (int i = 0; i < dataDocs.length; i++) {
    if (newsIdList.contains(id)) {
      id += 1;
    } else {
      return id;
    }
  }
  return id;
}

int generatePrimaryKeyFromPhotoShop(List<QueryDocumentSnapshot> dataDocs) {
  int id = 0;

  List<int> photoIdList = [];

  for (int i = 0; i < dataDocs.length; i++) {
    photoIdList.add(dataDocs[i]['imageId']);
  }

  for (int i = 0; i < dataDocs.length; i++) {
    if (photoIdList.contains(id)) {
      id += 1;
    } else {
      return id;
    }
  }
  return id;
}
