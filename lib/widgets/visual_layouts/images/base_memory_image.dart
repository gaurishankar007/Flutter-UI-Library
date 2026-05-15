import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ui_library/utils/extensions/num_extension.dart';
import 'package:ui_library/widgets/visual_layouts/loading/cupertino_loading.dart';
import 'package:ui_library/widgets/visual_layouts/images/default_asset_image.dart';

class BaseMemoryImage extends StatelessWidget {
  /// image bytes data
  final Uint8List uint8List;
  final double? height;
  final double? width;
  final double? cacheHeight;
  final double? cacheWidth;
  final bool isCircular;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final BoxFit? fallbackImageFit;

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
    this.fallbackImageFit,
  });

  @override
  Widget build(BuildContext context) {
    if (uint8List.isEmpty) return SizedBox.shrink();

    Widget child = Image.memory(
      uint8List,
      height: height,
      width: width,
      cacheHeight: cacheHeight?.scaledByDPR.toInt(),
      cacheWidth: cacheWidth?.scaledByDPR.toInt(),
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null) return child;
        return CupertinoLoading(dimension: height);
      },
      errorBuilder: (_, _, _) => DefaultAssetImage(
        width: width,
        height: height,
        cacheHeight: cacheHeight,
        cacheWidth: cacheWidth,
        fit: fallbackImageFit,
      ),
    );

    if (isCircular) {
      return ClipOval(child: child);
    } else if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }
}
