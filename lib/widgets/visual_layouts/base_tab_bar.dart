import 'package:material_ui/material_ui.dart';

class BaseTabBar extends StatelessWidget {

  const BaseTabBar({
    super.key,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
    this.indicatorSize,
    required this.tabController,
    required this.tabs,
  });
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;
  final TabBarIndicatorSize? indicatorSize;
  final TabController tabController;
  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: labelColor ?? const Color(0xff0052CC),
      unselectedLabelColor: unselectedLabelColor ?? const Color(0XFF49454F),
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      indicatorColor: indicatorColor ?? const Color(0xff0052CC),
      indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
      tabs: tabs,
    );
  }
}
