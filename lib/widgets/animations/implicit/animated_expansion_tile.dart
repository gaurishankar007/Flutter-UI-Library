import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../utils/screen_util/screen_util.dart';
import '../../../utils/ui_helpers.dart';
import '../../user_inputs/button/base_icon_button.dart';
import '../../visual_layouts/base_text.dart';

class AnimatedExpansionTile extends HookWidget {
  final String title;
  final Widget child;
  final int animationTimeInMilliseconds;

  const AnimatedExpansionTile({
    super.key,
    required this.title,
    required this.child,
    this.animationTimeInMilliseconds = 350,
  });

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
      upperBound: 1,
    );
    final sizeAnimation = useAnimationController(
      duration: animationDuration,
      reverseDuration: animationDuration,
      initialValue: 1,
      lowerBound: 0,
      upperBound: 1,
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
          axisAlignment: -1,
          child: Padding(
            padding: ScreenUtil.I.getMobileValue(
              base: UIHelpers.paddingT32,
              screen12: UIHelpers.paddingT24,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
