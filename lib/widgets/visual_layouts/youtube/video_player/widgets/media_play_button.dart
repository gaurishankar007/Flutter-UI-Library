import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';

class MediaPlayButton extends StatelessWidget {
  final ValueNotifier<bool> playingNotifier;
  final Function() onPressed;

  const MediaPlayButton({
    super.key,
    required this.playingNotifier,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: playingNotifier,
      builder: (context, playing, child) {
        return BaseIconButton(
          onPressed: onPressed,
          icon: Icon(
            playing ? Icons.pause : Icons.play_arrow,
            size: kIsWeb ? 40 : 32,
            color: AppColors.white,
          ),
          padding: EdgeInsets.zero,
          disableSplash: true,
        );
      },
    );
  }
}
