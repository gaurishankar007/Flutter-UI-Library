import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/bottom_sheet/bottom_sheet_title.dart';
import 'package:ui_library/widgets/user_inputs/bottom_sheet/generic_bottom_sheet.dart';
import 'package:ui_library/widgets/visual_layouts/document/models/document_data.dart';

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
