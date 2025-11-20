import 'package:flutter/material.dart';

class BouncingPosition extends StatefulWidget {
  const BouncingPosition({super.key});

  @override
  State<BouncingPosition> createState() => _BouncingPositionState();
}

class _BouncingPositionState extends State<BouncingPosition> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(
      CurvedAnimation(
        curve: Curves.elasticIn,
        parent: controller,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Bouncing Position",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SlideTransition(
            position: offsetAnimation,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: const Icon(
                Icons.flutter_dash_rounded,
                color: Colors.deepPurple,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
