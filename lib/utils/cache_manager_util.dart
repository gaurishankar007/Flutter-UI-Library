import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

abstract final class CacheManagerUtil {
  static final _cacheManager = DefaultCacheManager();

  static Future<File> getFile(String url) async =>
      await _cacheManager.getSingleFile(url);

  static Future<Uint8List> getFileBytes(String fileUrl) async {
    final file = await _cacheManager.getSingleFile(fileUrl);
    return await file.readAsBytes();
  }

  static Stream<FileResponse> getImageFile(
    String url, {
    bool withProgress = false,
  }) => _cacheManager.getFileStream(url, withProgress: withProgress);
}
