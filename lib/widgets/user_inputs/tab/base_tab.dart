import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class BaseTab extends StatelessWidget {
  const BaseTab({
    super.key,
    this.onTap,
    required this.label,
    this.labelColor,
    this.iconData,
    this.iconColor,
    this.icon,
    required this.isSelected,
  });

  final void Function()? onTap;
  final String label;
  final Color? labelColor;
  final IconData? iconData;
  final Color? iconColor;
  final Widget? icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: isSelected ? AppColors.white87 : null,
          ),
          child: Padding(
            padding: UIHelpers.paddingH16V12.copyWith(
              left: iconData == null ? 16 : 12,
            ),
            child: _buildChild(),
          ),
        ),
      ),
    );
  }

  Widget _buildChild() {
    final Widget textWidget = BaseText.button(label, color: labelColor);
    if (iconData == null && icon == null) {
      return textWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon ?? Icon(iconData, color: iconColor),
        UIHelpers.spaceH8,
        textWidget,
      ],
    );
  }
}
