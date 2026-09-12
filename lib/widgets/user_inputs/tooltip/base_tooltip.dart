import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class BaseTooltip extends StatelessWidget {
  const BaseTooltip({
    super.key,
    required this.label,
    this.iconData,
    required this.child,
  });

  final String label;
  final IconData? iconData;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      richMessage: TextSpan(
        children: [
          if (iconData != null) ...[
            WidgetSpan(child: Icon(iconData, color: Colors.white)),
            WidgetSpan(child: UIHelpers.spaceH8),
          ],
          WidgetSpan(child: BaseText.label(label, color: AppColors.white87)),
        ],
      ),
      decoration: BoxDecoration(borderRadius: UIHelpers.radiusC8),
      padding: UIHelpers.paddingH16V12,
      child: child,
    );
  }
}
