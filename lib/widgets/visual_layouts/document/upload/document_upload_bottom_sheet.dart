import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/ui_helpers.dart';
import '../../../user_inputs/bottom_sheet/bottom_sheet_title.dart';
import '../models/document_type.dart';
import 'upload_icon_container.dart';

class DocumentUploadBottomSheet extends StatelessWidget {
  final bool multiSelector;
  final Function(List<File> imageFiles) onSelection;
  final DocumentType documentType;

  const DocumentUploadBottomSheet({
    super.key,
    this.multiSelector = true,
    required this.onSelection,
    required this.documentType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BottomSheetTitle(
          title: "Select Option",
          titleAlignment: Alignment.center,
        ),
        UIHelpers.spaceV16,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            UploadIconContainer(
              iconData: Icons.cloud_upload,
              text: "Upload Image",
              onTap: () async {
                if (documentType == DocumentType.images) {
                  await pickUpImages(ImageSource.gallery);
                } else {
                  await pickUpFiles();
                }
              },
            ),
            UploadIconContainer(
              iconData: Icons.add_a_photo_outlined,
              text: "Take Photo",
              onTap: () async => await pickUpImages(ImageSource.camera),
            ),
          ],
        ),
        UIHelpers.spaceV16,
      ],
    );
  }

  Future<void> pickUpImages(ImageSource source) async {
    List<XFile> xFiles = [];
    if (multiSelector && source == ImageSource.gallery) {
      xFiles = await ImagePicker().pickMultiImage();
    } else {
      final xFile = await ImagePicker().pickImage(source: source);
      if (xFile != null) xFiles.add(xFile);
    }

    if (xFiles.isEmpty) return;
    onSelection.call(xFiles.map((e) => File(e.path)).toList());
  }

  Future<void> pickUpFiles() async {
    final filePicker = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: documentType.allowedFileTypes,
    );

    if (filePicker == null) return;
    onSelection.call(filePicker.files.map((e) => File(e.xFile.path)).toList());
  }
}
