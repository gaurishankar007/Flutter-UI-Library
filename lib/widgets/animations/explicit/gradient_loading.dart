import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../utils/ui_helpers.dart';
import '../../visual_layouts/base_text.dart';

class GradientLoading extends StatefulWidget {
  final Color? progressColor;
  final Color capColor;
  final double strokeWidth;
  final double size;
  final bool includeLabel;
  final bool centered;

  const GradientLoading({
    super.key,
    this.progressColor,
    this.capColor = AppColors.primary,
    this.strokeWidth = 6,
    this.size = 56,
    this.includeLabel = false,
    this.centered = false,
  });

  const GradientLoading.small({
    super.key,
    this.progressColor,
    this.capColor = AppColors.primary,
    this.strokeWidth = 4,
    this.size = 32,
    this.includeLabel = false,
    this.centered = false,
  });

  @override
  State<GradientLoading> createState() => _GradientLoadingState();
}

class _GradientLoadingState extends State<GradientLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = UnconstrainedBox(
      child: SizedBox.square(
        dimension: widget.size,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: CustomPaint(
                  painter: _GradientCircularProgressPainter(
                    progressColor: widget.progressColor ?? Color(0XFF5258E4),
                    endCapColor: widget.capColor,
                    strokeWidth: widget.strokeWidth,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    if (widget.includeLabel) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          UIHelpers.spaceV24,
          BaseText.heading2("Loading..."),
        ],
      );
    }
    if (widget.centered) child = Center(child: child);

    return child;
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final Color progressColor;
  final Color endCapColor;
  final double strokeWidth;

  _GradientCircularProgressPainter({
    required this.progressColor,
    required this.endCapColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: (size.width - strokeWidth) / 2,
    );

    // Gradient colors
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * math.pi,
      colors: [
        progressColor.withAlpha(0),
        progressColor.withAlpha(63),
        progressColor.withAlpha(127),
        progressColor,
      ],
    );

    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width - strokeWidth) / 2,
      paint,
    );

    // Draw end cap for the circle
    final endCapPaint =
        Paint()
          ..color = endCapColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final endCapStartAngle = 2 * math.pi * .98;
    final endCapSweepAngle = 2 * math.pi * .02;

    canvas.drawArc(
      rect,
      endCapStartAngle,
      endCapSweepAngle,
      false,
      endCapPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
