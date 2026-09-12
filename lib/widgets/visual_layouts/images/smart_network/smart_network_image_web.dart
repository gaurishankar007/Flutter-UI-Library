import 'package:material_ui/material_ui.dart';
import 'package:ui_library/widgets/visual_layouts/images/default_asset_image.dart';
import 'package:ui_library/widgets/visual_layouts/loading/cupertino_loading.dart';

class SmartNetworkImage extends StatelessWidget {
  const SmartNetworkImage({
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
      fit: fit,
      alignment: alignment,
      frameBuilder: (_, child, frame, _) =>
          frame != null ? child : CupertinoLoading(dimension: height),
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
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
    );

    if (circular) {
      child = ClipOval(child: child);
    } else if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }
}
