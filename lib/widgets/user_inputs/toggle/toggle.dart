import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class Toggle extends HookWidget {
  final bool value;
  final Function(bool)? onChanged;
  final String? label;

  const Toggle({super.key, this.value = false, this.onChanged, this.label});

  @override
  Widget build(BuildContext context) {
    final switchState = useState(value);
    final callback = useCallback((bool value) {
      switchState.value = value;
      onChanged?.call(value);
    });
    final isDisabled = onChanged == null;

    Widget child = UnconstrainedBox(
      child: SizedBox(
        width: 40,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Switch(
            value: switchState.value,
            onChanged: isDisabled ? null : callback,
          ),
        ),
      ),
    );

    if (label == null) return child;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        child,
        UIHelpers.spaceH8,
        BaseText(
          label!,
          color: isDisabled
              ? AppColors.black.withAlpha(97)
              : AppColors.black.withAlpha(222),
        ),
      ],
    );
  }
}
