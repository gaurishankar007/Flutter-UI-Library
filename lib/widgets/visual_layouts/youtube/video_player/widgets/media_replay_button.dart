import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class MediaReplayButton extends StatelessWidget {
  const MediaReplayButton({
    super.key,
    required this.onTap,
    required this.isReplay,
  });

  final void Function() onTap;
  final bool isReplay;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      child: Center(
        child: Icon(
          isReplay ? Icons.replay_5_sharp : Icons.forward_5_sharp,
          size: 64,
          color: AppColors.white,
        ),
      ),
    );
  }
}
