import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/widgets/visual_layouts/images/cached/base_cached_network_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeThumbnail extends StatelessWidget {
  final Function()? onTap;
  final String videoUrl;

  const YoutubeThumbnail({super.key, this.onTap, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return Stack(
            alignment: Alignment.center,
            children: [
              BaseCachedNetworkImage(
                url: _getThumbnailUrl(),
                height: constraints.maxHeight,
                width: maxWidth,
                cacheWidth: maxWidth,
                fit: BoxFit.cover,
              ),
              Icon(
                Icons.play_arrow_rounded,
                color: AppColors.white,
                size: maxWidth * .45,
              ),
            ],
          );
        },
      ),
    );
  }

  String _getThumbnailUrl() {
    try {
      final videoId = YoutubePlayerController.convertUrlToId(videoUrl) ?? "";
      return YoutubePlayerController.getThumbnail(videoId: videoId);
    } catch (_) {
      return "";
    }
  }
}
