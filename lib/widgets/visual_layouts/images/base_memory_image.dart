import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../cupertino_loading.dart';
import '../error_indicator.dart';

class BaseMemoryImage extends StatelessWidget {
  /// image bytes data
  final Uint8List uint8List;
  final double? height;
  final double? width;
  final int? cacheHeight;
  final int? cacheWidth;
  final bool isCircular;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const BaseMemoryImage({
    super.key,
    required this.uint8List,
    this.height,
    this.width,
    this.cacheHeight,
    this.cacheWidth,
    this.isCircular = false,
    this.fit,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (uint8List.isEmpty) return SizedBox.shrink();

    Widget child = Image.memory(
      uint8List,
      height: height,
      width: width,
      cacheHeight: cacheHeight,
      cacheWidth: cacheWidth,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null) return child;
        return CupertinoLoading(dimension: height);
      },
      errorBuilder: (_, __, ___) => const ErrorIndicator(),
    );

    if (isCircular) {
      return ClipOval(child: child);
    } else if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }
}
