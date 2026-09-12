import 'package:material_ui/material_ui.dart';

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.width / 2),
      radius: size.width / 2,
    );

    path.addOval(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
