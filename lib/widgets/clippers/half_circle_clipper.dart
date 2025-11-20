import 'package:flutter/material.dart';

/// Defining clipper for clip path
class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;
  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

/// It determines which half of the widget will be visible
enum CircleSide {
  left,
  right,
}

/// Extension for getting the path of UI which will be shown based on the circle side
extension on CircleSide {
  Path toPath(Size size) {
    final path = Path();
    late Offset endOffset;
    late bool clockwise;

    /// The extension adds a method toPath(Size size), which returns a Path defining the visible area.
    /// Path is used to define which parts of the widget are shown.
    /// endOffset: Stores the end position of the curve.
    /// clockwise: Determines the direction of the curve.

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        endOffset = Offset(size.width, size.height);
        clockwise = false;
        break;

      /// path.moveTo(size.width, 0); → Moves the starting point to the top-right corner.
      /// endOffset = Offset(size.width, size.height); → Sets the end point to the bottom-right corner.
      /// clockwise = false; → Ensures that the curve is drawn counterclockwise, forming a left half-circle.

      case CircleSide.right:
        endOffset = Offset(0, size.height);
        clockwise = true;
        break;

      /// The start point is implicitly at (0,0).
      /// endOffset = Offset(0, size.height); → The curve ends at the bottom-left corner.
      /// clockwise = true; → The curve is drawn clockwise, forming a right half-circle
    }

    path.arcToPoint(
      endOffset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );

    /// arcToPoint(endOffset, radius, clockwise) → Draws an arc from the start point to endOffset.
    /// Radius.elliptical(size.width / 2, size.height / 2) → Creates a half-circle.
    /// clockwise determines the arc direction.

    path.close();

    return path;
  }
}