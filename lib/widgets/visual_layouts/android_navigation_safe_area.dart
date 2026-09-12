import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Wraps [child] with a [SafeArea] only when the platform is Android and the
/// device uses 3-button navigation - gesture-nav devices already report
/// their own safe insets, so wrapping them again would double the padding.
class AndroidNavigationSafeArea extends StatelessWidget {
  const AndroidNavigationSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
  });

  final bool left;
  final bool top;
  final bool bottom;
  final bool right;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).systemGestureInsets;
    final isLikelyGestureNavigation = insets.left > 0 || insets.right > 0;

    if (kIsWeb || !Platform.isAndroid || isLikelyGestureNavigation) {
      return child;
    }
    return SafeArea(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: child,
    );
  }
}
