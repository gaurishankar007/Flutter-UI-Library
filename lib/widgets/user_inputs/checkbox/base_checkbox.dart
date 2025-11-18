import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../utils/ui_helpers.dart';
import '../../visual_layouts/base_text.dart';

/// A customizable checkbox with optional label and tristate support.
/// Disabled if [onChanged] is null. Scaled for better visibility.
class BaseCheckbox extends HookWidget {
  final bool? value;
  final bool tristate;
  final Function(bool?)? onChanged;
  final String? label;

  const BaseCheckbox({
    super.key,
    this.value = false,
    this.tristate = false,
    this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onChanged == null;

    Widget child = UnconstrainedBox(
      child: Transform.scale(
        scale: 1.3,
        child: Checkbox(
          value: value,
          tristate: tristate,
          onChanged: isDisabled ? null : onChanged,
        ),
      ),
    );

    if (label == null) return child;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        UIHelpers.spaceH8,
        BaseText(
          label!,
          color:
              isDisabled
                  ? AppColors.black.withAlpha(97)
                  : AppColors.black.withAlpha(222),
        ),
      ],
    );
  }
}
