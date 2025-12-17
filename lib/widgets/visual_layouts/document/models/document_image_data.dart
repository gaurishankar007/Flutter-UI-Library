part of 'document_data.dart';

class ImageNetworkData extends DocumentData {
  ImageNetworkData({required String url}) : super(url: url);

  @override
  Widget build({
    double? height,
    double? width,
    BoxFit? fit,
    BorderRadius? borderRadius,
  }) {
    return BaseCachedNetworkImage(
      url: url ?? "",
      height: height,
      width: width,
      fit: fit,
      borderRadius: borderRadius,
    );
  }
}

class ImageFileData extends DocumentData {
  ImageFileData({required File assetFile}) : super(file: assetFile);

  @override
  Widget build({
    double? height,
    double? width,
    BoxFit? fit,
    BorderRadius? borderRadius,
  }) {
    return BaseFileImage(
      file: file!,
      height: height,
      width: width,
      fit: fit,
      borderRadius: borderRadius,
    );
  }
}

class ImageMemoryData extends DocumentData {
  ImageMemoryData({required Uint8List uint8List}) : super(uint8List: uint8List);

  @override
  Widget build({
    double? height,
    double? width,
    BoxFit? fit,
    BorderRadius? borderRadius,
  }) {
    if (uint8List?.isNotEmpty != true) {
      return ErrorIndicator(dimension: height, iconSize: 64);
    }

    return BaseMemoryImage(
      uint8List: uint8List!,
      height: height,
      width: width,
      fit: fit,
      borderRadius: borderRadius,
    );
  }
}
