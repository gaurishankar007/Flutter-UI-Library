import 'dart:ui';

import 'package:material_ui/material_ui.dart';

class DottedContainer extends StatelessWidget {
  const DottedContainer({
    super.key,
    this.dashWidth = 4,
    this.gapWidth = 2,
    this.strokeWidth = 1,
    this.strokeColor = Colors.black,
    this.borderRadius,
    this.child,
  });

  /// Width(Length) of the dash
  final double dashWidth;

  /// Space width between dash
  final double gapWidth;

  /// Width of dash
  final double strokeWidth;

  /// Dash color
  final Color strokeColor;

  /// Border radius of the container
  final BorderRadius? borderRadius;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedContainerPainter(
        dashWidth: dashWidth,
        gapWidth: gapWidth,
        strokeWidth: strokeWidth,
        strokeColor: strokeColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class DottedContainerPainter extends CustomPainter {
  DottedContainerPainter({
    super.repaint,
    required this.dashWidth,
    required this.gapWidth,
    required this.strokeWidth,
    required this.strokeColor,
    this.borderRadius,
  });
  final double dashWidth;
  final double gapWidth;
  final double strokeWidth;
  final Color strokeColor;
  final BorderRadius? borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          /// L(x-coordinate), T(y-coordinate), W(width), H(height)
          Rect.fromLTWH(0, 0, size.width, size.height),
          topLeft: borderRadius?.topLeft ?? Radius.zero,
          topRight: borderRadius?.topRight ?? Radius.zero,
          bottomLeft: borderRadius?.bottomLeft ?? Radius.zero,
          bottomRight: borderRadius?.bottomRight ?? Radius.zero,
        ),
      );

    /// A variable to keep track of how far along the path we've already drawn.
    double distance = 0;

    /// path.computeMetrics(): This breaks the path into measurable segments (e.g., a rectangle has 4 segments: top, right, bottom, and left).
    /// PathMetric: Represents one of those measurable segments, allowing you to extract specific parts of the path.
    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final start = distance;
        final end = start + dashWidth;
        canvas.drawPath(pathMetric.extractPath(start, end), paint);
        distance += dashWidth + gapWidth;
      }
      distance = 0.0; // Reset distance for the next PathMetric
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
