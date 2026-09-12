import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class PullToRefresh extends StatelessWidget {
  const PullToRefresh({super.key, required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 24,
      backgroundColor: AppColors.primary100,
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
