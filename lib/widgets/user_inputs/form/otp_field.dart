import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/divider/base_divider.dart';

class OTPField extends StatelessWidget {
  const OTPField({
    super.key,
    this.otpLength = 6,
    this.controller,
    this.onChanged,
    this.onComplete,
    this.enabled = true,
    this.hasError = false,
  });

  final int otpLength;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onComplete;
  final bool enabled;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: otpLength,
      controller: controller,
      onChanged: onChanged,
      onCompleted: onComplete,
      enabled: enabled,
      separatorBuilder: (index) {
        final isMiddle = index == (otpLength / 2) - 1;
        return isMiddle ? _buildTextFieldDivider() : UIHelpers.spaceH8;
      },
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      defaultPinTheme: PinTheme(
        width: 55,
        height: 55,
        padding: _getPadding(),
        decoration: _getBoxDecoration(borderColor: AppColors.primary200),
        textStyle: _getTextStyle(),
      ),
      focusedPinTheme: PinTheme(
        width: 55,
        height: 55,
        padding: _getPadding(),
        decoration: _getBoxDecoration(
          color: AppColors.primary50,
          borderColor: AppColors.primary,
        ),
        textStyle: _getTextStyle(),
      ),
      disabledPinTheme: PinTheme(
        width: 55,
        height: 55,
        padding: _getPadding(),
        decoration: _getBoxDecoration(borderColor: AppColors.gray),
        textStyle: _getTextStyle(AppColors.gray),
      ),
    );
  }

  EdgeInsets _getPadding() =>
      kIsWeb ? UIHelpers.paddingV1 : UIHelpers.paddingV4;

  Widget _buildTextFieldDivider() =>
      const SizedBox(width: 20, child: BaseDivider(indent: 5, endIndent: 5));

  BoxDecoration _getBoxDecoration({Color? color, required Color borderColor}) =>
      BoxDecoration(
        color: color,
        borderRadius: UIHelpers.radiusC8,
        border: Border.all(color: hasError ? AppColors.error : borderColor),
      );

  TextStyle _getTextStyle([Color? color]) =>
      TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: color);
}
