import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../utils/ui_helpers.dart';

class OverlayDecoration extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const OverlayDecoration({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: UIHelpers.radiusC8,
        border: Border.all(color: AppColors.fade),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 20,
            color: AppColors.black.withAlpha(25),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? UIHelpers.paddingA12,
        child: child,
      ),
    );
  }
}
