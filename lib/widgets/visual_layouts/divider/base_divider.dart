import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class BaseDivider extends StatelessWidget {
  final EdgeInsets? padding;
  final Color color;
  final double? indent;
  final double? endIndent;

  const BaseDivider({
    super.key,
    this.padding,
    this.color = AppColors.fade,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Divider(
      height: 1,
      thickness: 1,
      color: color,
      indent: indent,
      endIndent: endIndent,
    );
    if (padding == null) return child;
    return Padding(padding: padding!, child: child);
  }
}
