import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../cupertino_loading.dart';
import '../error_indicator.dart';

class BaseCachedNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final int? cacheHeight;
  final int? cacheWidth;
  final BoxShape boxShape;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const BaseCachedNetworkImage({
    super.key,
    this.url,
    this.fit = BoxFit.contain,
    this.boxShape = BoxShape.circle,
    this.height,
    this.width,
    this.cacheHeight,
    this.cacheWidth,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (url != null && url?.isNotEmpty == true) {
      return const ErrorIndicator();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        width: width,
        height: height,
        memCacheHeight: cacheHeight,
        memCacheWidth: cacheWidth,
        fit: fit,
        imageUrl: url!,
        placeholder: (context, url) => CupertinoLoading(),
        errorWidget: (_, _, _) => const ErrorIndicator(),
      ),
    );
  }
}
