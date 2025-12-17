import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class BaseTextField extends HookWidget {
  final String? title;
  final Color? titleColor;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool enabled;
  final String? initialValue;
  final Function(String?)? onChanged;
  final Function()? onTap;
  final TapRegionCallback? onTapOutside;
  final bool obscureText;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const BaseTextField({
    super.key,
    this.title,
    this.titleColor,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.enabled = true,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.validator,
    this.autovalidateMode,
    this.obscureText = false,
    this.focusNode,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final errorNotifier = useValueNotifier(false);

    Widget child = TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      initialValue: initialValue,
      onChanged: onChanged,
      onTap: onTap,
      onTapOutside: onTapOutside,
      validator: (value) {
        final validation = validator?.call(value);
        errorNotifier.value = validation?.isNotEmpty == true;
        return validation;
      },
      readOnly: readOnly,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      obscureText: obscureText,
      obscuringCharacter: "*",
      style: TextStyle(
        color: enabled
            ? AppColors.black.withAlpha(222)
            : AppColors.black.withAlpha(97),
        fontSize: 17,
      ),
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.black.withAlpha(97),
          fontSize: 17,
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
          fontSize: 17,
          height: 1.5,
        ),
        fillColor: enabled ? null : AppColors.primary.withAlpha(127),
        contentPadding: EdgeInsets.only(
          left: prefixIcon == null ? 16 : 8,
          right: suffixIcon == null ? 16 : 8,
          top: 16,
          bottom: 16,
        ),
        prefixIcon: _wrapIcon(prefixIcon, true),
        suffixIcon: _wrapIcon(suffixIcon, false),
        prefixIconConstraints: BoxConstraints(),
        suffixIconConstraints: BoxConstraints(),
      ),
    );

    if (title?.isNotEmpty == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: errorNotifier,
            builder: (context, isError, child) {
              final color = isError ? AppColors.error : titleColor;
              return BaseText(
                title!,
                color: enabled ? color : AppColors.black.withAlpha(97),
              );
            },
          ),
          UIHelpers.spaceV4,
          child,
        ],
      );
    }

    return child;
  }

  Widget? _wrapIcon(Widget? icon, bool isPrefix) {
    if (icon == null) return null;
    return Padding(
      padding: EdgeInsets.only(
        left: isPrefix ? 16 : 0,
        right: isPrefix ? 0 : 16,
      ),
      child: icon,
    );
  }
}
