import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class LinkButton extends HookWidget {
  final Function() onTap;
  final String? label;
  final double textSize;
  final Widget? icon;
  final bool isPrefixIcon;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final bool isLoadable;
  final bool disabled;

  /// Whether the button color should be changed or not based on the widget state.
  final bool fixedColor;

  const LinkButton({
    super.key,
    required this.onTap,
    this.label,
    this.textSize = 17,
    this.icon,
    this.isPrefixIcon = true,
    this.height,
    this.width,
    this.padding,
    this.fixedColor = false,
    this.isLoadable = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorNotifier = useValueNotifier(AppColors.primary);

    return TextButton(
      onPressed: disabled ? null : onTap.call,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        minimumSize: WidgetStatePropertyAll(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (fixedColor) return colorNotifier.value;
          if (states.contains(WidgetState.disabled)) {
            colorNotifier.value = AppColors.black25;
          } else if (states.contains(WidgetState.pressed)) {
            colorNotifier.value = AppColors.primary;
          } else if (states.contains(WidgetState.hovered)) {
            colorNotifier.value = AppColors.primary;
          } else {
            colorNotifier.value = AppColors.black70;
          }

          return colorNotifier.value;
        }),
      ),
      child: ValueListenableBuilder(
        valueListenable: colorNotifier,
        builder: (builderContext, color, setState) {
          return _buildChild(color);
        },
      ),
    );
  }

  Widget _buildChild(Color decorationColor) {
    if (label != null) {
      final textWidget = BaseText(label!, decorationColor: decorationColor);

      if (icon == null) return textWidget;
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          if (isPrefixIcon) icon!,
          Flexible(child: textWidget),
          if (!isPrefixIcon) icon!,
        ],
      );
    }

    return icon ?? SizedBox.shrink();
  }
}
