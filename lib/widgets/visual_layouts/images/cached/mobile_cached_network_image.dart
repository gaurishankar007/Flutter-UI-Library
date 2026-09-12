import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/extensions/num_extension.dart';
import 'package:ui_library/widgets/visual_layouts/images/base_asset_image.dart';
import 'package:ui_library/widgets/visual_layouts/images/default_asset_image.dart';
import 'package:ui_library/widgets/visual_layouts/loading/cupertino_loading.dart';

class BaseCachedNetworkImage extends StatelessWidget {
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
    this.fallbackWidget,
    this.fallbackImageFit,
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
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    Widget child = CachedNetworkImage(
      imageUrl: url,
      cacheKey: cacheKey,
      width: width,
      height: height,
      memCacheHeight: cacheHeight?.scaledByDPR.toInt(),
      memCacheWidth: cacheWidth?.scaledByDPR.toInt(),
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) => CupertinoLoading(dimension: height),
      errorWidget: (context, error, stackTrace) {
        return fallbackWidget ??
            DefaultAssetImage(
              width: width,
              height: height,
              cacheHeight: cacheHeight,
              cacheWidth: cacheWidth,
              fit: fallbackImageFit,
              alignment: alignment,
            );
      },
    );

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
