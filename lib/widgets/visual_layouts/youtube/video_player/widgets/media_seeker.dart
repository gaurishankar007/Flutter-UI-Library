// © 2026 vAIolin LLC. All rights reserved.
//
// This software and its associated materials are the intellectual
// property of vAIolin LLC. Unauthorized copying, modification,
// distribution, or use of this code, in whole or in part, without
// express written permission from vAIolin LLC is strictly prohibited.
//
// For licensing inquiries, contact: snehesh@vaiolin.ai

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/widgets/user_inputs/slider/base_slider.dart';

class MediaSeeker extends StatelessWidget {
  const MediaSeeker({
    super.key,
    required this.positionNotifier,
    required this.bufferedNotifier,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  /// A stream of double between 0 to 1 of the current position of the media player.
  final ValueNotifier<double> positionNotifier;

  /// A stream of double between 0 and 1 that specifying the buffered percentage
  final ValueNotifier<double> bufferedNotifier;

  final void Function(double value)? onChanged;
  final void Function(double value)? onChangeStart;
  final void Function(double value)? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: bufferedNotifier,
          builder: (context, buffered, child) {
            return BaseSlider(
              value: buffered.clamp(0, 1),
              activeColor: AppColors.white60,
              inactiveColor: kIsWeb ? AppColors.white38 : AppColors.black38,
              trackHeight: 6,
              trackShape: const RectangularSliderTrackShape(),
              thumbRadius: 0,
              thumbColor: Colors.transparent,
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: positionNotifier,
          builder: (context, position, child) {
            return BaseSlider(
              value: position.clamp(0, 1),
              inactiveColor: Colors.transparent,
              trackHeight: 6,
              trackShape: const RectangularSliderTrackShape(),
              onChanged: onChanged,
              onChangeStart: onChangeStart,
              onChangeEnd: onChangeEnd,
            );
          },
        ),
      ],
    );
  }
}
