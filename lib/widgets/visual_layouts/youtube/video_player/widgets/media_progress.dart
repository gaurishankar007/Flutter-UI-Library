import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/extensions/duration_extension.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class MediaProgress extends StatelessWidget {
  const MediaProgress({
    super.key,
    required this.positionInSeconds,
    required this.durationInSeconds,
  });
  final int positionInSeconds;
  final int durationInSeconds;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BaseText.button(
          Duration(seconds: positionInSeconds).formatDuration(),
          color: AppColors.white87,
        ),
        BaseText.body(
          ' / ${Duration(seconds: durationInSeconds).formatDuration()}',
          color: AppColors.white60,
        ),
      ],
    );
  }
}
