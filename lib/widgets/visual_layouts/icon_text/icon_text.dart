import 'package:material_ui/material_ui.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class IconText extends StatelessWidget {
  const IconText({
    super.key,
    required this.iconData,
    required this.text,
    this.color,
  });
  final IconData iconData;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        Icon(iconData, color: color),
        BaseText.body(text, color: color),
      ],
    );
  }
}
