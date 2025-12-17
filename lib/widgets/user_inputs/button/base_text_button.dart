import 'package:flutter/material.dart';
import 'package:ui_library/widgets/animations/explicit/loading_circle.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class BaseTextButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Color foregroundColor;
  final double fontSize;
  final FontWeight textFontWeight;
  final EdgeInsets? padding;
  final VisualDensity? visualDensity;
  final double? elevation;
  final bool expanded;
  final bool disabled;
  final bool loading;

  const BaseTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.foregroundColor = Colors.blue,
    this.fontSize = 16,
    this.textFontWeight = FontWeight.normal,
    this.padding,
    this.visualDensity,
    this.elevation,
    this.expanded = false,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = TextButton(
      onPressed: disabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 4),
        visualDensity: visualDensity,
        elevation: elevation,
      ),
      child: BaseText(text, fontSize: fontSize, fontWeight: textFontWeight),
    );

    if (loading) child = LoadingCircle.small(color: Colors.white);

    if (expanded) {
      child = SizedBox(height: 50, width: double.maxFinite, child: child);
    }

    return child;
  }
}
