import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';

class BaseVerticalDivider extends StatelessWidget {
  const BaseVerticalDivider({
    super.key,
    this.thickness,
    this.padding,
    this.color,
    this.indent,
    this.endIndent,
  });
  final double? thickness;
  final EdgeInsets? padding;
  final Color? color;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    final Widget child = VerticalDivider(
      width: 2,
      thickness: thickness ?? 2,
      color: color ?? AppColors.black70,
      indent: indent,
      endIndent: endIndent,
      radius: UIHelpers.radiusC4,
    );
    if (padding == null) {
      return child;
    }
    return Padding(padding: padding!, child: child);
  }
}
