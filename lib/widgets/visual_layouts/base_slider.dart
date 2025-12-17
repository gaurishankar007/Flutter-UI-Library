import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class BaseSlider extends StatelessWidget {
  final double value;
  final double trackHeight;
  final double thumbRadius;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double min;
  final double max;
  final Function(double value)? onChanged;
  final Function(double value)? onChangeStart;
  final Function(double value)? onChangeEnd;

  const BaseSlider({
    super.key,
    this.value = 0.0,
    this.trackHeight = 2.5,
    this.thumbRadius = 6,
    this.min = 0,
    this.max = 1,
    this.activeColor = AppColors.primary,
    this.inactiveColor = Colors.white38,
    this.thumbColor = AppColors.primary,

    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: activeColor,
        inactiveTrackColor: inactiveColor,
        disabledActiveTrackColor: activeColor,
        disabledInactiveTrackColor: inactiveColor,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: thumbRadius,
          disabledThumbRadius: thumbRadius,
          elevation: 0,
        ),
        trackHeight: trackHeight,
        thumbColor: activeColor,
        overlayColor: Colors.transparent,
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        padding: EdgeInsets.zero,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
      ),
    );
  }
}
