import 'package:flutter/cupertino.dart';
import 'package:material_ui/material_ui.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({
    super.key,
    this.strokeWidth = 4,
    this.dimension = 30,
    this.color,
    this.centered = true,
    this.isCupertino = false,
    this.cupertinoIndicatorRadius = 10,
  });

  factory LoadingCircle.small([Color? color]) =>
      LoadingCircle(strokeWidth: 2, dimension: 20, color: color);
  final double strokeWidth;

  /// Height and width of the circularProgressIndicator.
  final double dimension;
  final Color? color;
  final bool centered;

  /// Use the CupertinoActivityIndicator
  final bool isCupertino;
  final double cupertinoIndicatorRadius;

  @override
  Widget build(BuildContext context) {
    late Widget child;

    if (isCupertino) {
      child = CupertinoActivityIndicator(
        color: color,
        radius: cupertinoIndicatorRadius,
      );
    } else {
      child = SizedBox.square(
        dimension: dimension,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: strokeWidth,
        ),
      );
    }

    if (centered) {
      return Center(child: child);
    }
    return child;
  }
}
