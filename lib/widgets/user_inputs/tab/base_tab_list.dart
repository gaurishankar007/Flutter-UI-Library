import 'package:flutter/material.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/tab/base_tab.dart';
import 'package:ui_library/widgets/visual_layouts/divider/base_divider.dart';

class BaseTabList extends StatelessWidget {
  const BaseTabList({super.key, required this.tabs, this.padding});
  final List<BaseTab> tabs;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ScrollPhysics(),
          child: Row(spacing: 12, children: tabs),
        ),
        UIHelpers.spaceV12,
        const BaseDivider(),
      ],
    );
    if (padding == null) {
      return child;
    }
    return Padding(padding: padding!, child: child);
  }
}
