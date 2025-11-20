import 'package:flutter/material.dart';

class BouncingSize extends StatefulWidget {
  const BouncingSize({super.key});

  @override
  State<BouncingSize> createState() => _BouncingSizeState();
}

class _BouncingSizeState extends State<BouncingSize> with TickerProviderStateMixin {
  late final AnimationController slideController;
  late final AnimationController colorSizeController;
  late final Animation<Offset> offsetAnimation;
  late final Animation<Color?> colorAnimation;
  late final Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();

    slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    colorSizeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    offsetAnimation = Tween(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(slideController);

    final sizeTween = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 40, end: 80), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 80, end: 40), weight: 50),
      ],
    );
    sizeAnimation = sizeTween.animate(
      CurvedAnimation(
        parent: colorSizeController,
        curve: Curves.slowMiddle,
      ),
    );

    final colorTween = ColorTween(begin: Colors.grey, end: Colors.red);
    colorAnimation = colorTween.animate(colorSizeController);

    slideController.forward();
  }

  @override
  void dispose() {
    slideController.dispose();
    colorSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Bouncing Size",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: colorSizeController,
            builder: (context, child) {
              return SlideTransition(
                position: offsetAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (colorSizeController.isDismissed) colorSizeController.forward();
                        if (colorSizeController.isCompleted) colorSizeController.reverse();
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: colorAnimation.value,
                        size: sizeAnimation.value,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
