import 'package:material_ui/material_ui.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({super.key, this.dimension, this.iconSize});
  final double? dimension;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: Center(
        child: Icon(
          Icons.error_outline_rounded,
          color: Colors.red,
          size: iconSize,
        ),
      ),
    );
  }
}
