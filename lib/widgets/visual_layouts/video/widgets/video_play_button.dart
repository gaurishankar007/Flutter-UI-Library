import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';

class VideoPlayButton extends StatelessWidget {
  const VideoPlayButton({
    super.key,
    required this.playingNotifier,
    required this.hasEndedNotifier,
    required this.onPressed,
    this.iconSize,
  });

  final ValueNotifier<bool> playingNotifier;
  final ValueNotifier<bool> hasEndedNotifier;
  final void Function() onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: hasEndedNotifier,
      builder: (context, hasEnded, child) {
        return ValueListenableBuilder(
          valueListenable: playingNotifier,
          builder: (context, playing, child) {
            return BaseIconButton(
              onPressed: onPressed,
              icon: Icon(
                hasEnded
                    ? Icons.replay_rounded
                    : (playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded),
                size: iconSize,
                color: AppColors.white,
              ),
              padding: EdgeInsets.zero,
              disableSplash: true,
            );
          },
        );
      },
    );
  }
}
