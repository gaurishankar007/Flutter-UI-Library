import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../utils/ui_helpers.dart';
import '../util/youtube_media_controller.dart';
import 'media_play_button.dart';
import 'media_playback_speed.dart';
import 'media_progress.dart';
import 'media_seeker.dart';
import 'media_volume_button.dart';

class YoutubeVideoController extends StatelessWidget {
  final YoutubeMediaController controller;
  const YoutubeVideoController({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: AppColors.black.withAlpha(77), blurRadius: 4),
        ],
      ),
      child: Padding(
        padding: kIsWeb ? UIHelpers.paddingA12 : UIHelpers.paddingH12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MediaSeeker(
              positionNotifier: controller.positionNotifier,
              bufferedNotifier: controller.bufferedNotifier,
              onChanged: controller.onPositionChanged,
            ),
            UIHelpers.spaceV4,
            Row(
              children: [
                MediaPlayButton(
                  playingNotifier: controller.playingNotifier,
                  onPressed: controller.onPlayPause,
                ),
                if (kIsWeb || !Platform.isIOS) ...[
                  UIHelpers.spaceH8,
                  MediaVolumeButton(controller: controller),
                ],
                UIHelpers.spaceH12,
                ValueListenableBuilder(
                  valueListenable: controller.positionNotifier,
                  builder: (context, position, child) {
                    return MediaProgress(
                      positionInSeconds: (position * controller.duration)
                          .toInt(),
                      durationInSeconds: controller.duration.toInt(),
                    );
                  },
                ),
                Spacer(),
                MediaPlaybackSpeed(
                  playbackRateNotifier: controller.playbackRateNotifier,
                  onRateChanged: controller.onPlaybackRateChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
