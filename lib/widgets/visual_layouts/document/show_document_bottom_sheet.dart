import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../utils/ui_helpers.dart';
import '../../user_inputs/bottom_sheet/bottom_sheet_title.dart';
import '../../user_inputs/bottom_sheet/generic_bottom_sheet.dart';
import 'models/document_data.dart';

void showDocumentBottomSheet(
  BuildContext context, {
  required DocumentData documentData,
  String? title,
  double? height,
  double? width,
}) => showGenericBottomSheet(
  context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      BottomSheetTitle(title: title ?? "Document"),
      Container(
        width: double.maxFinite,
        padding: UIHelpers.paddingA16,
        color: AppColors.scaffold,
        child: documentData.build(width: width, height: height ?? 300),
      ),
    ],
  ),
);
