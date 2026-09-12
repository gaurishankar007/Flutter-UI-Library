import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class BaseDivider extends StatelessWidget {
  const BaseDivider({
    super.key,
    this.padding,
    this.color = AppColors.fade,
    this.indent,
    this.endIndent,
  });
  final EdgeInsets? padding;
  final Color color;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    final Widget child = Divider(
      height: 1,
      thickness: 1,
      color: color,
      indent: indent,
      endIndent: endIndent,
    );
    if (padding == null) {
      return child;
    }
    return Padding(padding: padding!, child: child);
  }
}
