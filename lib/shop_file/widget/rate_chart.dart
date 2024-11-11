import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateChart extends StatefulWidget {
  final QueryDocumentSnapshot shopDoc;
  final int myId;
  final bool isDark;
  final Color color;
  final bool isUpdate;
  final double sizeRate;

  const RateChart({
    Key key,
    this.shopDoc,
    this.myId,
    this.sizeRate,
    this.isDark,
    this.color,
    this.isUpdate,
  }) : super(key: key);

  @override
  RateChartState createState() => RateChartState();
}

class RateChartState extends State<RateChart> {
  double myRate;

  @override
  void initState() {
    myRate = widget.shopDoc['rate'].toDouble();
    super.initState();
  }

  void setNewRate(double rate) async {
    await FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.shopDoc.id)
        .collection('notes')
        .doc(widget.myId.toString())
        .update({
      'rate': rate,
      'userId': widget.myId,
    });

    var ratesSnapshot = await FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.shopDoc.id)
        .collection('notes')
        .get();

    double newRate = 0;

    for (int i = 0; i < ratesSnapshot.docs.length; i++) {
      newRate += ratesSnapshot.docs[i]['rate'].toDouble();
    }

    newRate = newRate / ratesSnapshot.docs.length;

    await FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.shopDoc.id)
        .update({'rate': newRate});

    setState(() {
      myRate = newRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
      ),
      height: widget.sizeRate,
      child:
          // Positioned(
          //   right: 0,
          //   child: Icon(
          //     Icons.star,
          //     color: Colors.yellow,
          //     size: widget.sizeRate,
          //     semanticLabel: 'Rate',
          //   ),
          // ),
          Row(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          Text(
            (myRate).toStringAsFixed(2),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: secondaryColor(!widget.isDark, widget.color),
            ),
          ),
          RatingBar.builder(
              initialRating: myRate,
              minRating: 0,
              itemSize: 30,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              updateOnDrag: false,
              ignoreGestures: true,
              unratedColor: (widget.isDark)
                  ? tintColor(Palette.black, 0.1)
                  : tintColor(Palette.black, 0.4),
              onRatingUpdate: (rating) {
                //   if (rating != null) setNewRate(rating);
              }),
          // Container(
          //   width: sizeRate,
          //   alignment: Alignment.topCenter,
          //   child: FractionallySizedBox(
          //     heightFactor: 1.1 - (rate / 10),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(5),
          //         color: Colors.black54,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
