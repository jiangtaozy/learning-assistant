/*
 * Maintained by jemo from 2019.12.29 to now
 * Created by jemo on 2019.12.29 14:08:58
 * Line
 */

import 'package:flutter/material.dart';

class Line extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomPaint(
      painter: LinePainter(
        width: width,
        height: height,
      ),
    );
  }
}

class LinePainter extends CustomPainter {

  LinePainter({
    this.width,
    this.height,
  });

  final width;
  final height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.2;
    final start = Offset(0, height / 3);
    final end = Offset(width, height / 3);
    canvas.drawLine(start, end, paint);
    final start1 = Offset(0, height * 2 / 3);
    final end1 = Offset(width, height * 2 / 3);
    canvas.drawLine(start1, end1, paint);
    final start2 = Offset(width / 3, 0);
    final end2 = Offset(width / 3, height);
    canvas.drawLine(start2, end2, paint);
    final start3 = Offset(width * 2 / 3, 0);
    final end3 = Offset(width * 2 / 3, height);
    canvas.drawLine(start3, end3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegater) {
    return false;
  }

}
