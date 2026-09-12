import 'package:material_ui/material_ui.dart';
import 'package:ui_library/utils/ui_helpers.dart';

class BaseIconButton extends StatelessWidget {

  const BaseIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.padding,
    this.minimumSize,
    this.disableSplash = false,
    this.disabled = false,
  });
  final void Function() onPressed;
  final Icon icon;
  final EdgeInsets? padding;
  final Size? minimumSize;
  final bool disableSplash;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final Widget child = IconButton(
      onPressed: disabled ? null : onPressed,
      style: IconButton.styleFrom(
        padding: padding ?? UIHelpers.paddingA8,
        minimumSize: minimumSize ?? Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: disableSplash ? Colors.transparent : null,
      ),
      icon: icon,
    );

    return child;
  }
}
