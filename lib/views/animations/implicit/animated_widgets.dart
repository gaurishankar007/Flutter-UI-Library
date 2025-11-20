import 'package:flutter/material.dart';

class AnimatedWidgets extends StatefulWidget {
  const AnimatedWidgets({super.key});

  @override
  State<AnimatedWidgets> createState() => _AnimatedWidgetsState();
}

class _AnimatedWidgetsState extends State<AnimatedWidgets> {
  double width = 200;
  Color color = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Animated Widgets",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Animated Container"),
            const SizedBox(height: 10, width: double.maxFinite),
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.bounceOut,
              width: width,
              height: 200,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() {
                if (width == 200) {
                  width = 400;
                } else {
                  width = 200;
                }
              }),
              child: const Text("Animate Size"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() {
                if (color == Colors.deepOrange) {
                  color = Colors.deepPurple;
                } else {
                  color = Colors.deepOrange;
                }
              }),
              child: const Text("Animate Color"),
            ),
          ],
        ),
      ),
    );
  }
}
