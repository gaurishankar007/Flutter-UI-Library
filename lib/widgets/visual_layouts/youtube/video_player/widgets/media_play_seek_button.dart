import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/screen_util/screen_util.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';

class MediaPlaySeekButton extends StatelessWidget {
  final ValueNotifier<bool> playingNotifier;
  final Function() onPlayPauseTap;
  final Function(bool isReplay) onReplayForward;

  const MediaPlaySeekButton({
    super.key,
    required this.playingNotifier,
    required this.onPlayPauseTap,
    required this.onReplayForward,
  });

  @override
  Widget build(BuildContext context) {
    double iconSize = ScreenUtil.I.getResponsiveValue(
      base: 96,
      screens: {
        {.compact, .phone}: 48,
        {.tablet}: 64,
      },
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: [
        BaseIconButton(
          onPressed: () => onReplayForward(true),
          icon: Icon(
            Icons.replay_5_sharp,
            size: iconSize,
            color: AppColors.white,
          ),
          padding: EdgeInsets.zero,
        ),
        ValueListenableBuilder(
          valueListenable: playingNotifier,
          builder: (context, playing, child) {
            return BaseIconButton(
              onPressed: onPlayPauseTap,
              icon: Icon(
                playing ? Icons.pause : Icons.play_arrow,
                size: iconSize,
                color: AppColors.white,
              ),
              padding: EdgeInsets.zero,
            );
          },
        ),
        BaseIconButton(
          onPressed: () => onReplayForward(false),
          icon: Icon(
            Icons.forward_5_sharp,
            size: iconSize,
            color: AppColors.white,
          ),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
