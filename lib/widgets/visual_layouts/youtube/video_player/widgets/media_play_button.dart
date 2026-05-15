import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';

class MediaPlayButton extends StatelessWidget {
  const MediaPlayButton({
    super.key,
    required this.playingNotifier,
    required this.onPressed,
    this.iconSize = 32,
  });

  final ValueNotifier<bool> playingNotifier;
  final void Function() onPressed;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: playingNotifier,
      builder: (context, playing, child) {
        return BaseIconButton(
          onPressed: onPressed,
          icon: Icon(
            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: iconSize,
            color: AppColors.white,
          ),
          padding: EdgeInsets.zero,
          disableSplash: true,
        );
      },
    );
  }

  static Widget circular({
    required ValueNotifier<bool> playingNotifier,
    required void Function() onPressed,
  }) => DecoratedBox(
    decoration: BoxDecoration(color: AppColors.black60, shape: BoxShape.circle),
    child: Padding(
      padding: UIHelpers.paddingA16,
      child: MediaPlayButton(
        playingNotifier: playingNotifier,
        onPressed: onPressed,
        iconSize: 64,
      ),
    ),
  );
}
