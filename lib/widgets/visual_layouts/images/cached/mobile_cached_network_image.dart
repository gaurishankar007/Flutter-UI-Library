import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/extensions/num_extension.dart';
import 'package:ui_library/widgets/visual_layouts/cupertino_loading.dart';
import 'package:ui_library/widgets/visual_layouts/error_icon.dart';
import 'package:ui_library/widgets/visual_layouts/images/base_asset_image.dart';

class BaseCachedNetworkImage extends StatelessWidget {
  const BaseCachedNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.circular = false,
    this.cacheHeight,
    this.cacheWidth,
    this.fallbackWidget,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final bool circular;
  final double? cacheHeight;
  final double? cacheWidth;
  final Widget? fallbackWidget;

  @override
  Widget build(BuildContext context) {
    Widget child = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      memCacheHeight: cacheHeight?.scaledByDPR.toInt(),
      memCacheWidth: cacheWidth?.scaledByDPR.toInt(),
      fit: fit,
      placeholder: (context, url) => CupertinoLoading(dimension: height),
      errorWidget: (context, error, stackTrace) {
        return fallbackWidget ?? ErrorIcon(height: height, width: width);
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
    required double diameter,
    Widget? fallbackWidget,
    bool isBordered = false,
  }) {
    Widget child = BaseCachedNetworkImage(
      key: key,
      url: url,
      width: diameter,
      height: diameter,
      cacheWidth: diameter,
      circular: true,
      fit: BoxFit.cover,
      fallbackWidget: fallbackWidget ?? BaseAssetImage.person(size: diameter),
    );

    if (!isBordered) return child;
    return CircleAvatar(
      radius: (diameter / 2) + 1.5,
      backgroundColor: AppColors.fade,
      child: child,
    );
  }
}
