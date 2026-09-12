import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/screen_util/screen_util.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class DateTimelineButton extends StatelessWidget {
  const DateTimelineButton({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary200 : Colors.transparent,
        borderRadius: UIHelpers.radiusC8,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: UIHelpers.radiusC8,
        hoverColor: AppColors.primary200,
        highlightColor: AppColors.primary250,
        child: Padding(
          padding: ScreenUtil.I.isWithinPhoneView
              ? UIHelpers.paddingA8
              : UIHelpers.paddingH16V12,
          child: BaseText(
            label,
            fontSize: ScreenUtil.I.isWithinPhoneView ? 15 : 17,
          ),
        ),
      ),
    );
  }
}
