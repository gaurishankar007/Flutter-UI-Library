import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';
import 'package:ui_library/widgets/visual_layouts/loading/loading_circle.dart';

class OptionSelection extends HookWidget {
  const OptionSelection({
    super.key,
    required this.onPressed,
    required this.label,
    this.isSelected = false,
    this.isLoadable = false,
  });
  final void Function() onPressed;
  final String label;
  final bool isSelected;
  final bool isLoadable;

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);

    final onTap = useCallback(() async {
      /// If the widget is loading then, discard the action
      if (loading.value) {
        return;
      }

      if (isLoadable) {
        loading.value = true;
      }
      if (onPressed case final Future<void> Function() onFutureTap) {
        await onFutureTap.call();
      } else {
        onPressed.call();
      }
      if (isLoadable && context.mounted) {
        loading.value = false;
      }
    });

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.maxFinite,
        height: 80,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: UIHelpers.radiusC8,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.gray,
              width: 1.5,
            ),
          ),
          child: Center(
            child: loading.value
                ? LoadingCircle.small()
                : Padding(
                    padding: UIHelpers.paddingA8,
                    child: BaseText.body(label, textAlign: TextAlign.center),
                  ),
          ),
        ),
      ),
    );
  }
}
