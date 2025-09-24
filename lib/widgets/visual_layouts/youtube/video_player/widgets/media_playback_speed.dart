import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_colors.dart';
import '../../../base_text.dart';

class MediaPlaybackSpeed extends StatelessWidget {
  final ValueNotifier<double> playbackRateNotifier;
  final Function(double value) onRateChanged;

  const MediaPlaybackSpeed({
    super.key,
    required this.playbackRateNotifier,
    required this.onRateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: playbackRateNotifier,
      builder: (context, playbackRate, child) {
        return PopupMenuButton<double>(
          onSelected: onRateChanged,
          padding: EdgeInsets.zero,
          menuPadding: EdgeInsets.zero,
          icon: Icon(
            Icons.speed_sharp,
            size: kIsWeb ? 40 : 32,
            color: AppColors.white,
          ),
          itemBuilder: (context) {
            return [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0].map((value) {
              final text = value == 1.0 ? "Normal" : "$value";
              final textColor = value == playbackRate
                      ? AppColors.primary
                      : AppColors.black.withAlpha(222);
              return PopupMenuItem(
                value: value,
                child: BaseText(text, color: textColor),
              );
            }).toList();
          },
        );
      },
    );
  }
}
