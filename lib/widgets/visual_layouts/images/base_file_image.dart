import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:ui_library/utils/extensions/num_extension.dart';
import 'package:ui_library/widgets/visual_layouts/images/default_asset_image.dart';
import 'package:ui_library/widgets/visual_layouts/loading/cupertino_loading.dart';

class BaseFileImage extends StatelessWidget {
  const BaseFileImage({
    super.key,
    required this.file,
    this.height,
    this.width,
    this.cacheHeight,
    this.cacheWidth,
    this.isCircular = false,
    this.fit,
    this.borderRadius,
    this.fallbackImageFit,
    this.fallbackWidget,
    this.alignment = Alignment.center,
  });
  final File file;
  final double? height;
  final double? width;
  final double? cacheHeight;
  final double? cacheWidth;
  final BoxFit? fit;
  final bool isCircular;
  final BorderRadius? borderRadius;
  final BoxFit? fallbackImageFit;
  final Widget? fallbackWidget;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final Widget child = Image.file(
      file,
      height: height,
      width: width,
      cacheHeight: cacheHeight?.scaledByDPR.toInt(),
      cacheWidth: cacheWidth?.scaledByDPR.toInt(),
      fit: fit,
      alignment: alignment,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null) {
          return child;
        }
        return CupertinoLoading(dimension: height);
      },
      errorBuilder: (_, _, _) =>
          fallbackWidget ??
          DefaultAssetImage(
            width: width,
            height: height,
            cacheHeight: cacheHeight,
            cacheWidth: cacheWidth,
            fit: fallbackImageFit,
            alignment: alignment,
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
