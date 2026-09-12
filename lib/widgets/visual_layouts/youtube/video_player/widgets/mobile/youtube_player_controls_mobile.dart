// © 2026 vAIolin LLC. All rights reserved.
//
// This software and its associated materials are the intellectual
// property of vAIolin LLC. Unauthorized copying, modification,
// distribution, or use of this code, in whole or in part, without
// express written permission from vAIolin LLC is strictly prohibited.
//
// For licensing inquiries, contact: snehesh@vaiolin.ai

import 'dart:io' show Platform;

import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/screen_util/screen_util.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/controller/youtube_player_controller_mobile.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/media_play_button.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/media_playback_speed.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/media_progress.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/media_replay_button.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/media_seeker.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/media_volume_button.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/media_zoom_button.dart';

class YoutubePlayerControlsMobile extends StatelessWidget {
  const YoutubePlayerControlsMobile({
    super.key,
    required this.controller,
    this.onExpansion,
    this.isExpanded,
  });

  final YoutubePlayerControllerMobile controller;
  final void Function()? onExpansion;
  final bool? isExpanded;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: AppColors.black.withAlpha(77), blurRadius: 4),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 25,
                child: MediaReplayButton(
                  onTap: () => controller.onReplayForward(true),
                  isReplay: true,
                  size: ScreenUtil.I.isWithinPhoneView ? 48 : 64,
                ),
              ),
              Expanded(
                flex: 70,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InkWell(onTap: controller.onPlayPause),
                    ),
                    Center(
                      child: MediaPlayButton.circular(
                        playingNotifier: controller.playingNotifier,
                        onPressed: controller.onPlayPause,
                        size: ScreenUtil.I.isWithinPhoneView ? 48 : 64,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 25,
                child: MediaReplayButton(
                  onTap: () => controller.onReplayForward(false),
                  isReplay: false,
                  size: ScreenUtil.I.isWithinPhoneView ? 48 : 64,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: UIHelpers.paddingA12,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: UIHelpers.paddingH12,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: controller.positionNotifier,
                          builder: (context, position, child) {
                            return MediaProgress(
                              position: Duration(
                                seconds: (position * controller.duration)
                                    .toInt(),
                              ),
                              duration: Duration(
                                seconds: controller.duration.toInt(),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        MediaPlaybackSpeed(
                          playbackRateNotifier: controller.playbackRateNotifier,
                          onRateChanged: controller.onPlaybackRateChanged,
                        ),
                        if (Platform.isAndroid) ...[
                          UIHelpers.spaceH16,
                          MediaVolumeButton(
                            volumeNotifier: controller.volumeNotifier,
                            muteNotifier: controller.muteNotifier,
                            onVolumeChanged: controller.onVolumeChanged,
                            onMuteUnmute: controller.onMuteUnmute,
                          ),
                        ],
                        // UIHelpers.spaceH16,
                        // const MediaDownloadButton(),
                        if (onExpansion != null) ...[
                          UIHelpers.spaceH16,
                          MediaZoomButton(
                            onTap: onExpansion!,
                            isExpanded: isExpanded ?? false,
                          ),
                        ],
                      ],
                    ),
                  ),
                  UIHelpers.spaceV8,
                  MediaSeeker(
                    positionNotifier: controller.positionNotifier,
                    bufferedNotifier: controller.bufferedNotifier,
                    onChanged: controller.onPositionChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
