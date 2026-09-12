import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/widgets/user_inputs/slider/base_slider.dart';

class VideoPlayerSeeker extends StatelessWidget {
  const VideoPlayerSeeker({
    super.key,
    required this.positionNotifier,
    required this.duration,
    this.onChanged,
    this.onDragStart,
    this.onDragEnd,
  });

  final ValueNotifier<Duration> positionNotifier;
  final Duration duration;
  final void Function(double value)? onChanged;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: positionNotifier,
      builder: (context, position, child) {
        final value = duration.inSeconds > 0
            ? (position.inSeconds / duration.inSeconds).clamp(0.0, 1.0)
            : 0.0;
        return BaseSlider(
          value: value,
          inactiveColor: kIsWeb ? AppColors.white38 : AppColors.black38,
          onChanged: onChanged,
          onChangeStart: (_) => onDragStart?.call(),
          onChangeEnd: (_) => onDragEnd?.call(),
        );
      },
    );
  }
}
