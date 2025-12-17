import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/views/home/widgets/animated_view_list.dart';
import 'package:ui_library/views/home/widgets/custom_widget_list.dart';
import 'package:ui_library/widgets/visual_layouts/base_tab_bar.dart';

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
