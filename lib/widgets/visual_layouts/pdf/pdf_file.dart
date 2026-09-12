import 'dart:io';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/widgets/visual_layouts/error_indicator.dart';

class PDFFile extends StatelessWidget {

  const PDFFile({
    super.key,
    required this.file,
    this.height,
    this.width,
    this.swipeHorizontal,
    this.pageFling,
  });
  final File file;
  final double? height;
  final double? width;
  final bool? swipeHorizontal;
  final bool? pageFling;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: PDFView(
        filePath: file.path,
        swipeHorizontal: swipeHorizontal ?? false,
        pageFling: pageFling ?? true,
        onError: (_) => const ErrorIndicator(),
        onPageError: (_, _) => const ErrorIndicator(),
      ),
    );
  }
}
