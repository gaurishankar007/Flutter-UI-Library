import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/utils/screen_util/screen_util.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class AnimatedExpansionTile extends HookWidget {

  const AnimatedExpansionTile({
    super.key,
    required this.title,
    required this.child,
    this.animationTimeInMilliseconds = 350,
  });
  final String title;
  final Widget child;
  final int animationTimeInMilliseconds;

  @override
  Widget build(BuildContext context) {
    final animationDuration = Duration(
      milliseconds: animationTimeInMilliseconds,
    );
    final rotationAnimation = useAnimationController(
      duration: animationDuration,
      reverseDuration: animationDuration,
      initialValue: 1,
      lowerBound: .5,
    );
    final sizeAnimation = useAnimationController(
      duration: animationDuration,
      reverseDuration: animationDuration,
      initialValue: 1,
    );
    final onRotateTap = useCallback(() {
      if (rotationAnimation.isCompleted) {
        rotationAnimation.reverse();
        sizeAnimation.reverse();
        return;
      }
      rotationAnimation.forward();
      sizeAnimation.forward();
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaseText.heading3(title),
            RotationTransition(
              turns: rotationAnimation,
              child: BaseIconButton(
                onPressed: onRotateTap,
                icon: const Icon(Icons.keyboard_arrow_up, size: 30),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        SizeTransition(
          sizeFactor: sizeAnimation,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: ScreenUtil.I.mobileValue(
              base: UIHelpers.paddingT32,
              mobile: UIHelpers.paddingT24,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
