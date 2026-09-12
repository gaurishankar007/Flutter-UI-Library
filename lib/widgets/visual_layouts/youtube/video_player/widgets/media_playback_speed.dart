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
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class MediaPlaybackSpeed extends StatelessWidget {
  const MediaPlaybackSpeed({
    super.key,
    required this.playbackRateNotifier,
    required this.onRateChanged,
  });
  final ValueNotifier<double> playbackRateNotifier;
  final void Function(double value) onRateChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: playbackRateNotifier,
      builder: (context, newRate, child) {
        return PopupMenuButton<double>(
          onSelected: onRateChanged,
          menuPadding: EdgeInsets.zero,
          splashRadius: 0.1,
          child: BaseText.button('${newRate}X', color: AppColors.white),
          itemBuilder: (context) {
            return [0.5, 1.0, 1.25, 1.5, 2.0].map((rate) {
              return PopupMenuItem(
                value: rate,
                child: BaseText(
                  '${rate}X',
                  color: rate == newRate ? AppColors.primary : null,
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}
