import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/extensions/num_extension.dart';
import 'package:ui_library/widgets/visual_layouts/images/base_asset_image.dart';
import 'package:ui_library/widgets/visual_layouts/images/default_asset_image.dart';
import 'package:ui_library/widgets/visual_layouts/loading/cupertino_loading.dart';

class BaseNetworkImage extends StatelessWidget {
  const BaseNetworkImage({
    super.key,
    required this.url,
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
    Widget child = Image.network(
      url,
      width: width,
      height: height,
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
      errorBuilder: (context, error, stackTrace) {
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
      // Renders via an HTML <img> element when the platform decoder can't
      // load the bytes directly (e.g. CORS-less hosts on Flutter web).
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
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
    final Widget child = BaseNetworkImage(
      key: key,
      url: url,
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
