import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/cache_manager_util.dart';
import 'package:ui_library/utils/extensions/num_extension.dart';
import 'package:ui_library/widgets/visual_layouts/images/base_asset_image.dart';
import 'package:ui_library/widgets/visual_layouts/images/default_asset_image.dart';
import 'package:ui_library/widgets/visual_layouts/loading/cupertino_loading.dart';

class BaseCachedNetworkImage extends HookWidget {
  const BaseCachedNetworkImage({
    super.key,
    required this.url,
    this.cacheKey,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.circular = false,
    this.cacheHeight,
    this.cacheWidth,
    this.fallbackImageFit,
    this.fallbackWidget,
    this.alignment = Alignment.center,
  });

  final String url;
  final String? cacheKey;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final bool circular;
  final double? cacheHeight;
  final double? cacheWidth;
  final BoxFit? fallbackImageFit;
  final Widget? fallbackWidget;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final imageFuture = useMemoized(
      () async => await CacheManagerUtil.getFileBytes(url, cacheKey: cacheKey),
      [url, cacheKey],
    );
    final snapshot = useFuture(imageFuture);

    Widget child;
    final Widget loadingIcon = CupertinoLoading(dimension: height);
    final Widget errorWidget =
        fallbackWidget ??
        DefaultAssetImage(
          width: width,
          height: height,
          cacheHeight: cacheHeight,
          cacheWidth: cacheWidth,
          fit: fallbackImageFit,
          alignment: alignment,
        );

    if (snapshot.connectionState == ConnectionState.waiting) {
      child = loadingIcon;
    } else if (snapshot.hasError || snapshot.data == null) {
      child = errorWidget;
    } else {
      child = Image.memory(
        snapshot.data!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        cacheHeight: cacheHeight?.scaledByDPR.toInt(),
        cacheWidth: cacheWidth?.scaledByDPR.toInt(),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame != null) {
            return child;
          }
          return loadingIcon;
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget;
        },
      );
    }

    if (circular) {
      child = ClipOval(child: child);
    } else if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }

  static Widget avatar({
    Key? key,
    required String url,
    String? cacheKey,
    required double diameter,
    Widget? fallbackWidget,
    bool isBordered = false,
  }) {
    final Widget child = BaseCachedNetworkImage(
      key: key,
      url: url,
      cacheKey: cacheKey,
      width: diameter,
      height: diameter,
      cacheWidth: diameter,
      circular: true,
      fit: BoxFit.cover,
      fallbackWidget: fallbackWidget ?? BaseAssetImage.person(size: diameter),
    );

    if (!isBordered) {
      return child;
    }
    return CircleAvatar(
      radius: (diameter / 2) + 1.5,
      backgroundColor: AppColors.fade,
      child: child,
    );
  }
}
