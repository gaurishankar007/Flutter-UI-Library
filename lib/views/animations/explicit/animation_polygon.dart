import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_library/widgets/painters/polygon_painter.dart';

class AnimationWithPolygon extends StatefulWidget {
  const AnimationWithPolygon({super.key});
  @override
  State<AnimationWithPolygon> createState() => _AnimationWithPolygonState();
}

class _AnimationWithPolygonState extends State<AnimationWithPolygon>
    with TickerProviderStateMixin {
  late AnimationController sideController;
  late AnimationController radiusController;
  late AnimationController rotationController;

  late Animation<int> sideAnimation;
  late Animation<double> radiusAnimation;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();
    sideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    sideAnimation = IntTween(begin: 3, end: 10).animate(sideController);
    radiusAnimation = Tween<double>(
      begin: 50,
      end: 300,
    ).chain(CurveTween(curve: Curves.bounceInOut)).animate(sideController);
    rotationAnimation = Tween<double>(
      begin: 0,
      end: pi * 2,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(rotationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sideController.repeat(reverse: true);
    radiusController.repeat(reverse: true);
    rotationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    sideController.dispose();
    radiusController.dispose();
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Animated Polygon",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([sideController, radiusController]),
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(rotationAnimation.value)
                  ..rotateY(rotationAnimation.value)
                  ..rotateZ(rotationAnimation.value),
                child: CustomPaint(
                  painter: PolygonPainter(sides: sideAnimation.value),
                  child: SizedBox(
                    height: radiusAnimation.value,
                    width: radiusAnimation.value,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
