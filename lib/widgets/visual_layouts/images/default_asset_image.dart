import 'package:flutter/material.dart';
import 'package:ui_library/utils/extensions/num_extension.dart';
import 'package:ui_library/widgets/visual_layouts/loading/cupertino_loading.dart';

class DefaultAssetImage extends StatelessWidget {
  const DefaultAssetImage({
    super.key,
    this.width,
    this.height,
    this.cacheHeight,
    this.cacheWidth,
    this.fit,
  });

  final double? width;
  final double? height;
  final double? cacheHeight;
  final double? cacheWidth;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/image.png',
      width: width,
      height: height,
      cacheHeight: cacheHeight?.scaledByDPR.toInt(),
      cacheWidth: cacheWidth?.scaledByDPR.toInt(),
      fit: fit,
      frameBuilder: (_, child, frame, _) =>
          frame != null ? child : CupertinoLoading(dimension: height ?? width),
    );
  }
}
