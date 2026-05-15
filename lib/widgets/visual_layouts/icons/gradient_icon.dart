import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon({
    super.key,
    required this.iconData,
    this.iconSize,
    required this.gradient,
  });

  factory GradientIcon.favorite({double? iconSize}) {
    return GradientIcon(
      iconData: Icons.favorite,
      iconSize: iconSize,
      gradient: const LinearGradient(
        colors: [AppColors.secondary, AppColors.primary],
      ),
    );
  }

  final IconData iconData;
  final double? iconSize;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: gradient.createShader,
      blendMode: BlendMode.srcIn,
      child: Icon(iconData, size: iconSize, color: Colors.white),
    );
  }
}
