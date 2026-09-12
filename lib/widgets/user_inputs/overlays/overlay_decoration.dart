import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';

class OverlayDecoration extends StatelessWidget {

  const OverlayDecoration({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: UIHelpers.radiusC8,
        border: Border.all(color: AppColors.fade),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 20,
            color: AppColors.black.withAlpha(25),
          ),
        ],
      ),
      child: Padding(padding: padding ?? UIHelpers.paddingA12, child: child),
    );
  }
}
