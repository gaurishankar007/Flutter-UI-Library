import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class Toggle extends HookWidget {
  const Toggle({super.key, this.value = false, this.onChanged, this.label});
  final bool value;
  final void Function(bool)? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final switchState = useState(value);
    void handleChange(bool newValue) {
      switchState.value = newValue;
      onChanged?.call(newValue);
    }
    final callback = useCallback(handleChange);
    final isDisabled = onChanged == null;

    final Widget child = UnconstrainedBox(
      child: Padding(
        padding: UIHelpers.paddingA2,
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
      ),
    );

    if (label == null) {
      return child;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        UIHelpers.spaceH8,
        BaseText.body(
          label!,
          color: isDisabled
              ? AppColors.black.withAlpha(97)
              : AppColors.black.withAlpha(222),
        ),
      ],
    );
  }
}
