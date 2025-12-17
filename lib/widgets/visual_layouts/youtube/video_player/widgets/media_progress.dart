import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/extensions/duration_extension.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class MediaProgress extends StatelessWidget {
  final int positionInSeconds;
  final int durationInSeconds;

  const MediaProgress({
    super.key,
    required this.positionInSeconds,
    required this.durationInSeconds,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize = kIsWeb ? 18 : 14;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BaseText(
          Duration(seconds: positionInSeconds).formatDuration(),
          color: AppColors.white,
          fontSize: fontSize,
        ),
        BaseText(
          " / ${Duration(seconds: durationInSeconds).formatDuration()}",
          color: AppColors.white,
          fontSize: fontSize,
        ),
      ],
    );
  }
}
