import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/ui_helpers.dart';
import '../../../widgets/visual_layouts/base_text.dart';

class AnimatedViewList extends StatelessWidget {
  const AnimatedViewList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: BaseText.heading5("Implicit Animations")),
        SliverToBoxAdapter(child: UIHelpers.spaceV12),
        SliverList.separated(
          itemCount: implicitAnimations.length,
          separatorBuilder: (context, index) => UIHelpers.spaceV8,
          itemBuilder: (context, index) {
            String path = implicitAnimations.keys.elementAt(index);
            String title = path.split("/").last;

            return ListTile(
              onTap: () => Navigator.pushNamed(context, path),
              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
              title: Text(title),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            );
          },
        ),
        SliverToBoxAdapter(child: UIHelpers.spaceV24),
        SliverToBoxAdapter(child: BaseText.heading5("Explicit Animations")),
        SliverToBoxAdapter(child: UIHelpers.spaceV12),
        SliverList.separated(
          itemCount: explicitAnimations.length,
          separatorBuilder: (context, index) => UIHelpers.spaceV8,
          itemBuilder: (context, index) {
            String path = explicitAnimations.keys.elementAt(index);
            String title = path.split("/").last;

            return ListTile(
              onTap: () => Navigator.pushNamed(context, path),
              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
              title: Text(title),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            );
          },
        ),
      ],
    );
  }
}
