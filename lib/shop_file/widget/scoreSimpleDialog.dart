// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';

class ScoreSimpleDialog extends StatelessWidget {
  final double rate;
  final bool isDark;
  final bool isFrench;
  const ScoreSimpleDialog(this.rate, this.isDark, this.isFrench, {Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text(
          isFrench ? 'Votre Note' : 'Your Grade',
          style: TextStyle(
            color: Palette.orange,
            fontFamily: 'RebondGrotesque',
            fontSize: 28,
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        backgroundColor: tintColor(Palette.black, 0.01),
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isFrench
                      ? 'Voici la note attribuée à votre magasin :'
                      : 'Here is the score given to your store :',
                  style: TextStyle(
                    color: Palette.orange,
                    fontFamily: 'RebondGrotesque',
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  //score.toString(),
                  '$rate / 5.0',
                  style: TextStyle(
                    color: Palette.orange,
                    fontFamily: 'RebondGrotesque',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ]),
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                isFrench ? 'Ce score dépend :' : 'This score depends :',
                style: TextStyle(
                  color: Palette.orange,
                  fontFamily: 'RebondGrotesque',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                isFrench
                    ? '1 - Du nombre d\'utilisateurs qui ont mis votre magasin en favori'
                    : '1 - On the number of users who put your shop in favorite',
                style: TextStyle(
                  color: Palette.orange,
                  fontFamily: 'RebondGrotesque',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                isFrench
                    ? '2 - De la fréquence de vos publications'
                    : '2 - On the frequency of your publications',
                style: TextStyle(
                  color: Palette.orange,
                  fontFamily: 'RebondGrotesque',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                isFrench
                    ? '3 - Du temps moyen de votre réponse après un message d\'utilisateur.'
                    : '3 - On your mean time of response after someone send you a message.',
                style: TextStyle(
                  color: Palette.orange,
                  fontFamily: 'RebondGrotesque',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(
                thickness: 2,
                color: Palette.white,
                height: 20,
              ),
              Text(
                isFrench
                    ? 'Plus votre score est haut, plus votre position dans la liste des magasins sera haute.'
                    : 'More your grade is high, more our position in the shop list will be high.',
                style: TextStyle(
                  color: Palette.orange,
                  fontFamily: 'RebondGrotesque',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          //End Button
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            //Close button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Retour',
                style: TextStyle(
                  color: Palette.orange,
                  fontSize: 16,
                ),
              ),
            ),
          ])
        ]);
  }
}
