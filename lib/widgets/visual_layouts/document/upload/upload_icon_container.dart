import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class UploadIconContainer extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  const UploadIconContainer({
    super.key,
    required this.iconData,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap.call();
      },
      borderRadius: UIHelpers.radiusC12,
      child: Ink(
        padding: UIHelpers.paddingA32,
        decoration: BoxDecoration(
          color: AppColors.highlight,
          borderRadius: UIHelpers.radiusC12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: AppColors.white),
            ),
            UIHelpers.spaceV8,
            BaseText(text, fontSize: 16),
          ],
        ),
      ),
    );
  }
}
