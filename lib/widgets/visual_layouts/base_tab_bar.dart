
import 'package:flutter/material.dart';

class BaseTabBar extends StatelessWidget {
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;
  final TabBarIndicatorSize? indicatorSize;
  final TabController tabController;
  final List<Tab> tabs;

  const BaseTabBar({
    super.key,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
    this.indicatorSize,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: labelColor ?? Color(0xff0052CC),
      unselectedLabelColor: unselectedLabelColor ?? Color(0XFF49454F),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      indicatorColor: indicatorColor ?? Color(0xff0052CC),
      indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      tabs: tabs,
    );
  }
}
