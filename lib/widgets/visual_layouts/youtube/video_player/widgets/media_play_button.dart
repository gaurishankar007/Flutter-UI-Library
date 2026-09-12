// © 2026 vAIolin LLC. All rights reserved.
//
// This software and its associated materials are the intellectual
// property of vAIolin LLC. Unauthorized copying, modification,
// distribution, or use of this code, in whole or in part, without
// express written permission from vAIolin LLC is strictly prohibited.
//
// For licensing inquiries, contact: snehesh@vaiolin.ai

import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';

class MediaPlayButton extends StatelessWidget {
  const MediaPlayButton({
    super.key,
    required this.playingNotifier,
    required this.onPressed,
    this.iconSize,
  });

  final ValueNotifier<bool> playingNotifier;
  final void Function() onPressed;
  final double? iconSize;

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
    double? size,
  }) => DecoratedBox(
    decoration: const BoxDecoration(color: AppColors.black60, shape: BoxShape.circle),
    child: Padding(
      padding: UIHelpers.paddingA16,
      child: MediaPlayButton(
        playingNotifier: playingNotifier,
        onPressed: onPressed,
        iconSize: size,
      ),
    ),
  );
}
