import 'package:flutter/material.dart';
import 'package:cuzou_app/main.dart';

// ignore: must_be_immutable
class TimeEntered extends StatefulWidget {
  int timeChose;
  int timeChosenBefore;
  Function(int timeChose) selectHour;

  TimeEntered(this.timeChose, this.timeChosenBefore, this.selectHour, {Key key})
      : super(key: key);

  @override
  State<TimeEntered> createState() => TimeEnteredState();
}

class TimeEnteredState extends State<TimeEntered> {
  bool isClicked;
  int defaultTime = 0;

  // @override
  // void initState() {
  //   print("Time Chose = ${widget.timeChose}");
  //   print("Time Chosen Before = ${widget.timeChosenBefore}");
  //   isClicked = (widget.timeChose == widget.timeChosenBefore);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    isClicked = (widget.timeChose == widget.timeChosenBefore);

    int timeChose = widget.timeChose;

    return (timeChose == null)
        ? const SizedBox(
            height: 44,
          )
        : Container(
            margin: const EdgeInsets.all(5),

            decoration: BoxDecoration(
              color: Palette.black,
            ),
            // child: ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       isClicked = !isClicked;
            //     });
            //     if (isClicked) {
            //       widget.selectHour(timeChose);
            //     } else {
            //       widget.selectHour(defaultTime);
            //     }
            //   },
            // style: ElevatedButton.styleFrom(
            //   primary: Colors.transparent,
            //   elevation: 0,
            // ),
            child: Text(
              (timeChose == null)
                  ? ''
                  : (timeChose ~/ 10 == 0)
                      ? '0$timeChose'
                      : '$timeChose',
              style: TextStyle(
                color: Palette.orange,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          );
  }
}
