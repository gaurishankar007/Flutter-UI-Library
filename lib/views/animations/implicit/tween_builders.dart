import 'dart:math';

import 'package:flutter/material.dart';

import '../../../widgets/clippers/circle_clipper.dart';

Color getRandomColor() => Color(0xFF000000 + Random().nextInt(0x00FFFFFF));

class TweenBuilders extends StatefulWidget {
  const TweenBuilders({super.key});

  @override
  State<TweenBuilders> createState() => _TweenBuildersState();
}

class _TweenBuildersState extends State<TweenBuilders> {
  final double size = 200;
  Color color = getRandomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Tween Builders",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: const Text(
                "Hello world!",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20, width: double.maxFinite),
            TweenAnimationBuilder<Duration>(
              duration: const Duration(minutes: 3),
              tween: Tween(
                begin: const Duration(minutes: 3),
                end: Duration.zero,
              ),
              onEnd: () {
                debugPrint('Timer ended');
              },
              builder: (BuildContext context, Duration value, Widget? child) {
                final minutes = value.inMinutes;
                final seconds = value.inSeconds % 60;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '$minutes:$seconds',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder(
              // It remembers the previous end color
              // And begins with that color after calling set state
              tween: ColorTween(begin: getRandomColor(), end: color),
              onEnd: () => setState(() => color = getRandomColor()),
              duration: const Duration(seconds: 1),
              child: ClipPath(
                clipper: const CircleClipper(),
                child: Container(height: size, width: size, color: Colors.red),
              ),
              builder: (context, color, child) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(color!, BlendMode.srcATop),
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
