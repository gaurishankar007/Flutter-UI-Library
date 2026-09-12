import 'package:material_ui/material_ui.dart';

class ErrorIcon extends StatelessWidget {

  const ErrorIcon({super.key, this.height, this.width});
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: const Icon(Icons.error_rounded, color: Colors.red),
    );
  }
}
