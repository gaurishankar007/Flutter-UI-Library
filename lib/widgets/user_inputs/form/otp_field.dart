import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../core/constants/app_colors.dart';
import '../../../utils/ui_helpers.dart';

class OTPField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool hasError;

  const OTPField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UIHelpers.paddingV32,
      child: Pinput(
        controller: controller,
        onChanged: onChanged,
        separatorBuilder: (index) => UIHelpers.spaceH12,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        defaultPinTheme: PinTheme(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: UIHelpers.radiusC12,
            border: Border.all(
              color: hasError ? AppColors.error : AppColors.border,
            ),
          ),
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
