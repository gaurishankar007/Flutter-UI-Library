import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';
import 'package:ui_library/widgets/visual_layouts/loading/loading_circle.dart';

class LinkButton extends HookWidget {
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
    this.foregroundColor,
    this.textDecorationColor,
    this.isLoadable = false,
    this.disabled = false,
  });

  final void Function() onTap;
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

  /// Color to use when [fixedColor] is true. Defaults to [AppColors.primary].
  final Color? foregroundColor;
  final Color? textDecorationColor;

  @override
  Widget build(BuildContext context) {
    final loadingNotifier = useValueNotifier(false);

    final onPressed = useCallback(() async {
      /// If the button is loading, discard the task
      if (loadingNotifier.value) {
        return;
      }

      if (isLoadable) {
        loadingNotifier.value = true;
      }

      if (onTap case final Future<void> Function() onFutureTap) {
        await onFutureTap.call();
      } else {
        onTap.call();
      }

      // If the widget is disposed, don't update value
      if (context.mounted && isLoadable) {
        loadingNotifier.value = false;
      }
    }, [onTap, isLoadable]);

    return TextButton(
      onPressed: disabled ? null : onPressed.call,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        minimumSize: const WidgetStatePropertyAll(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (fixedColor) {
            return foregroundColor ?? AppColors.primary;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.black25;
          } else if (states.contains(WidgetState.pressed)) {
            return AppColors.primary;
          } else if (states.contains(WidgetState.hovered)) {
            return AppColors.primary;
          }
          return AppColors.black70;
        }),
      ),
      child: ValueListenableBuilder(
        valueListenable: loadingNotifier,
        builder: (builderContext, loading, setState) {
          return _buildChild(loading);
        },
      ),
    );
  }

  Widget _buildChild(bool loading) {
    if (loading) {
      return const LoadingCircle(
        strokeWidth: 2,
        dimension: 16,
        centered: false,
      );
    }

    if (label != null) {
      final textWidget = BaseText.link(
        label!,
        fontSize: textSize,
        decorationColor: textDecorationColor,
      );

      if (icon == null) {
        return textWidget;
      }
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

    return icon ?? const SizedBox.shrink();
  }
}
