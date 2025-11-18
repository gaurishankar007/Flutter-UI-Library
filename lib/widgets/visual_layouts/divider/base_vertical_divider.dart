import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../utils/ui_helpers.dart';

class BaseVerticalDivider extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const BaseVerticalDivider({
    super.key,
    this.padding,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = VerticalDivider(
      width: 2,
      thickness: 2,
      color: color ?? AppColors.black70,
      indent: indent,
      endIndent: endIndent,
      radius: UIHelpers.radiusC4,
    );
    if (padding == null) return child;
    return Padding(padding: padding!, child: child);
  }
}
