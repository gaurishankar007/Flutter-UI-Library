import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/cache_manager_util.dart';
import 'package:ui_library/widgets/animations/explicit/gradient_loading.dart';
import 'package:ui_library/widgets/visual_layouts/pdf/pdf_memory.dart';

class CachedNetworkPdfViewer extends HookWidget {
  const CachedNetworkPdfViewer({
    super.key,
    required this.pdfUrl,
    this.cacheKey,
    this.height,
    this.width,
    this.swipeHorizontal,
    this.pageFling,
  });
  final String pdfUrl;

  /// Overrides the cache key (defaults to [pdfUrl]); include a version/
  /// updated-at value so a change forces a re-fetch instead of a stale hit.
  final String? cacheKey;
  final double? height;
  final double? width;
  final bool? swipeHorizontal;
  final bool? pageFling;

  @override
  Widget build(BuildContext context) {
    final pdfFuture = useMemoized(
      () => CacheManagerUtil.getFileBytes(pdfUrl, cacheKey: cacheKey),
      [pdfUrl, cacheKey],
    );
    final snapshot = useFuture(pdfFuture);

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const GradientLoading(centered: true);
    } else if (snapshot.hasError || snapshot.data == null) {
      return const Center(
        child: Icon(
          Icons.picture_as_pdf_rounded,
          color: AppColors.gray,
          size: 50,
        ),
      );
    } else {
      return PDFMemory(
        pdfData: snapshot.data!,
        height: height,
        width: width,
        swipeHorizontal: swipeHorizontal,
        pageFling: pageFling,
      );
    }
  }
}
