import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class CurveContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color curvedColor;
  final Color unCurvedColor;

  final CurveSide curveSide;

  /// How much the curve should be drawn base the height of the give side.
  ///
  /// 80% [curvePercentage] will draw a curvature of height 80 if the
  /// total height is 100.
  final double curvePercentage;

  const CurveContainer({
    super.key,
    this.height,
    this.width,
    this.curvedColor = AppColors.white,
    this.unCurvedColor = AppColors.primary,
    required this.curveSide,
    required this.curvePercentage,
  });

  const CurveContainer.defaultOne({
    super.key,
    this.height = 100,
    this.width = double.maxFinite,
    this.curvedColor = AppColors.white,
    this.unCurvedColor = AppColors.primary,
    this.curveSide = CurveSide.top,
    this.curvePercentage = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: DecoratedBox(decoration: BoxDecoration(color: unCurvedColor)),
        ),
        ClipPath(
          clipper: CurveClipper(
            curveSide: curveSide,
            curvePercentage: curvePercentage,
          ),
          child: SizedBox(
            height: height,
            width: width,
            child: DecoratedBox(decoration: BoxDecoration(color: curvedColor)),
          ),
        ),
      ],
    );
  }
}

/// Defining clipper for clip path
class CurveClipper extends CustomClipper<Path> {
  final CurveSide curveSide;
  final double curvePercentage;

  const CurveClipper({required this.curveSide, required this.curvePercentage});

  @override
  Path getClip(Size size) {
    final path = Path();
    late Offset endOffset;
    late Radius radius;
    late bool clockwise;

    switch (curveSide) {
      case CurveSide.left:
        path.moveTo(size.width, 0);
        endOffset = Offset(size.width, size.height);
        radius = Radius.elliptical(
          size.width * (min(curvePercentage, 100) / 100),
          size.height / 2,
        );
        clockwise = false;
        break;

      case CurveSide.right:
        endOffset = Offset(0, size.height);
        radius = Radius.elliptical(
          size.width * (min(curvePercentage, 100) / 100),
          size.height / 2,
        );
        clockwise = true;
        break;

      case CurveSide.top:
        endOffset = Offset(size.width, 0);
        radius = Radius.elliptical(
          size.width / 2,
          size.height * (min(curvePercentage, 100) / 100),
        );
        clockwise = false;
        break;

      case CurveSide.bottom:
        path.moveTo(0, size.height);
        endOffset = Offset(size.width, size.height);
        radius = Radius.elliptical(
          size.width / 2,
          size.height * (min(curvePercentage, 100) / 100),
        );
        clockwise = true;
        break;
    }

    path.arcToPoint(endOffset, radius: radius, clockwise: clockwise);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

/// It determines which half of the widget will be visible
enum CurveSide { left, top, right, bottom }
