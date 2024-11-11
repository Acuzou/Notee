class Coordonnee {
  String emailAddress;
  String geographicAddress;
  int phoneNumber;
  String website;

  Coordonnee({
    this.emailAddress,
    this.geographicAddress,
    this.phoneNumber,
    this.website,
  });

  String getEmailAdress() {
    return emailAddress;
  }

  String getGeographicAdress() {
    return geographicAddress;
  }

  String getWebsite() {
    return website;
  }

  String getPhoneNumberText() {
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
}
