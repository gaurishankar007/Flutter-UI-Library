import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:ui_library/utils/extensions/num_extension.dart';
import 'package:ui_library/widgets/visual_layouts/images/default_asset_image.dart';
import 'package:ui_library/widgets/visual_layouts/loading/cupertino_loading.dart';

class BaseMemoryImage extends StatelessWidget {
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
    this.fallbackWidget,
    this.alignment = Alignment.center,
  });

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
  final Widget? fallbackWidget;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    if (uint8List.isEmpty) {
      return const SizedBox.shrink();
    }

    final Widget child = Image.memory(
      uint8List,
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
