import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class BottomSheetDragHandle extends StatelessWidget {
  const BottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 96,
      height: 6,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: StadiumBorder(),
          color: AppColors.dashedBorder,
        ),
      ),
    );
  }
}
