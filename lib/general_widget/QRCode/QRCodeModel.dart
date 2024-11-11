import 'package:flutter/material.dart';

class QRCodeModel extends StatelessWidget {
  final int qrCodeReference;
  final int myId;
  final int shopId;
  final int reducValue;
  final DateTime createdAt;
  final String data;

  const QRCodeModel({
    Key key,
    this.qrCodeReference,
    this.myId,
    this.shopId,
    this.reducValue,
    this.createdAt,
    this.data,
  }) : super(key: key);

}