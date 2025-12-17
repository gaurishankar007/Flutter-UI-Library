import 'package:flutter/material.dart';
import 'package:ui_library/utils/extensions/num_extension.dart';
import 'package:ui_library/widgets/visual_layouts/cupertino_loading.dart';
import 'package:ui_library/widgets/visual_layouts/error_icon.dart';

class BaseAssetImage extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final bool circular;
  final double? cacheHeight;
  final double? cacheWidth;
  final bool useLoadingIndicator;

  const BaseAssetImage({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.circular = false,
    this.cacheHeight,
    this.cacheWidth,
    this.useLoadingIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Image.asset(
      assetName,
      width: width,
      height: height,
      cacheHeight: cacheHeight?.scaledByDPR.toInt(),
      cacheWidth: cacheWidth?.scaledByDPR.toInt(),
      fit: fit,
      frameBuilder: (context, child, frame, bool wasSynchronouslyLoaded) {
        if (frame != null) {
          return child;
        } else if (useLoadingIndicator) {
          return CupertinoLoading(dimension: height);
        }
        return SizedBox.fromSize();
      },
      errorBuilder: (c, e, s) => ErrorIcon(height: height, width: width),
    );

    if (circular) {
      child = ClipOval(child: child);
    } else if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }

  factory BaseAssetImage.icon({required String assetName, double size = 24}) =>
      BaseAssetImage(
        assetName: assetName,
        height: size,
        width: size,
        cacheWidth: size,
        fit: BoxFit.contain,
      );

  factory BaseAssetImage.person({
    required double size,
    BoxFit fit = BoxFit.cover,
    bool circular = true,
  }) => BaseAssetImage(
    assetName: "",
    height: size,
    width: size,
    cacheWidth: size,
    fit: fit,
    circular: circular,
  );
}
