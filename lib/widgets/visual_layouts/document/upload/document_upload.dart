import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/bottom_sheet/generic_bottom_sheet.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';
import 'package:ui_library/widgets/visual_layouts/document/models/document_type.dart';
import 'package:ui_library/widgets/visual_layouts/document/upload/document_upload_bottom_sheet.dart';
import 'package:ui_library/widgets/visual_layouts/document/upload/upload_container.dart';

class DocumentUpload extends StatelessWidget {
  /// A callback functions for providing list of selected images
  final Function(List<File> imageFiles) onSelection;
  final bool multiSelector;
  final int maxFileCount;

  /// Allows to pick specific file types
  final DocumentType documentType;

  const DocumentUpload({
    super.key,
    this.multiSelector = true,
    required this.onSelection,
    required this.maxFileCount,
    required this.documentType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => showGenericBottomSheet(
            context,
            child: DocumentUploadBottomSheet(
              multiSelector: multiSelector,
              onSelection: onSelection,
              documentType: documentType,
            ),
          ),
          borderRadius: UIHelpers.radiusC8,
          splashFactory: InkSplash.splashFactory,
          splashColor: AppColors.highlight,
          child: UploadContainer(maxFileCount: maxFileCount),
        ),
        UIHelpers.spaceV8,
        BaseText(
          "Only support "
          "${documentType.allowedFileTypes.join(", ")} files.",
          color: AppColors.fade,
          fontSize: 12,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
