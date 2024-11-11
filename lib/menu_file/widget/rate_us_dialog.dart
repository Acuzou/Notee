import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateUsDialog extends StatefulWidget {
  const RateUsDialog({Key key}) : super(key: key);

  @override
  RateUsDialogState createState() => RateUsDialogState();
}

class RateUsDialogState extends State<RateUsDialog> {
  double appRating = 0;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'Note nous !',
        style: TextStyle(fontSize: 32),
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Note application !'),
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                    "Pour nous soutenir, n'hésite pas à nous laisser une note !",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                RatingBar.builder(
                    minRating: 0,
                    itemSize: 46,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    updateOnDrag: true,
                    onRatingUpdate: (rating) {
                      setState(() {
                        appRating = rating;
                      });
                    }),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
