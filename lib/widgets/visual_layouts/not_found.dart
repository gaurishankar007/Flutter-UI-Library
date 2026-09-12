import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key, required this.text, this.height, this.width});
  final String text;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: BaseText.body(
          text,
          textAlign: TextAlign.center,
          color: AppColors.black38,
        ),
      ),
    );
  }
}
