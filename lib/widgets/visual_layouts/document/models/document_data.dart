import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ui_library/widgets/visual_layouts/error_indicator.dart';
import 'package:ui_library/widgets/visual_layouts/images/base_file_image.dart';
import 'package:ui_library/widgets/visual_layouts/images/base_memory_image.dart';
import 'package:ui_library/widgets/visual_layouts/images/cached/base_cached_network_image.dart';
import 'package:ui_library/widgets/visual_layouts/pdf/pdf_file.dart';
import 'package:ui_library/widgets/visual_layouts/pdf/pdf_memory.dart';
import 'package:uuid/uuid.dart';

part 'document_image_data.dart';
part 'document_pdf_data.dart';

/// Holds document data sources
abstract class DocumentData {
  final String id;

  /// document url
  final String? url;

  /// document bytes data
  final Uint8List? uint8List;

  /// document file
  final File? file;

  DocumentData({this.url, this.uint8List, this.file}) : id = const Uuid().v4();

  Widget build({
    double? height,
    double? width,
    BoxFit? fit,
    BorderRadius? borderRadius,
  });
}

extension DocumentDataExtension on DocumentData {
  IconData getIcon() {
    if (this is PDFFileData || this is PDFMemoryData) {
      return Icons.description_outlined;
    } else if (this is ImageFileData ||
        this is ImageNetworkData ||
        this is ImageMemoryData) {
      return Icons.broken_image_outlined;
    }

    return Icons.description_rounded;
  }
}
