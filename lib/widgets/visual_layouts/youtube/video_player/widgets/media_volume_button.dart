import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_slider.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/util/youtube_media_controller.dart';

class MediaVolumeButton extends HookWidget {
  final YoutubeMediaController controller;

  const MediaVolumeButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.volumeNotifier,
      builder: (context, volume, child) {
        IconData icon = Icons.volume_up_sharp;
        if (volume < 100) icon = Icons.volume_down_sharp;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: controller.onMuteUnmute,
              child: ValueListenableBuilder(
                valueListenable: controller.muteNotifier,
                builder: (context, isMuted, child) {
                  return Icon(
                    isMuted ? Icons.volume_off_sharp : icon,
                    color: AppColors.white,
                    size: kIsWeb ? 40 : 32,
                  );
                },
              ),
            ),
            UIHelpers.spaceH4,
            SizedBox(
              width: 60,
              child: BaseSlider(
                value: volume.clamp(0, 100).toDouble(),
                max: 100,
                activeColor: AppColors.white,
                inactiveColor: kIsWeb
                    ? AppColors.white.withAlpha(97)
                    : AppColors.black.withAlpha(97),
                thumbColor: AppColors.white,
                onChanged: controller.onVolumeChanged,
              ),
            ),
            UIHelpers.spaceH4,
          ],
        );
      },
    );
  }
}
