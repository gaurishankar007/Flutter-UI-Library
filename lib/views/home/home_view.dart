import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../utils/ui_helpers.dart';
import '../../widgets/visual_layouts/base_tab_bar.dart';
import 'widgets/animated_view_list.dart';
import 'widgets/custom_widget_list.dart';

class HomeView extends HookWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter UI Library')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BaseTabBar(
                tabController: tabController,
                tabs: [
                  Tab(text: "Custom Widgets"),
                  Tab(text: "Animated Views"),
                ],
              ),
              UIHelpers.spaceV24,
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [CustomWidgetList(), AnimatedViewList()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
