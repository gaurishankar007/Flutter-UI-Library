import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';
import 'package:ui_library/widgets/visual_layouts/loading_circle.dart';

class SecondaryButton extends HookWidget {
  final Function()? onTap;
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

  const SecondaryButton({
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

  @override
  Widget build(BuildContext context) {
    final loadingNotifier = useValueNotifier(false);
    final onPressed = useCallback(() async {
      /// If the button is loading, discard the task
      if (loadingNotifier.value) return;
      // If the button is not loadable
      if (!isLoadable) return onTap?.call();

      loadingNotifier.value = true;
      await onTap?.call();
      // If the widget is disposed, don't update value
      if (context.mounted) loadingNotifier.value = false;
    });

    return SizedBox(
      height: height,
      width: expandWidth ? double.maxFinite : width,
      child: OutlinedButton(
        onPressed: disabled ? null : onPressed.call,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(_getPadding()),
          minimumSize: WidgetStatePropertyAll(Size.zero),
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.primary;
            } else if (states.contains(WidgetState.pressed)) {
              return AppColors.primary;
            } else if (states.contains(WidgetState.hovered)) {
              return AppColors.primary;
            }
            return AppColors.black;
          }),
          side: WidgetStateBorderSide.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: AppColors.primary, width: 1.5);
            } else if (states.contains(WidgetState.pressed)) {
              // Always check for pressed before hovered, because hovered is also included inside pressed
              // So it might reflect hovered state instead of pressed state
              return BorderSide(color: AppColors.primary, width: 1.5);
            } else if (states.contains(WidgetState.hovered)) {
              return BorderSide(color: AppColors.primary, width: 1.5);
            }
            return BorderSide(color: AppColors.primary, width: 1.5);
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: UIHelpers.radiusC8),
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: loadingNotifier,
          builder: (_, loading, _) => _buildChild(loading),
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    double verticalPadding = kIsWeb ? 20 : 16;
    if (label == null && icon != null) {
      return EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 16);
    }

    double leftPadding = isPrefixIcon && icon != null ? 16 : 24;
    double rightPadding = !isPrefixIcon && icon != null ? 16 : 24;
    return EdgeInsets.only(
      top: verticalPadding,
      bottom: verticalPadding,
      left: leftPadding,
      right: rightPadding,
    );
  }

  Widget _buildChild(bool loading) {
    if (loading) return LoadingCircle.small(AppColors.primary);

    if (label != null) {
      final textWidget = BaseText(label!, textAlign: TextAlign.center);

      if (icon == null) return textWidget;
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

    return icon ?? SizedBox.shrink();
  }
}
