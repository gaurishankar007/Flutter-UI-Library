import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:material_ui/material_ui.dart';

/// Forces a light status bar (dark icons on a light background), regardless
/// of the ambient theme - useful for screens with a light app bar/header
/// sitting under an otherwise dark-themed app.
class LightAnnotatedRegion extends StatelessWidget {
  const LightAnnotatedRegion({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: child,
    );
  }
}
