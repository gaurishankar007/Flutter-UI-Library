import 'package:flutter/material.dart';

class AnimatedPrompt extends StatelessWidget {
  const AnimatedPrompt({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF414868),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Animated Prompt",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Center(
          child: AnimatedPromptWidget(
            title: "Thank you for your order!",
            subTitle: "Your order will be delivered in 2 days. Enjoy!",
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            iconContainerColor: Colors.green,
          ),
        ),
      ),
    );
  }
}

class AnimatedPromptWidget extends StatefulWidget {
  final String title;
  final String subTitle;
  final Icon icon;
  final Color iconContainerColor;

  const AnimatedPromptWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.iconContainerColor,
  });

  @override
  State<AnimatedPromptWidget> createState() => _AnimatedPromptWidgetState();
}

class _AnimatedPromptWidgetState extends State<AnimatedPromptWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> iconScaleAnimation;
  late Animation<double> containerScaleAnimation;
  late Animation<Offset> containerOffsetAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    containerOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -.25),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    iconScaleAnimation = Tween<double>(
      begin: 7,
      end: 6,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    containerScaleAnimation = Tween<double>(
      begin: 2,
      end: .4,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController
      ..reset()
      ..repeat();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxWidth: MediaQuery.of(context).size.width * .8,
            maxHeight: MediaQuery.of(context).size.height * .8,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 150),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.subTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Fills the available space
              Positioned.fill(
                child: SlideTransition(
                  position: containerOffsetAnimation,
                  child: ScaleTransition(
                    scale: containerScaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.iconContainerColor,
                        shape: BoxShape.circle,
                      ),
                      child: ScaleTransition(
                        scale: iconScaleAnimation,
                        child: widget.icon,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
