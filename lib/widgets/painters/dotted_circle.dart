import 'dart:math';

import 'package:material_ui/material_ui.dart';

class DottedCircle extends StatelessWidget {

  const DottedCircle({
    super.key,
    required this.radius,
    required this.color,
    required this.dotsNumber,
  });
  final double radius;
  final Color color;
  final int dotsNumber;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius * 2,
      width: radius * 2,
      child: CustomPaint(
        painter: DottedCirclePainter(
          strokeColor: color,
          strokeWidth: 2,
          dotsNumber: dotsNumber,
        ),
      ),
    );
  }
}

class DottedCirclePainter extends CustomPainter {

  DottedCirclePainter({
    required this.strokeColor,
    required this.strokeWidth,
    required this.dotsNumber,
  });
  Color strokeColor;
  double strokeWidth;
  int dotsNumber;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width / 2, size.height / 2);

    /// If dotsNumber is 4,
    /// base angle = 360 / dotsNumber, sweep angle = 360 / (dotsNumber * 2)
    /// so that the length of dot and gap will be same
    final double baseAngle = pi / (dotsNumber / 2);
    final double sweepAngle = pi / dotsNumber;

    for (var i = 0; i < dotsNumber; i++) {
      final startAngle = baseAngle * i;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
