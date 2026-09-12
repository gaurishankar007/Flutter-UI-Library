import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class BaseSlider extends StatelessWidget {
  const BaseSlider({
    super.key,
    this.value = 0.0,
    this.trackHeight = 4.0,
    this.trackShape,
    this.thumbRadius = 6,
    this.min = 0,
    this.max = 1,
    this.activeColor = AppColors.secondary,
    this.inactiveColor = Colors.white38,
    this.thumbColor = AppColors.secondary,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  final double value;
  final double trackHeight;
  final SliderTrackShape? trackShape;
  final double thumbRadius;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double min;
  final double max;
  final void Function(double value)? onChanged;
  final void Function(double value)? onChangeStart;
  final void Function(double value)? onChangeEnd;

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
        trackShape: trackShape,
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
