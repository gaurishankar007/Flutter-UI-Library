import 'package:material_ui/material_ui.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';
import 'package:ui_library/widgets/visual_layouts/images/base_asset_image.dart';

class ImageIconText extends StatelessWidget {
  const ImageIconText({
    super.key,
    required this.imageAssetName,
    required this.text,
  });
  final String imageAssetName;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        BaseAssetImage.icon(assetName: imageAssetName),
        BaseText.body(text),
      ],
    );
  }
}
