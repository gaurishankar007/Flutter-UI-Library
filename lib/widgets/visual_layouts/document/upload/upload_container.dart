import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../utils/ui_helpers.dart';
import '../../../painters/dotted_container.dart';
import '../../base_text.dart';

class UploadContainer extends StatelessWidget {
  final int maxFileCount;
  const UploadContainer({super.key, required this.maxFileCount});

  @override
  Widget build(BuildContext context) {
    return DottedContainer(
      strokeColor: AppColors.primary,
      dashWidth: 6,
      gapWidth: 4,
      borderRadius: UIHelpers.radiusC8,
      child: Container(
        width: double.maxFinite,
        padding: UIHelpers.paddingA24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              color: AppColors.primary,
              size: 32,
            ),
            const BaseText("Click here to add files", color: AppColors.black),
            BaseText(
              "Max $maxFileCount "
              "${maxFileCount > 1 ? "files are" : "file is"} allowed",
              color: AppColors.fade,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
