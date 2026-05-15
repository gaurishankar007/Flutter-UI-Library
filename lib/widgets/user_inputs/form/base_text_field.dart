import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class BaseTextField extends HookWidget {
  const BaseTextField({
    super.key,
    this.title,
    this.titleColor,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onFieldSubmitted,
    this.validator,
    this.enabled = true,
    this.autovalidateMode,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.disableCounterText = false,
  });

  final String? title;
  final Color? titleColor;
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final void Function(String? value)? onChanged;
  final void Function()? onTap;
  final TapRegionCallback? onTapOutside;
  final void Function(String value)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final bool disableCounterText;

  @override
  Widget build(BuildContext context) {
    final errorNotifier = useValueNotifier(false);

    final Widget child = TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.black38, fontSize: 17),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 17,
          height: 1.5,
        ),
        fillColor: enabled ? null : AppColors.primary50,
        contentPadding:
            contentPadding ??
            EdgeInsets.only(
              left: prefixIcon == null ? 16 : 8,
              right: suffixIcon == null ? 16 : 8,
              top: 16,
              bottom: 16,
            ),
        prefixIcon: _wrapIcon(prefixIcon, true),
        suffixIcon: _wrapIcon(suffixIcon, false),
        prefixIconConstraints: const BoxConstraints(),
        suffixIconConstraints: const BoxConstraints(),
        counterText: disableCounterText ? '' : null,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(
        color: enabled ? AppColors.black87 : AppColors.black38,
        fontSize: 17,
      ),
      readOnly: readOnly,
      obscuringCharacter: '*',
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) {
        final validation = validator?.call(value);
        errorNotifier.value = validation?.isNotEmpty ?? false;
        return validation;
      },
      enabled: enabled,
      autovalidateMode: autovalidateMode,
    );

    if (title?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: errorNotifier,
            builder: (context, isError, child) {
              final color = isError ? AppColors.error : titleColor;
              return BaseText.label(
                title!,
                color: enabled ? color : AppColors.black38,
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
    if (icon == null) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(
        left: isPrefix ? 16 : 0,
        right: isPrefix ? 0 : 16,
      ),
      child: icon,
    );
  }
}
