import 'package:cuzou_app/main.dart';
import 'package:flutter/material.dart';

class ChatBubbleTriangle extends CustomPainter {
  final bool isMe;
  final bool isDark;
  final bool showDeleteButton;

  ChatBubbleTriangle(this.isMe, this.isDark, this.showDeleteButton);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = isMe
          ? shadeColor((showDeleteButton) ? Palette.blue : Palette.pink, 0.1)
          : isDark
              ? shadeColor(Palette.grey, 0.9)
              : shadeColor(Palette.grey, 0.1);

    var path = Path();
    path.lineTo(10, 0);
    path.lineTo(0, -10);
    path.lineTo(-10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
