import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/youtube_thumbnail/youtube_thumbnail_util.dart';
import 'package:ui_library/widgets/visual_layouts/images/cached/mobile_cached_network_image.dart';

class YoutubeThumbnail extends StatelessWidget {
  const YoutubeThumbnail({super.key, this.onTap, required this.videoUrl});
  final void Function()? onTap;
  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return Stack(
            alignment: Alignment.center,
            children: [
              BaseCachedNetworkImage(
                url: YouTubeUtil.getThumbnailUrl(videoUrl),
                height: constraints.maxHeight,
                width: maxWidth,
                cacheHeight: constraints.maxHeight,
                fit: BoxFit.cover,
              ),
              Icon(
                Icons.play_arrow_rounded,
                color: AppColors.white87,
                size: maxWidth * .45,
              ),
            ],
          );
        },
      ),
    );
  }
}
