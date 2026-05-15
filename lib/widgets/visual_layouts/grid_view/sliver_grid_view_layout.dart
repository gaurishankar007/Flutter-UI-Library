import 'package:flutter/material.dart';
import 'package:ui_library/utils/screen_util/screen_util.dart';

class SliverGridViewLayout extends StatelessWidget {
  const SliverGridViewLayout({
    super.key,
    this.padding,
    required this.itemCount,
    required this.crossAxisCount,
    this.childAspectRatio = 1,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    required this.itemBuilder,
  });

  final EdgeInsets? padding;
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing ?? ScreenUtil.I.gridSpace(),
        crossAxisSpacing: crossAxisSpacing ?? ScreenUtil.I.gridSpace(),
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
