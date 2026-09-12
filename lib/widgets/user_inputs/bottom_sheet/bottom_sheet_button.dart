import 'package:material_ui/material_ui.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/button/primary_button.dart';
import 'package:ui_library/widgets/user_inputs/button/secondary_button.dart';

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    super.key,
    required this.onTap,
    required this.text,
    this.loadableButton = true,
    this.isSecondary = false,
    this.topPadding,
    this.bottomPadding,
  });
  final Future<void> Function() onTap;
  final String text;
  final bool loadableButton;
  final bool isSecondary;
  final double? topPadding;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UIHelpers.paddingTB(top: topPadding, bottom: bottomPadding),
      child: isSecondary
          ? SecondaryButton(
              label: text,
              onTap: onTap,
              expandWidth: true,
              isLoadable: loadableButton,
            )
          : PrimaryButton(
              label: text,
              onTap: onTap,
              expandWidth: true,
              isLoadable: loadableButton,
            ),
    );
  }
}
