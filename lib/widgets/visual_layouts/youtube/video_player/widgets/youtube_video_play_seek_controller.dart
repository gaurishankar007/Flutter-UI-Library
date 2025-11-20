import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../utils/screen_util/screen_util.dart';
import '../util/youtube_media_controller.dart';

class YoutubeVideoPlaySeekController extends HookWidget {
  final YoutubeMediaController controller;
  const YoutubeVideoPlaySeekController({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final replayState = useValueNotifier(false);
    final forwardState = useValueNotifier(false);

    return Row(
      children: [
        Expanded(
          flex: 25,
          child: _buildSeekButton(
            isReplay: true,
            visibilityNotifier: replayState,
          ),
        ),
        Expanded(
          flex: 70,
          child: GestureDetector(onTap: controller.onPlayPause),
        ),
        Expanded(
          flex: 25,
          child: _buildSeekButton(
            isReplay: false,
            visibilityNotifier: forwardState,
          ),
        ),
      ],
    );
  }

  Widget _buildSeekButton({
    required bool isReplay,
    required ValueNotifier<bool> visibilityNotifier,
  }) {
    return InkWell(
      onHover: (value) => visibilityNotifier.value = value,
      onTap: kIsWeb ? () => controller.onReplayForward(isReplay) : null,
      onDoubleTap: kIsWeb
          ? null
          : () {
              controller.onReplayForward(isReplay);
              visibilityNotifier.value = true;
              Future.delayed(
                Duration(milliseconds: 500),
                () => visibilityNotifier.value = false,
              );
            },
      mouseCursor: SystemMouseCursors.basic,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      child: ValueListenableBuilder(
        valueListenable: visibilityNotifier,
        builder: (builder, visible, child) {
          if (!visible) return SizedBox.expand();
          return DecoratedBox(
            decoration: BoxDecoration(color: AppColors.black.withAlpha(63)),
            child: Center(
              child: Icon(
                isReplay ? Icons.replay_5_sharp : Icons.forward_5_sharp,
                size: ScreenUtil.I.getResponsiveValue(
                  base: 96,
                  screens: {
                    {.compact, .phone}: 40,
                    {.tablet}: 64,
                  },
                ),
                color: AppColors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
