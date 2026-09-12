import 'package:flutter/widgets.dart';

class VerticalSpace extends StatelessWidget {
  const VerticalSpace({super.key, required this.spaceNotifier, this.width});
  final ValueNotifier<double> spaceNotifier;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: spaceNotifier,
      builder: (context, space, child) {
        return SizedBox(height: space, width: width);
      },
    );
  }
}
