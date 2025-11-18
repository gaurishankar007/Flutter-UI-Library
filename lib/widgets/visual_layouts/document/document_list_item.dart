import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../utils/ui_helpers.dart';
import '../base_text.dart';

class DocumentListItem extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData documentIconData;
  final String title;
  final Widget? trailing;

  const DocumentListItem({
    super.key,
    this.onTap,
    required this.documentIconData,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      minVerticalPadding: 1,
      horizontalTitleGap: 8,
      contentPadding: UIHelpers.paddingH16V12,
      visualDensity: const VisualDensity(vertical: -2),
      tileColor: AppColors.highlight,
      shape: RoundedRectangleBorder(
        borderRadius: UIHelpers.radiusC12,
        side: const BorderSide(color: AppColors.containerBorder),
      ),
      leading: Container(
        padding: UIHelpers.paddingA8,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(documentIconData, color: AppColors.white, size: 18),
      ),
      title: BaseText(title),
      trailing: trailing,
    );
  }
}
