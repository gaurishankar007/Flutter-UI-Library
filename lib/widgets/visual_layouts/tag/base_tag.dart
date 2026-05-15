import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class BaseTag extends StatelessWidget {
  const BaseTag({super.key, required this.label, this.iconData});

  final String label;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    Widget child = BaseText.body(label);
    if (iconData != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [Icon(iconData), child],
      );
    }

    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: StadiumBorder(side: BorderSide(color: AppColors.primary250)),
      ),
      child: Padding(padding: UIHelpers.paddingH16V4, child: child),
    );
  }
}
