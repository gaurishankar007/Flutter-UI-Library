import 'dart:math';

import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final int sides;
  const PolygonPainter({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.deepPurple
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 3;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final baseAngle = (2 * pi) / sides;
    final angles = List.generate(sides, (index) => baseAngle * index);

    /*
    Axis x = radius * cos(angle)
    Axis y = radius * sin(angle)
    |-----------> x axis
    |
    |
    |
    |
    y axis
    */

    final radius = size.width / 2;
    // Moving the brush to the start point
    path.moveTo(center.dx + xPoint(radius, 0), center.dy + yPoint(radius, 0));

    for (final angle in angles) {
      if (angle == 0) continue;
      path.lineTo(
        center.dx + xPoint(radius, angle),
        center.dy + yPoint(radius, angle),
      );
    }

    // Moving path from end to start point
    path.close();

    canvas.drawPath(path, paint);
  }

  // Getting x and y axis point after adding angles
  double xPoint(double radius, double angle) => radius * cos(angle);
  double yPoint(double radius, double angle) => radius * sin(angle);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is PolygonPainter && oldDelegate.sides != sides;
}
