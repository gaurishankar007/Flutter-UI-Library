import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class Drawer3D extends StatelessWidget {
  const Drawer3D({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer3DWidget(
      drawerBuilder: (context) {
        return Material(
          child: Container(
            color: const Color(0xFF24283B),
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 50,
                left: MediaQuery.of(context).size.width * .25,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "Item ${index + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        );
      },
      childBuilder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "3D Drawer",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Container(color: const Color(0xFF414868)),
        );
      },
    );
  }
}

class Drawer3DWidget extends StatefulWidget {
  final WidgetBuilder drawerBuilder;
  final WidgetBuilder childBuilder;

  const Drawer3DWidget({
    super.key,
    required this.drawerBuilder,
    required this.childBuilder,
  });

  @override
  State<Drawer3DWidget> createState() => _Drawer3DWidgetState();
}

class _Drawer3DWidgetState extends State<Drawer3DWidget>
    with TickerProviderStateMixin {
  late AnimationController xControllerForChild;
  late Animation<double> yRotationAnimationForChild;

  late AnimationController xControllerForDrawer;
  late Animation<double> yRotationAnimationForDrawer;

  @override
  void initState() {
    xControllerForChild = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    yRotationAnimationForChild = Tween<double>(
      begin: 0,
      end: -pi / 2,
    ).animate(xControllerForChild);

    xControllerForDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    yRotationAnimationForDrawer = Tween<double>(
      begin: pi / 2,
      end: 0,
    ).animate(xControllerForDrawer);

    super.initState();
  }

  @override
  void dispose() {
    xControllerForChild.dispose();
    xControllerForDrawer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDragWidth = screenWidth * .8;

    return GestureDetector(
      // While Dragging
      onHorizontalDragUpdate: (details) {
        // Finding the value of dragged amount between 0 to 1
        // Without crossing maxDragWidth
        final value = details.delta.dx / maxDragWidth;

        xControllerForChild.value += value;
        xControllerForDrawer.value += value;
      },
      // When dragging ended
      onHorizontalDragEnd: (details) {
        if (xControllerForChild.value >= 0.5) {
          xControllerForChild.forward();
          xControllerForDrawer.forward();
        } else {
          xControllerForChild.reverse();
          xControllerForDrawer.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          xControllerForChild,
          xControllerForDrawer,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              Container(color: const Color(0xFF1A1B26)),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  // Setting perspective for 3D effect
                  ..setEntry(3, 2, 0.001)
                  // Moving child towards x axis
                  ..translateByVector3(
                    Vector3(xControllerForChild.value * maxDragWidth, 0.0, 0.0),
                  )
                  // Rotating child based on y axis
                  ..rotateY(yRotationAnimationForChild.value),
                child: widget.childBuilder(context),
              ),
              Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  // `-screenWidth` sets start point towards the left side of the screen
                  ..translateByVector3(
                    Vector3(
                      -screenWidth +
                          (xControllerForDrawer.value * maxDragWidth),
                      0.0,
                      0.0,
                    ),
                  )
                  ..rotateY(yRotationAnimationForDrawer.value),
                child: widget.drawerBuilder(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
