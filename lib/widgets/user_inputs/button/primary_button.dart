import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';
import 'package:ui_library/widgets/visual_layouts/loading/loading_circle.dart';

class PrimaryButton extends HookWidget {
  const PrimaryButton({
    super.key,
    this.onTap,
    this.label,
    this.textWeight,
    this.icon,
    this.isPrefixIcon = true,
    this.height,
    this.width,
    this.spacing,
    this.expandWidth = false,
    this.isLoadable = false,
    this.disabled = false,
  });
  final Future<void> Function()? onTap;
  final String? label;
  final FontWeight? textWeight;
  final Widget? icon;
  final bool isPrefixIcon;
  final double? height;
  final double? width;
  final double? spacing;
  final bool expandWidth;
  final bool isLoadable;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final loadingNotifier = useValueNotifier(false);
    final onPressed = useCallback(() async {
      /// If the button is loading, discard the task
      if (loadingNotifier.value) {
        return;
      }
      // If the button is not loadable
      if (!isLoadable) {
        return await onTap?.call();
      }

      loadingNotifier.value = true;
      await onTap?.call();
      // If the widget is disposed, don't update value
      if (context.mounted) {
        loadingNotifier.value = false;
      }
    });

    return SizedBox(
      height: height,
      width: expandWidth ? double.maxFinite : width,
      child: FilledButton(
        onPressed: disabled ? null : onPressed.call,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(_getPadding()),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.primary250;
            } else if (states.contains(WidgetState.pressed)) {
              return AppColors.primary900;
            } else if (states.contains(WidgetState.hovered)) {
              return AppColors.primary700;
            }
            return AppColors.primary;
          }),
          minimumSize: const WidgetStatePropertyAll(Size.zero),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.white60;
            }
            return AppColors.white87;
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: UIHelpers.radiusC8),
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: loadingNotifier,
          builder: (builderContext, loading, setState) {
            return _buildChild(loading);
          },
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    const double verticalPadding = kIsWeb ? 20 : 16;
    if (label == null && icon != null) {
      return const EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: 16,
      );
    }

    final double leftPadding = isPrefixIcon && icon != null ? 16 : 24;
    final double rightPadding = !isPrefixIcon && icon != null ? 16 : 24;
    return EdgeInsets.only(
      top: verticalPadding,
      bottom: verticalPadding,
      left: leftPadding,
      right: rightPadding,
    );
  }

  Widget _buildChild(bool loading) {
    if (loading) {
      return LoadingCircle.small(AppColors.white);
    }

    if (label != null) {
      final textWidget = BaseText.button(label!, textAlign: TextAlign.center);

      if (icon == null) {
        return textWidget;
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: spacing ?? 4,
        children: [
          if (isPrefixIcon) icon!,
          Flexible(child: textWidget),
          if (!isPrefixIcon) icon!,
        ],
      );
    }

    return icon ?? const SizedBox.shrink();
  }
}
