import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class Cube3D extends StatefulWidget {
  const Cube3D({super.key});
  @override
  State<Cube3D> createState() => _Cube3DState();
}

class _Cube3DState extends State<Cube3D> with TickerProviderStateMixin {
  final double size = 100;

  late AnimationController xController;
  late AnimationController yController;
  late AnimationController zController;

  late Tween<double> tween;

  @override
  void initState() {
    super.initState();

    xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    tween = Tween(begin: 0, end: pi * 2);
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    xController
      ..reset()
      ..forward();

    yController
      ..reset()
      ..forward();

    zController
      ..reset()
      ..forward();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text("3D Cube", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size, width: double.maxFinite),
            AnimatedBuilder(
              animation: Listenable.merge([
                xController,
                yController,
                zController,
              ]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  // Rotating in all axis
                  // Tween evaluate gives the value from the given animation/controller
                  // That means tween does no have to animate and return value
                  // It evaluate directly does that
                  transform: Matrix4.identity()
                    ..rotateX(tween.evaluate(xController))
                    ..rotateY(tween.evaluate(yController))
                    ..rotateZ(tween.evaluate(zController)),
                  child: Stack(
                    children: [
                      /// Backs Side
                      Transform(
                        alignment: Alignment.center,
                        // Moving the container behind z axis by   `size` amount
                        // At the back of the green container
                        transform: Matrix4.identity()
                          ..translateByVector3(Vector3(0, 0, -size)),
                        child: Container(
                          color: Colors.deepPurple,
                          width: size,
                          height: size,
                          alignment: Alignment.center,
                          child: const Text(
                            "BACK",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      /// Left Side
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(pi / 2),
                        child: Container(
                          color: Colors.red,
                          width: size,
                          height: size,
                          alignment: Alignment.center,
                          child: const Text(
                            "LEFT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      /// Right Side
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(-pi / 2),
                        child: Container(
                          color: Colors.blue,
                          width: size,
                          height: size,
                          alignment: Alignment.center,
                          child: const Text(
                            "RIGHT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      /// Front Side
                      Container(
                        color: Colors.green,
                        width: size,
                        height: size,
                        alignment: Alignment.center,
                        child: const Text(
                          "Front",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      /// Top Side
                      Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()..rotateX(-pi / 2),
                        child: Container(
                          color: Colors.orange,
                          width: size,
                          height: size,
                          alignment: Alignment.center,
                          child: const Text(
                            "TOP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      /// Bottom Side
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(pi / 2),
                        child: Container(
                          color: Colors.brown,
                          width: size,
                          height: size,
                          alignment: Alignment.center,
                          child: const Text(
                            "BOTTOM",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
