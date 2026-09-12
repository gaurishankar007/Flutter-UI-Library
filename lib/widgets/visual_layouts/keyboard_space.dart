import 'package:material_ui/material_ui.dart';

/// The vertical space is increased and decreased based on the keyboard appearance.
/// When the keyboard is not opened, the vertical space is zero,
/// Otherwise it occupies the space equivalent to the height of the keyboard
class KeyboardSpace extends StatelessWidget {
  const KeyboardSpace({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(height: bottomPadding.positiveValue());
  }
}

extension DoubleExtension on double {
  double positiveValue() => this < 0 ? 0 : this;
}
