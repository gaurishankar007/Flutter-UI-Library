import 'package:flutter/material.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class OverlayButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final TextAlign? labelAlignment;

  const OverlayButton({
    super.key,
    required this.label,
    required this.onTap,
    this.labelAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: UIHelpers.paddingH16V12,
        child: BaseText(label, textAlign: labelAlignment),
      ),
    );
  }
}
